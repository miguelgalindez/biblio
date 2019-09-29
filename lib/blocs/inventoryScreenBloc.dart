import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:biblio/blocs/deviceUtilititesBloc.dart';
import 'package:biblio/blocs/homeScreenBloc.dart';
import 'package:biblio/models/deviceCapabilities.dart';
import 'package:biblio/resources/repositories/rfidReaderRepository.dart';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/models/tag.dart';
import 'package:biblio/ui/screens/blocEvent.dart';

enum InventoryStatus { CLOSED, OPENED, INVENTORY_STARTED, INVENTORY_STOPPED }
enum InventoryAction {
  OPEN_READER,
  START_INVENTORY,
  STOP_INVENTORY,
  CLOSE_READER,
  DISCARD_TAG,
  DISCARD_ALL_TAGS,
}

class InventoryScreenBloc implements BlocBase {
  StreamSubscription<DeviceCapabilities> _deviceCapabilitiesSubscription;
  bool deviceCanReadRfidTags;
  RfidReaderRepository _rfidReaderRepository;
  StreamController<BlocEvent> _eventsController;
  StreamSubscription<BlocEvent> _eventsSubscription;
  BehaviorSubject<List<Tag>> _readTagsController;
  BehaviorSubject<InventoryStatus> _statusController;
  Timer _fetchTagsTimer;

  InventoryScreenBloc() {
    print("[InventoryScreenBloc] New instance created");
  }

  Future<void> init() async {
    print("[InventoryScreenBloc] Initializing bloc...");
    deviceCanReadRfidTags = false;
    _deviceCapabilitiesSubscription =
        deviceUtilitiesBloc.deviceCapabilities.listen((deviceCapabilities) {
      
      /// Ensures that the bloc won't be initialized twice or more times in a row.
      if (deviceCapabilities.rfidTagsReading &&
          deviceCanReadRfidTags == false) {
        deviceCanReadRfidTags = true;
        _eventsController = StreamController<BlocEvent>();
        _readTagsController = BehaviorSubject<List<Tag>>();
        _statusController = BehaviorSubject<InventoryStatus>();
        _eventsSubscription = _eventsController.stream.listen(_actionHandler);

        _rfidReaderRepository = RfidReaderRepository(
          onTagsRead: _reportTags,
          onStatusChanged: _handleStatusChanged,
        );
        _rfidReaderRepository.init();
        _reportTags();
        _rfidReaderRepository.requestReaderStatus(_reportError);
      }
    });
  }

  @override
  void dispose() {
    print("[InventoryScreenBloc] Disposing...");
    _deviceCapabilitiesSubscription.cancel();
    if (deviceCanReadRfidTags) {
      onLeaveScreen();
      _eventsSubscription.cancel();
      _eventsController.close();
      _readTagsController.close();
      _statusController.close();
      _rfidReaderRepository.dispose();
    }
  }

  /// Bloc endpoints for the UI
  Sink<BlocEvent> get events => _eventsController.sink;
  Observable<List<Tag>> get readTags => _readTagsController.stream.distinct();
  Observable<InventoryStatus> get status => _statusController.stream.distinct();
  Observable<InventoryStatusWithReadTags> get statusWithReadTags =>
      Observable.combineLatest2(
        status,
        readTags,
        (status, readTags) =>
            InventoryStatusWithReadTags(status: status, readTags: readTags),
      );

  Future<void> onShowScreen() async {
    if (deviceCanReadRfidTags) {
      InventoryStatus currentStatus = _statusController.value;
      if (currentStatus == null || currentStatus == InventoryStatus.CLOSED) {
        events.add(BlocEvent(action: InventoryAction.OPEN_READER));
      }

      deviceUtilitiesBloc.eventsSink.add(BlocEvent(
        action: DeviceUtilitiesActions.ORIENTATION_SET_ONLY_PORTRAIT_UP,
      ));
    }
  }

  Future<void> onLeaveScreen() async {
    if (deviceCanReadRfidTags) {
      InventoryStatus currentStatus = _statusController.value;
      List<Tag> readTags = _readTagsController.value;

      /// If there are no read tags, then close the reader
      if (readTags.isEmpty && currentStatus != InventoryStatus.CLOSED) {
        events.add(BlocEvent(action: InventoryAction.CLOSE_READER));
      } else if (currentStatus == InventoryStatus.INVENTORY_STARTED) {
        events.add(BlocEvent(action: InventoryAction.STOP_INVENTORY));
      }

      deviceUtilitiesBloc.eventsSink.add(BlocEvent(
        action: DeviceUtilitiesActions.ORIENTATION_SET_ALL,
      ));
    }
  }

  /// Handles the action required for the user
  Future<void> _actionHandler(BlocEvent event) async {
    switch (event.action) {
      case InventoryAction.OPEN_READER:
        _rfidReaderRepository.openReader((String message) async {
          _reportStatus(null);
          _reportError(message);
        });
        break;
      case InventoryAction.START_INVENTORY:
        _rfidReaderRepository.startInventory(_reportError);
        break;
      case InventoryAction.STOP_INVENTORY:
        _rfidReaderRepository.stopInventory(_reportError);
        break;
      case InventoryAction.CLOSE_READER:
        _rfidReaderRepository.closeReader(_reportError);
        break;
      case InventoryAction.DISCARD_TAG:
        _rfidReaderRepository.discardTag(event.data, _reportTags, _reportError);
        break;
      case InventoryAction.DISCARD_ALL_TAGS:
        _rfidReaderRepository.clear(_reportTags, _reportError);
        break;
    }
  }

  /// Process the status change
  Future<void> _handleStatusChanged(int newStatus) async {
    InventoryStatus status = _translateStatus(newStatus);
    _reportStatus(status);

    /// While the inventory scanning is running, asks the reader to
    /// send the read tags periodically
    if (status == InventoryStatus.INVENTORY_STARTED) {
      _runPeriodicTagsFetching();
    } else {
      _stopPeriodicTagsFetching();
    }
  }

  /// Broadcast, towards the UI, the status reported from the reader
  Future<void> _reportStatus(InventoryStatus status) async {
    print("Reporting status $status");
    _statusController.sink.add(status);
  }

  Future<void> _reportError(String message) async {
    homeScreenBloc.eventsSink.add(BlocEvent(
      action: HomeScreenActions.ADD_SNACKBAR,
      data: SnackBar(
        content: Text(message),
        elevation: 16,
      ),
    ));
  }

  Future<void> _reportTags() async {
    _readTagsController.sink.add(_rfidReaderRepository.getReadTags());
  }

  /// Starts the periodic tags fetching, asking the reader
  /// to send the read tags every 500 ms.
  Future<void> _runPeriodicTagsFetching() async {
    if (_fetchTagsTimer == null || !_fetchTagsTimer.isActive) {
      _fetchTagsTimer = Timer.periodic(
        Duration(milliseconds: 500),
        (Timer t) async => _rfidReaderRepository.requestReadTags(),
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
        return InventoryStatus.INVENTORY_STARTED;

      case 3:
        return InventoryStatus.INVENTORY_STOPPED;

      default:
        return null;
    }
  }
}

class InventoryStatusWithReadTags {
  final InventoryStatus status;
  final List<Tag> readTags;

  InventoryStatusWithReadTags({this.status, this.readTags});
}

final inventoryScreenBloc = InventoryScreenBloc();
