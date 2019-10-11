import 'dart:async';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

enum AnimatedButtonAction {
  SHRINK_ANIMATION_DISMISSED,
  FORWARD_SHRINK_ANIMATION,
  REWIND_SHRINK_ANIMATION,
  SHRINK_ANIMATION_COMPLETED,
  ZOOM_ANIMATION_DISMISSED,
  FORWARD_ZOOM_ANIMATION,
  REWIND_ZOOM_ANIMATION,
  ZOOM_ANIMATION_COMPLETED
}

enum Button { PLAIN_BUTTON, SHRINK_BUTTON, ZOOM_BUTTON }

class AnimatedButtonBloc extends BlocBase {
  BehaviorSubject<BlocEvent> _eventsController;

  void init() {
    _eventsController = BehaviorSubject();
  }

  @override
  void dispose() {
    _eventsController.close();
  }

  StreamSink<BlocEvent> get eventsSink => _eventsController.sink;

  Observable<BlocEvent> get events => _eventsController.stream;
  Observable<Button> get buttons =>
      events.transform(_getButtonsTransformer()).distinct();

  StreamTransformer<BlocEvent, Button> _getButtonsTransformer() =>
      StreamTransformer<BlocEvent, Button>.fromHandlers(
        handleData: (event, sink) {
          if (event.action == AnimatedButtonAction.FORWARD_SHRINK_ANIMATION ||
              event.action == AnimatedButtonAction.REWIND_SHRINK_ANIMATION ||
              event.action == AnimatedButtonAction.SHRINK_ANIMATION_COMPLETED) {
            sink.add(Button.SHRINK_BUTTON);
          } else if (event.action ==
                  AnimatedButtonAction.FORWARD_ZOOM_ANIMATION ||
              event.action == AnimatedButtonAction.REWIND_ZOOM_ANIMATION) {
            sink.add(Button.ZOOM_BUTTON);
          } else {
            sink.add(Button.PLAIN_BUTTON);
          }
        },
      );
}
