import 'dart:async';

import 'package:biblio/models/deviceCapabilities.dart';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/models/tag.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
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
  CLOSE_READER,
  DISCARD_TAG,
  DISCARD_ALL_TAGS,
}

class InventoryScreenBloc implements BlocBase {
  MethodChannel _rfidReaderChannel;
  DeviceCapabilities deviceCapabilities;
  TagsRepository _tagsRepository;
  StreamController<BlocEvent> _actionReporter;
  StreamSubscription<BlocEvent> _actionSubscription;
  BehaviorSubject<List<Tag>> _tagsReporter;
  BehaviorSubject<InventoryStatus> _statusReporter;
  Timer _fetchTagsTimer;
  double _readerRssiAtOneMeter;

  InventoryScreenBloc() {
    print("[InventoryScreenBloc] New instance created");
  }

  // todo: inject capabilities
  Future<void> init(DeviceCapabilities capabilities) async {
    print("[InventoryScreenBloc] Initializing bloc...");
    deviceCapabilities = capabilities;
    if (deviceCapabilities.rfidTagsReading) {
      _rfidReaderChannel = MethodChannel("biblio/rfidReader");
      _tagsRepository = TagsRepository();
      _actionReporter = StreamController<BlocEvent>();
      _tagsReporter = BehaviorSubject<List<Tag>>();
      _statusReporter = BehaviorSubject<InventoryStatus>();
      _actionSubscription = _actionReporter.stream.listen(_actionHandler);
      _rfidReaderChannel.setMethodCallHandler(_rfidReaderMethodChannelHandler);
      _getReaderStatus();
    }
  }

  @override
  void dispose() {
    // todo: should i drain streams?
    print("[InventoryScreenBloc] Disposing...");
    if (deviceCapabilities.rfidTagsReading) {
      _actionSubscription.cancel();
      _actionReporter.close();
      _tagsReporter.drain();
      _tagsReporter.close();
      _statusReporter.drain();
      _statusReporter.close();
      _tagsRepository.dispose();
      _closeReader();
    }
  }

  /// Bloc endpoints for the UI
  Sink<BlocEvent> get events => _actionReporter.sink;
  Observable<List<Tag>> get allTags => _tagsReporter.stream.distinct();
  Observable<InventoryStatus> get status => _statusReporter.stream.distinct();


  Future<void> onShowScreen() async {
    if (deviceCapabilities.rfidTagsReading) {
      InventoryStatus currentStatus = _statusReporter.value;
      if (currentStatus == null || currentStatus == InventoryStatus.CLOSED) {
        _openReader();
      }
    }
  }

  Future<void> onLeaveScreen() async {
    if (deviceCapabilities.rfidTagsReading) {
      InventoryStatus currentStatus = _statusReporter.value;
      if (currentStatus == InventoryStatus.INVENTORY_STARTED_WITH_TAGS) {
        _stopInventory();
      } else if (currentStatus != InventoryStatus.INVENTORY_STOPPED_WITH_TAGS &&
          currentStatus != InventoryStatus.CLOSED) {
        _closeReader();
      }
    }
  }

