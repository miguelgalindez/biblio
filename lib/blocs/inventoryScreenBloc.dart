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
  MethodChannel rfidReaderChannel;
  TagsRepository tagsRepository;
  StreamController<InventoryAction> actionReporter;
  StreamSubscription<InventoryAction> actionSubscription;
  BehaviorSubject<List<Tag>> tagsReporter;
  BehaviorSubject<InventoryStatus> statusReporter;

  void init() {
    // TODO Put this on a session singleton object or use it as lazy singleton
    tagsRepository = TagsRepository();
    rfidReaderChannel = MethodChannel("biblio/rfidReader/methodChannel");
    actionReporter = StreamController<InventoryAction>();
    tagsReporter = BehaviorSubject<List<Tag>>();
    statusReporter = BehaviorSubject<InventoryStatus>();
    print("Initializing bloc...");
    _reportStatus(InventoryStatus.CLOSED);

    actionSubscription = actionReporter.stream.listen((InventoryAction action) {
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
    });

    rfidReaderChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onStatusChanged":
          _reportStatus(_translateStatus(call.arguments));
          break;

        case "onData":
          await tagsRepository.addTagsFromJson(call.arguments);
          print("# of tags: ${tagsRepository.tags.length}");
          tagsReporter.sink.add(tagsRepository.getTagsAsCollection());
          break;

        default:
          throw MissingPluginException();
      }
    });
  }

  Sink<InventoryAction> get actions => actionReporter.sink;
  Observable<List<Tag>> get allTags => tagsReporter.stream;
  Observable<InventoryStatus> get status => statusReporter.stream.distinct();

  Future<void> _open() async {
    try {
      await rfidReaderChannel.invokeMethod("open");
    } catch (e) {
      print("Flutter open exception: ${e.message}");
    }
  }

  Future<void> _startInventory() async {
    try {
      await rfidReaderChannel.invokeMethod("startInventory");
    } catch (e) {
      print("Flutter start inventory exception: ${e.message}");
    }
  }

  Future<void> _stopInventory() async {
    try {
      await rfidReaderChannel.invokeMethod("stopInventory");
    } catch (e) {
      print("Flutter stop inventory exception: ${e.message}");
    }
  }

  InventoryStatus _translateStatus(int status) {
    switch (status) {
      case 0:
        return InventoryStatus.CLOSED;

      case 1:
        return InventoryStatus.OPENED;

      case 2:
        return tagsRepository.tags.length > 0
            ? InventoryStatus.INVENTORY_STARTED_WITH_TAGS
            : InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS;

      case 3:
        return tagsRepository.tags.length > 0
            ? InventoryStatus.INVENTORY_STOPPED_WITH_TAGS
            : InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS;

      default:
        return null;
    }
  }

  void _reportStatus(InventoryStatus status) {
    print("Reporting status $status");
    statusReporter.sink.add(status);
  }

  @override
  void dispose() {
    // TODO: Should i close or dispose the method channel?
    actionSubscription.cancel();
    actionReporter.close();
    tagsReporter.drain();
    tagsReporter.close();
    statusReporter.drain();
    statusReporter.close();
  }
}

final inventoryScreenBloc = InventoryScreenBloc();
