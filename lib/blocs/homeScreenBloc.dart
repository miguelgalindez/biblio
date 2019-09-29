import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:biblio/blocs/deviceUtilititesBloc.dart';
import 'package:biblio/models/deviceCapabilities.dart';
import 'package:biblio/resources/repositories/screensRepository.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/ui/screens/blocBase.dart';

enum HomeScreenActions {
  AVAILABLE_SCREENS_LOADED,
  SWITCH_TO_SCREEN,
  ADD_SNACKBAR
}

class HomeScreenBloc extends BlocBase {
  BehaviorSubject<BlocEvent> _eventsController;
  ScreensRepository _screensRepository;
  StreamSubscription<DeviceCapabilities> _deviceCapabilitiesSubscription;

  void init() async {
    _screensRepository = ScreensRepository();
    _screensRepository.init();
    _deviceCapabilitiesSubscription =
        deviceUtilitiesBloc.deviceCapabilities.listen(_loadScreens);
    _eventsController = BehaviorSubject<BlocEvent>();
    await inventoryScreenBloc.init();
  }

  @override
  void dispose() {
    _deviceCapabilitiesSubscription.cancel();
    inventoryScreenBloc.dispose();
    _eventsController.close();
    _screensRepository.dispose();
  }

  Future<void> _loadScreens(DeviceCapabilities deviceCapabilities) async {
    await _screensRepository.loadAvailableScreens(deviceCapabilities);

    eventsSink.add(BlocEvent(
      action: HomeScreenActions.AVAILABLE_SCREENS_LOADED,
      data: _screensRepository.screens,
    ));

    eventsSink.add(BlocEvent(
      action: HomeScreenActions.SWITCH_TO_SCREEN,
      data: 0,
    ));
  }

  /// Stream for all events of any kind
  Sink<BlocEvent> get eventsSink => _eventsController.sink;

  /// Stream for snackbars. (It transmits only ADD_SNACKBAR events)
  Observable<SnackBar> get snackBars => _eventsController
      .where((event) => event.action == HomeScreenActions.ADD_SNACKBAR)
      .distinct()
      .transform(_getSnackbarsTransformer());

  /// Stream for available screens
  Observable<List<Screen>> get availableScreens => _eventsController
      .where((BlocEvent event) =>
          event.action == HomeScreenActions.AVAILABLE_SCREENS_LOADED)
      .distinct()
      .transform(_getAvailableScreensTransformer());

  /// Stream for current screen
  Observable<Screen> get currentScreen => _eventsController.stream
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

  StreamTransformer<BlocEvent, SnackBar> _getSnackbarsTransformer() {
    return StreamTransformer<BlocEvent, SnackBar>.fromHandlers(
        handleData: (event, sink) => sink.add(event.data));
  }

  StreamTransformer<BlocEvent, List<Screen>> _getAvailableScreensTransformer() {
    return StreamTransformer<BlocEvent, List<Screen>>.fromHandlers(
        handleData: (event, sink) => sink.add(event.data));
  }

  StreamTransformer<BlocEvent, Screen> _getCurrentScreenStreamTransformer() {
    return StreamTransformer<BlocEvent, Screen>.fromHandlers(
        handleData: (event, sink) {
      if (_screensRepository.screens.isNotEmpty) {
        int index = event.data;
        // TODO: check if index is out of bounds. If so, return "Not found" screen
        sink.add(_screensRepository.screens[index]);
      } else {
        // todo: build the NoScreensAvailable screen
      }
    });
  }
}

class CurrentScreenAndAvailableScreens {
  final Screen currentScreen;
  final List<Screen> availableScreens;

  CurrentScreenAndAvailableScreens(
      {@required this.currentScreen, @required this.availableScreens});
}

final homeScreenBloc = HomeScreenBloc();
