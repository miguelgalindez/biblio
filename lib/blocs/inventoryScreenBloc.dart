import 'dart:async';

import 'package:biblio/blocs/blocBase.dart';
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
enum InventoryAction { OPEN, START_INVENTORY, STOP_INVENTORY }

class InventoryScreenBloc implements BlocBase {
  MethodChannel _rfidReaderChannel;
  TagsRepository _tagsRepository;
  StreamController<InventoryAction> _actionReporter;
  StreamSubscription<InventoryAction> _actionSubscription;
  BehaviorSubject<List<Tag>> _tagsReporter;
  BehaviorSubject<InventoryStatus> _statusReporter;

  void init() {
    // TODO Put this on a session singleton object or use it as lazy singleton
    _tagsRepository = TagsRepository();
    _rfidReaderChannel = MethodChannel("biblio/rfidReader/methodChannel");
    _actionReporter = StreamController<InventoryAction>();
    _tagsReporter = BehaviorSubject<List<Tag>>();
    _statusReporter = BehaviorSubject<InventoryStatus>();
    print("Initializing bloc...");
    _reportStatus(InventoryStatus.CLOSED);

    _actionSubscription =
        _actionReporter.stream.distinct().listen(_actionHandler);
    _rfidReaderChannel.setMethodCallHandler(_rfidReaderMethodChannelHandler);
  }

  Sink<InventoryAction> get actions => _actionReporter.sink;
  Observable<List<Tag>> get allTags => _tagsReporter.stream.distinct();
  Observable<InventoryStatus> get status => _statusReporter.stream.distinct();

  Future<void> _actionHandler(InventoryAction action) async {
    switch (action) {
      case InventoryAction.OPEN:
        _open();
        break;
      case InventoryAction.START_INVENTORY:
        _startInventory();
        break;
      case InventoryAction.STOP_INVENTORY:
        _stopInventory();
        break;
    }
  }

  Future<void> _rfidReaderMethodChannelHandler(MethodCall call) async {
    switch (call.method) {
      case "onStatusChanged":
        _reportStatus(_translateStatus(call.arguments));
        break;

      case "onData":
        _proccessReadTags(call);
        break;

      default:
        throw MissingPluginException();
    }
  }

  Future<void> _open() async {
    try {
      await _rfidReaderChannel.invokeMethod("open");
    } catch (e) {
      print("Flutter open exception: ${e.message}");
    }
  }

  Future<void> _close() async {
    try {
      await _rfidReaderChannel.invokeMethod("close");
    } catch (e) {
      print("Flutter close exception: ${e.message}");
    }
  }

  Future<void> _startInventory() async {
    try {
      await _rfidReaderChannel.invokeMethod("startInventory");
    } catch (e) {
      print("Flutter start inventory exception: ${e.message}");
    }
  }

  Future<void> _stopInventory() async {
    try {
      await _rfidReaderChannel.invokeMethod("stopInventory");
    } catch (e) {
      print("Flutter stop inventory exception: ${e.message}");
    }
  }

  Future<void> _proccessReadTags(MethodCall call) async {
    await _tagsRepository.addTagsFromJson(call.arguments);

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

  void _reportStatus(InventoryStatus status) {
    print("Reporting status $status");
    _statusReporter.sink.add(status);
  }

  @override
  void dispose() {
    // TODO: Should i close or dispose the method channel?
    print("[InventoryScreenBloc] Disposing...");
    _actionSubscription.cancel();    
    _actionReporter.close();
    _tagsReporter.drain();
    _tagsReporter.close();
    _statusReporter.drain();
    _statusReporter.close();
    // FIXME: close the rfid reader
    //_close();
  }
}

final inventoryScreenBloc = InventoryScreenBloc();
