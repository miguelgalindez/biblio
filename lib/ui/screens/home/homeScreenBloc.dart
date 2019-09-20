import 'dart:async';
import 'package:biblio/models/deviceCapabilities.dart';
import 'package:biblio/resources/repositories/screensRepository.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/ui/screens/inventory/inventoryScreenBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/ui/screens/blocBase.dart';

enum HomeScreenActions {
  LOAD_AVAILABLE_SCREENS,
  SWITCH_TO_SCREEN,
  ADD_SNACKBAR
}

class HomeScreenBloc extends BlocBase {
  MethodChannel _deviceUtilitiesChannel;
  // TODO: delete this. and Handle as an event
  BehaviorSubject<List<Screen>> _availableScreensSubject;
  BehaviorSubject<BlocEvent> _eventSubject;
  ScreensRepository _screensRepository;
  // TODO: get it using injection
  DeviceCapabilities _deviceCapabilities;

  void init() async {
    _deviceUtilitiesChannel = MethodChannel('biblio/utilities');
    _availableScreensSubject = BehaviorSubject<List<Screen>>();
    _eventSubject = BehaviorSubject<BlocEvent>();
    _screensRepository = ScreensRepository();

    _deviceCapabilities = await _getDeviceCapabilities();
    await inventoryScreenBloc.init(_deviceCapabilities);
    await _loadScreens();
  }

  @override
  void dispose() {
    inventoryScreenBloc.dispose();
    _availableScreensSubject.close();
    _eventSubject.close();
    _screensRepository.dispose();
  }

  Future<void> _loadScreens() async {
    await _screensRepository.loadAvailableScreens(_deviceCapabilities);
    _availableScreensSubject.sink.add(_screensRepository.screens);
    eventsSink
        .add(BlocEvent(action: HomeScreenActions.SWITCH_TO_SCREEN, data: 0));
  }

  /// Stream for all events of any kind
  Sink<BlocEvent> get eventsSink => _eventSubject.sink;

  /// Stream for snackbars. (It transmits only ADD_SNACKBAR events)
  Observable<BlocEvent> get snackBars => _eventSubject
      .where((event) => event.action == HomeScreenActions.ADD_SNACKBAR)
      .distinct();  

  /// Strem for available screens
  Observable<List<Screen>> get availableScreens =>
      _availableScreensSubject.stream.distinct();

  // Report a Future instead of a Screen
  Observable<Screen> get currentScreen => _eventSubject.stream
      .where((BlocEvent event) =>
          event.action == HomeScreenActions.SWITCH_TO_SCREEN)
      .distinct()
      .transform(_getCurrentScreenStreamTransformer());

  Observable<CurrentScreenAndAvailableScreens>
      get currentScreenAndAvailableScreens => currentScreen.withLatestFrom(
          availableScreens,
          (currentScreen, availableScreens) => CurrentScreenAndAvailableScreens(
              currentScreen: currentScreen,
              availableScreens: availableScreens));

  StreamTransformer<BlocEvent, Screen> _getCurrentScreenStreamTransformer() {
    return StreamTransformer<BlocEvent, Screen>.fromHandlers(
        handleData: (event, sink) {
      if (_screensRepository.screens.isNotEmpty) {
        int index = event.data;
        // TODO: check if index is out of bounds. If so, return "Not found" screen
        Screen screen = _screensRepository.screens[index];
        if (screen.body == null) {
          screen.body = _screensRepository.getScreenWidget(screen.id);
        }
        sink.add(screen);
      } else {
        // todo: build the NoScreensAvailable screen
      }
    });
  }

  /// Adds the snackbar to the screens that are listening
  /// To do that, it push a new ADD_SNACKBAR event
  Future<void> addSnackBar(SnackBar snackBar) async {
    eventsSink.add(BlocEvent(
      action: HomeScreenActions.ADD_SNACKBAR,
      data: snackBar,
    ));
  }

  // todo: move this to Session Repository
  Future<DeviceCapabilities> _getDeviceCapabilities() async {
    DeviceCapabilities deviceCapabilities = DeviceCapabilities();
    List<dynamic> capabilities =
        await _deviceUtilitiesChannel.invokeMethod('getDeviceCapabilities');
    capabilities.cast<String>().forEach((String capability) {
      switch (capability) {
        case "camera":
          deviceCapabilities.camera = true;
          break;
        case "rfidTagsReading":
          deviceCapabilities.rfidTagsReading = true;
          break;
      }
    });

    print(
        "Camera: ${deviceCapabilities.camera}. RFID tags reading: ${deviceCapabilities.rfidTagsReading}");
    return deviceCapabilities;
  }
}

class CurrentScreenAndAvailableScreens {
  final Screen currentScreen;
  final List<Screen> availableScreens;

  CurrentScreenAndAvailableScreens(
      {@required this.currentScreen, @required this.availableScreens});
}

final homeScreenBloc = HomeScreenBloc();
