import 'dart:async';
import 'package:flutter/services.dart';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:biblio/models/deviceCapabilities.dart';
import 'package:biblio/resources/repositories/deviceUtilitiesRepository.dart';
import 'package:biblio/ui/screens/blocEvent.dart';

enum DeviceUtilitiesActions {
  ORIENTATION_SET_ONLY_PORTRAIT_UP,
  ORIENTATION_SET_ALL,
  DEVICE_CAPABILITIES_LOAD,
  DEVICE_CAPABILITIES_LOADED
}

class DeviceUtilitiesBloc extends BlocBase {
  BehaviorSubject<BlocEvent> _eventsController;
  StreamSubscription<BlocEvent> _eventsSubscription;
  DeviceUtilitiesRepository _deviceUtilitiesRepository;

  void init() {
    print('[DeviceUtilities] initilizing');
    _eventsController = BehaviorSubject<BlocEvent>();
    _deviceUtilitiesRepository = DeviceUtilitiesRepository();
    _deviceUtilitiesRepository.init();
    _eventsSubscription =
        _eventsController.stream.distinct().listen(_eventsHandler);
  }

  @override
  void dispose() {
    print('[DeviceUtilities] Disposing');
    _eventsSubscription.cancel();
    _eventsController.close();
    _deviceUtilitiesRepository.dispose();
  }

  Sink<BlocEvent> get eventsSink => _eventsController.sink;
  Observable<BlocEvent> get events => _eventsController.stream;
  Observable<DeviceCapabilities> get deviceCapabilities => _eventsController
      .where((event) =>
          event.action == DeviceUtilitiesActions.DEVICE_CAPABILITIES_LOADED)
      .distinct()
      .transform(StreamTransformer<BlocEvent, DeviceCapabilities>.fromHandlers(
          handleData: (event, sink) => sink.add(event.data)));

  Future<void> _eventsHandler(BlocEvent event) async {
    switch (event.action) {
      case DeviceUtilitiesActions.ORIENTATION_SET_ONLY_PORTRAIT_UP:
        _setPreferredOrientations([DeviceOrientation.portraitUp]);
        break;
      case DeviceUtilitiesActions.ORIENTATION_SET_ALL:
        _clearPreferredOrientations();
        break;
      case DeviceUtilitiesActions.DEVICE_CAPABILITIES_LOAD:
        _loadDeviceCapabilities();
        break;
      default:
    }
  }

  Future<void> _loadDeviceCapabilities() async {
    DeviceCapabilities deviceCapabilities =
        await _deviceUtilitiesRepository.getDeviceCapabilities();

    eventsSink.add(BlocEvent(
      action: DeviceUtilitiesActions.DEVICE_CAPABILITIES_LOADED,
      data: deviceCapabilities,
    ));
  }

  Future<void> _setPreferredOrientations(
      List<DeviceOrientation> orientations) async {
    SystemChrome.setPreferredOrientations(orientations);
  }

  Future<void> _clearPreferredOrientations() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

final deviceUtilitiesBloc = DeviceUtilitiesBloc();
