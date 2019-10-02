import 'dart:async';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/validators/userValidator.dart';
import 'package:rxdart/rxdart.dart';

enum FieldId { USERNAME, PASSWORD }

class LoginScreenBloc extends BlocBase {
  BehaviorSubject<BlocEvent> _eventsController;
  BehaviorSubject<String> _usernameController;
  StreamSubscription<String> _usernameSubscription;
  BehaviorSubject<String> _passwordController;
  StreamSubscription<String> _passwordSubscription;
  BehaviorSubject<FormErrors> _errorsController;

  void init() {
    _eventsController = BehaviorSubject<BlocEvent>();
    _usernameController = BehaviorSubject<String>();
    _usernameSubscription = username.listen(_handleChange(FieldId.USERNAME));
    _passwordController = BehaviorSubject<String>();
    _passwordSubscription = password.listen(_handleChange(FieldId.PASSWORD));
    _errorsController = BehaviorSubject();
    _errorsController.add(FormErrors());
  }

  @override
  void dispose() {
    _eventsController.close();
    _usernameSubscription.cancel();
    _usernameController.close();
    _passwordSubscription.cancel();
    _passwordController.close();
    _errorsController.close();
  }

  StreamSink<BlocEvent> get eventsSink => _eventsController.sink;
  StreamSink<String> get usernameSink => _usernameController.sink;
  StreamSink<String> get passwordSink => _passwordController.sink;
  StreamSink<FormErrors> get errorsSink => _errorsController.sink;

  Observable<BlocEvent> get events => _eventsController.stream.distinct();
  Observable<String> get username => _usernameController.stream.distinct();
  Observable<String> get password => _passwordController.stream.distinct();

  Observable<String> get usernameErrors => _errorsController.stream.transform(
        StreamTransformer<FormErrors, String>.fromHandlers(
          handleData: (formErrors, sink) => sink.add(formErrors.usernameError),
        ),
      );

  Observable<String> get passwordErrors => _errorsController.stream.transform(
        StreamTransformer<FormErrors, String>.fromHandlers(
          handleData: (formErrors, sink) => sink.add(formErrors.passwordError),
        ),
      );

  Observable<bool> get formIsValid => _errorsController.stream.transform(
        StreamTransformer<FormErrors, bool>.fromHandlers(
          handleData: (formErrors, sink) => sink.add(
              formErrors.usernameError == null &&
                  formErrors.passwordError == null),
        ),
      );

  Function _handleChange(FieldId fieldId) => (String value) async {
        String error;
        FormErrors formErrors = _errorsController.value;
        switch (fieldId) {
          case FieldId.USERNAME:
            error = UserValidator.validateUsername(value);
            formErrors.usernameError = error;
            break;
          case FieldId.PASSWORD:
            error = UserValidator.validatePassword(value);
            formErrors.passwordError = error;
            break;
        }
        errorsSink.add(formErrors);
      };
}

class FormErrors {
  String usernameError;
  String passwordError;  
}

final loginScreenBloc = LoginScreenBloc();
