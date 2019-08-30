import 'dart:async';

import 'package:biblio/resources/repositories/screensRepository.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/ui/screens/blocBase.dart';

enum HomeScreenActions { LOAD_AVAILABLE_SCREENS }

class HomeScreenBloc extends BlocBase {
  BehaviorSubject<List<Screen>> _availableScreensReporter;
  BehaviorSubject<int> _currentScreenReporter;
  // TODO: get it using injection
  ScreensRepository _screensRepository;

  @override
  void init() async {
    _availableScreensReporter = BehaviorSubject<List<Screen>>();
    _currentScreenReporter = BehaviorSubject<int>();
    _screensRepository = ScreensRepository();
    await _screensRepository.loadAvailableScreens();
    _availableScreensReporter.sink.add(_screensRepository.screens);
    switchToScreen.add(0);
  }

  @override
  void dispose() {
    _availableScreensReporter.close();
    _currentScreenReporter.close();
    _screensRepository.dispose();
  }

  Observable<List<Screen>> get availableScreens =>
      _availableScreensReporter.stream.distinct();

  // Report a Future instead of a Screen
  Observable<Screen> get currentScreen => _currentScreenReporter.stream
      .distinct()
      .transform(_getCurrentScreenStreamTransformer());

  Observable<CurrentScreenAndAvailableScreens>
      get currentScreenAndAvailableScreens => currentScreen.withLatestFrom(
          _availableScreensReporter.stream.distinct(),
          (currentScreen, availableScreens) => CurrentScreenAndAvailableScreens(
              currentScreen: currentScreen,
              availableScreens: availableScreens));

  Sink<int> get switchToScreen => _currentScreenReporter.sink;




  StreamTransformer<int, Screen> _getCurrentScreenStreamTransformer() {
    return StreamTransformer<int, Screen>.fromHandlers(
        handleData: (index, sink) {
      // TODO: check if index is out of bounds. If so, return "Not found" screen
      Screen screen = _screensRepository.screens[index];
      if (screen.body == null) {
        screen.body = _screensRepository.getScreenWidget(screen.id);
      }
      sink.add(screen);
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
