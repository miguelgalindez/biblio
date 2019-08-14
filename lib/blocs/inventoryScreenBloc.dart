import 'dart:async';

import 'package:biblio/blocs/blocBase.dart';
import 'package:biblio/models/tag.dart';
import 'package:flutter/services.dart';
import 'package:biblio/resources/repositories/tagsRepository.dart';
import 'package:rxdart/rxdart.dart';

class InventoryScreenBloc implements BlocBase {
  MethodChannel rfidReaderChannel;
  TagsRepository tagsRepository;
  PublishSubject<List<Tag>> tagsFetcher;
  BehaviorSubject<int> inventoryStatusReporter;

  void init() {
    // TODO Put this on a session singleton object or use it as lazy singleton
    tagsRepository = TagsRepository();
    rfidReaderChannel = MethodChannel("biblio/rfidReader/methodChannel");
    tagsFetcher = PublishSubject<List<Tag>>();
    inventoryStatusReporter = BehaviorSubject<int>();
    print("Initializing bloc...");
    reportStatus(0);

    rfidReaderChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onStatusChanged":
          reportStatus(call.arguments);
          break;        

        case "onData":          
          await tagsRepository.addTagsFromJson(call.arguments);
          print("# of tags: ${tagsRepository.tags.length}");
          tagsFetcher.sink.add(tagsRepository.getTagsAsCollection());          
          break;

        default:
          throw MissingPluginException();
      }
    });
  }

  Future<void> startInventory() async {
    try {      
      rfidReaderChannel.invokeMethod("startInventory");
    } catch (e) {
      print("Flutter start inventory exception: ${e.message}");
    }
  }

  Future<void> stopInventory() async {
    try {      
      rfidReaderChannel.invokeMethod("stopInventory");
    } catch (e) {
      print("Flutter stop inventory exception: ${e.message}");
    }
  }

  void reportStatus(int status) {
    print("Reporting status $status");
    inventoryStatusReporter.sink.add(status);
  }

  Observable<List<Tag>> get allTags => tagsFetcher.stream;
  Observable<int> get status => inventoryStatusReporter.stream.distinct();

  @override
  void dispose() {
    // TODO: Should i close or dispose the method channel?
    tagsFetcher.drain();
    tagsFetcher.close();
    inventoryStatusReporter.drain();
    inventoryStatusReporter.close();
  }
}

final inventoryScreenBloc = InventoryScreenBloc();
