import 'dart:async';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/validators/userValidator.dart';
import 'package:rxdart/rxdart.dart';

class LoginScreenBloc extends BlocBase {
  BehaviorSubject<BlocEvent> _eventsController;
  BehaviorSubject<String> _usernameController;
  BehaviorSubject<String> _passwordController;

  void init() {
    _eventsController = BehaviorSubject<BlocEvent>();
    _usernameController = BehaviorSubject<String>();
    _passwordController = BehaviorSubject<String>();
  }

  @override
  void dispose() {
    _eventsController.close();
    _usernameController.close();
    _passwordController.close();
  }

  StreamSink<BlocEvent> get eventsSink => _eventsController.sink;
  StreamSink<String> get usernameSink => _usernameController.sink;
  StreamSink<String> get passwordSink => _passwordController.sink;

  Observable<BlocEvent> get events => _eventsController.stream;

  Observable<String> get username =>
      _usernameController.stream.distinct().transform(
        StreamTransformer<String, String>.fromHandlers(
          handleData: (username, sink) {
            String error = validateUsername(username);
            if (error == null || error.isEmpty) {
              sink.add(username);
            } else {
              sink.addError(error);
            }
          },
        ),
      );

  Observable<String> get password =>
      _passwordController.stream.distinct().transform(
        StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
            String error = validatePassword(password);
            if (error == null || error.isEmpty) {
              sink.add(password);
            } else {
              sink.addError(error);
            }
          },
        ),
      );

  Observable<bool> get formIsValid => Observable.combineLatest2(
        username,
        password,
        (u, p) => true,
      );
}

final loginScreenBloc = LoginScreenBloc();
