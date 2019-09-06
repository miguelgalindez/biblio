import 'dart:async';

import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/models/tag.dart';
import 'package:flutter/services.dart';
import 'package:biblio/resources/repositories/tagsRepository.dart';
import 'package:rxdart/rxdart.dart';

enum InventoryStatus {
  CLOSED,
  OPENED,
  INVENTORY_STARTED_WITHOUT_TAGS,
  INVENTORY_STOPPED_WITHOUT_TAGS,
  INVENTORY_STARTED_WITH_TAGS,
  INVENTORY_STOPPED_WITH_TAGS
}
enum InventoryAction {
  OPEN_READER,
  START_INVENTORY,
  STOP_INVENTORY,
  CLOSE_READER
}

class InventoryScreenBloc implements BlocBase {
  MethodChannel _rfidReaderChannel;
  TagsRepository _tagsRepository;
  StreamController<InventoryAction> _actionReporter;
  StreamSubscription<InventoryAction> _actionSubscription;
  BehaviorSubject<List<Tag>> _tagsReporter;
  BehaviorSubject<InventoryStatus> _statusReporter;
  Timer _fetchTagsTimer;
  double readerRssiAtOneMeter;

  InventoryScreenBloc() {
    print("[InventoryScreenBloc] New instance created");
  }

  void init() {
    // TODO Put this on a session singleton object or use it as lazy singleton
    print("[InventoryScreenBloc] Initializing bloc...");
    _tagsRepository = TagsRepository();
    _rfidReaderChannel = MethodChannel("biblio/rfidReader/methodChannel");
    _actionReporter = StreamController<InventoryAction>();
    _tagsReporter = BehaviorSubject<List<Tag>>();
    _statusReporter = BehaviorSubject<InventoryStatus>();
    _actionSubscription = _actionReporter.stream.listen(_actionHandler);
    _rfidReaderChannel.setMethodCallHandler(_rfidReaderMethodChannelHandler);
    _requestReaderStatus();
  }

  @override
  void dispose() {
    // TODO: Should i close or dispose the method channel?
    // todo: should i drain streams?
    print("[InventoryScreenBloc] Disposing...");
    _actionSubscription.cancel();
    _actionReporter.close();
    _tagsReporter.drain();
    _tagsReporter.close();
    _statusReporter.drain();
    _statusReporter.close();
    _stopPeriodicTagsFetching();
    // FIXME: close the rfid reader
    //_close();
  }

  /// Bloc endpoints for the UI
  Sink<InventoryAction> get actions => _actionReporter.sink;
  Observable<List<Tag>> get allTags => _tagsReporter.stream.distinct();
  Observable<InventoryStatus> get status => _statusReporter.stream.distinct();

  /// Handles the action required for the user
  Future<void> _actionHandler(InventoryAction action) async {
    switch (action) {
      case InventoryAction.OPEN_READER:
        _openReader();
        break;
      case InventoryAction.START_INVENTORY:
        _startInventory();
        break;
      case InventoryAction.STOP_INVENTORY:
        _stopInventory();
        break;
      case InventoryAction.CLOSE_READER:
        break;
    }
  }

  /// Handles the method calls made by the reader (native code).
  /// It includes callbacks for reader events.
  Future<void> _rfidReaderMethodChannelHandler(MethodCall call) async {
    switch (call.method) {
      case "onStatusChanged":
        _processStatusChange(_translateStatus(call.arguments));
        break;

      case "onData":
        _processReadTags(call);
        break;

      default:
        throw MissingPluginException();
    }
  }

  /// Asks the reader for its current status
  Future<void> _requestReaderStatus() async {
    try {
      await _rfidReaderChannel.invokeMethod("reportCurrentStatus");
    } catch (e) {
      print("Flutter reportCurrentStatus exception: ${e.message}");
    }
  }

  /// Asks the reader to open itself and to be ready for scanning
  Future<void> _openReader() async {
    try {
      await _rfidReaderChannel.invokeMethod("open");
    } catch (e) {
      print("Flutter open exception: ${e.message}");
    }
  }

  /// Asks the reader to close itself and release its held resources
  Future<void> _closeReader() async {
    try {
      await _rfidReaderChannel.invokeMethod("close");
    } catch (e) {
      print("Flutter close exception: ${e.message}");
    }
  }