  /// Handles the action required for the user
  Future<void> _actionHandler(BlocEvent event) async {
    switch (event.action) {
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
      case InventoryAction.DISCARD_TAG:
        _discardTag(event.data);
        break;
      case InventoryAction.DISCARD_ALL_TAGS:
        _clear();
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
  Future<void> _getReaderStatus() async {
    try {
      await _rfidReaderChannel.invokeMethod("reportCurrentStatus");
    } catch (e) {
      print("Flutter reportCurrentStatus exception: ${e.message}");
    }
  }

  /// Asks the reader to open itself and to be ready for scanning
  Future<void> _openReader() async {
    try {
      print("[InventoryScreenBloc] Opening the reader");
      await Future.delayed(const Duration(seconds: 3), () {});

      await _rfidReaderChannel.invokeMethod("open");
    } catch (e) {
      print("Flutter open exception: ${e.message}");
    }
  }

  /// Asks the reader to close itself and release its held resources
  Future<void> _closeReader() async {
    print("[InventoryScreenBloc] Closing the reader");
    try {
      await _rfidReaderChannel.invokeMethod("close");
    } catch (e) {
      print("Flutter close exception: ${e.message}");
    }
  }

  /// Asks the reader to start the inventory scanning
  Future<void> _startInventory() async {
    print("[InventoryScreenBloc] Starting inventory");
    try {
      await _rfidReaderChannel.invokeMethod("startInventory");
    } catch (e) {
      print("Flutter start inventory exception: ${e.message}");
    }
  }

  /// Asks the reader to stop the inventory scanning
  Future<void> _stopInventory() async {
    print("[InventoryScreenBloc] Stopping inventory");
    try {
      await _rfidReaderChannel.invokeMethod("stopInventory");
    } catch (e) {
      print("Flutter stop inventory exception: ${e.message}");
    }
  }

  /// Asks the reader to clear the read tags collection
  Future<void> _clear() async {
    print("[InventoryScreenBloc] Clearing");
    try {
      _tagsRepository.clear(_reportTags);
      await _rfidReaderChannel.invokeMethod("clear");
      _reportStatus(InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS);
    } catch (e) {
      print("Flutter clear inventory exception: ${e.message}");
    }
  }

  /// Asks the reader to discard a single tag
  Future<void> _discardTag(String tagEpc) async {
    print("[InventoryScreenBloc] Discarding tag $tagEpc");
    try {
      _tagsRepository.removeTag(tagEpc, _reportTags);
      await _rfidReaderChannel.invokeMethod("discardTag", tagEpc);
    } catch (e) {
      print("Flutter _discardTag exception: ${e.message}");
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
    print("[InventoryScreenBloc] Getting rssi at one meter");
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
    if (call.arguments.length > 0) {
      await _tagsRepository.addTagsFromJson(
          call.arguments, _readerRssiAtOneMeter, _reportTags);

      if (_tagsRepository.tags.length > 0) {
        InventoryStatus currentStatus = _statusReporter.value;
        if (currentStatus == InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS) {
          _reportStatus(InventoryStatus.INVENTORY_STARTED_WITH_TAGS);
        } else if (currentStatus !=
                InventoryStatus.INVENTORY_STARTED_WITH_TAGS &&
            currentStatus != InventoryStatus.INVENTORY_STOPPED_WITH_TAGS) {
          _reportStatus(InventoryStatus.INVENTORY_STOPPED_WITH_TAGS);
        }
      }
    }
  }

  /// Process the status change
  Future<void> _processStatusChange(InventoryStatus status) async {
    _reportStatus(status);

    if (status == InventoryStatus.OPENED) {
      _readerRssiAtOneMeter = await _getRssiAtOneMeter();
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

  Future<void> _reportTags() async {
    _tagsReporter.sink.add(_tagsRepository.getTagsAsCollection());
  }

  /// Starts the periodic tags fetching, asking the reader
  /// to send the read tags every 500 ms.
  Future<void> _runPeriodicTagsFetching() async {
    if (_fetchTagsTimer == null || !_fetchTagsTimer.isActive) {
      _fetchTagsTimer = Timer.periodic(
        Duration(milliseconds: 500),
        (Timer t) async => _requestReadTags(),
      );
      print(
          "[InventoryScreenBloc] periodicTagsFetching is active ? ${_fetchTagsTimer.isActive}");
    }
  }

  /// Stops the periodic tags fetching
  Future<void> _stopPeriodicTagsFetching() async {
    if (_fetchTagsTimer != null && _fetchTagsTimer.isActive) {
      _fetchTagsTimer.cancel();
      print(
          "[InventoryScreenBloc] periodicTagsFetching is active ? ${_fetchTagsTimer.isActive}");
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