  /// Asks the reader to start the inventory scanning
  Future<void> _startInventory() async {
    try {
      await _rfidReaderChannel.invokeMethod("startInventory");
    } catch (e) {
      print("Flutter start inventory exception: ${e.message}");
    }
  }

  /// Asks the reader to stop the inventory scanning
  Future<void> _stopInventory() async {
    try {
      await _rfidReaderChannel.invokeMethod("stopInventory");
    } catch (e) {
      print("Flutter stop inventory exception: ${e.message}");
    }
  }

  /// Asks the reader to send/report the read tags
  Future<void> _requestReadTags() async {
    try {
      await _rfidReaderChannel.invokeMethod("sendTags");
    } catch (e) {
      print("Flutter _requestReadTags exception: ${e.message}");
    }
  }

  /// Gets the reader's received signal strength in dBm at 1 metre
  Future<double> _getRssiAtOneMeter() async {
    try {
      return await _rfidReaderChannel.invokeMethod("getRssiAtOneMeter");
    } catch (e) {
      print("Flutter _getRssiAtOneMeter exception: ${e.message}");
    }
    return null;
  }

  /// Process the read tags reported by the reader
  Future<void> _processReadTags(MethodCall call) async {
    print(
        "[InventoryScreenBloc] Processing read tags: ${call.arguments.length}");
    await _tagsRepository.addTagsFromJson(call.arguments, readerRssiAtOneMeter);

    if (_tagsRepository.tags.length > 0) {
      _tagsReporter.sink.add(_tagsRepository.getTagsAsCollection());

      InventoryStatus currentStatus = _statusReporter.value;
      if (currentStatus == InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS) {
        _reportStatus(InventoryStatus.INVENTORY_STARTED_WITH_TAGS);
      } else if (currentStatus != InventoryStatus.INVENTORY_STARTED_WITH_TAGS &&
          currentStatus != InventoryStatus.INVENTORY_STOPPED_WITH_TAGS) {
        _reportStatus(InventoryStatus.INVENTORY_STOPPED_WITH_TAGS);
      }
    }
  }

  Future<void> _processStatusChange(InventoryStatus status) async {
    _reportStatus(status);

    if (status == InventoryStatus.OPENED) {
      readerRssiAtOneMeter = await _getRssiAtOneMeter();
    }

    /// While the inventory scanning is running, asks the reader to
    /// send the read tags periodically
    if (status == InventoryStatus.INVENTORY_STARTED_WITH_TAGS ||
        status == InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS) {
      _runPeriodicTagsFetching();
    } else {
      _stopPeriodicTagsFetching();
    }
  }

  /// Broadcast, towards the UI, the status reported from the reader
  Future<void> _reportStatus(InventoryStatus status) async {
    print("Reporting status $status");
    _statusReporter.sink.add(status);
  }

  /// Starts the periodic tags fetching, asking the reader
  /// to send the read tags every 500 ms.
  Future<void> _runPeriodicTagsFetching() async {
    if (_fetchTagsTimer == null || !_fetchTagsTimer.isActive) {
      _fetchTagsTimer = Timer.periodic(
        Duration(milliseconds: 500),
        (Timer t) async => _requestReadTags(),
      );
    }
  }

  /// Stops the periodic tags fetching
  Future<void> _stopPeriodicTagsFetching() async {
    if (_fetchTagsTimer != null && _fetchTagsTimer.isActive) {
      _fetchTagsTimer.cancel();
    }
  }

  /// Translates the status reported by the reader
  InventoryStatus _translateStatus(int status) {
    switch (status) {
      case 0:
        return InventoryStatus.CLOSED;

      case 1:
        return InventoryStatus.OPENED;

      case 2:
        return _tagsRepository.tags.length > 0
            ? InventoryStatus.INVENTORY_STARTED_WITH_TAGS
            : InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS;

      case 3:
        return _tagsRepository.tags.length > 0
            ? InventoryStatus.INVENTORY_STOPPED_WITH_TAGS
            : InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS;

      default:
        return null;
    }
  }
}

final inventoryScreenBloc = InventoryScreenBloc();
