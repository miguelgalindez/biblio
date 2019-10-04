import 'dart:async';
import 'package:biblio/models/User.dart';
import 'package:biblio/resources/repositories/loginScreenRepository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:biblio/blocs/animatedButtonBloc.dart';
import 'package:biblio/ui/screens/blocBase.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/validators/userValidator.dart';

enum FieldId { USERNAME, PASSWORD }
enum LoginScreenAction {
  SIGN_IN,
  SIGNED_IN,
  SIGN_OUT,
  SIGNED_OUT,
  SIGNING_ERROR
}

class LoginScreenBloc extends BlocBase {
  BehaviorSubject<BlocEvent> _eventsController;
  BehaviorSubject<String> _usernameController;
  BehaviorSubject<String> _passwordController;
  BehaviorSubject<FormErrors> _errorsController;
  StreamSubscription<BlocEvent> _eventsSubscription;
  StreamSubscription<String> _usernameSubscription;
  StreamSubscription<String> _passwordSubscription;
  AnimatedButtonBloc animatedButtonBloc;

  void init() {
    animatedButtonBloc = AnimatedButtonBloc();
    _eventsController = BehaviorSubject<BlocEvent>();
    _usernameController = BehaviorSubject<String>();
    _passwordController = BehaviorSubject<String>();
    _eventsSubscription = events.listen(_handleEvents);
    _usernameSubscription = username.listen(_handleChange(FieldId.USERNAME));
    _passwordSubscription = password.listen(_handleChange(FieldId.PASSWORD));
    _errorsController = BehaviorSubject();
    _errorsController.add(FormErrors());
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _usernameSubscription.cancel();
    _passwordSubscription.cancel();
    _eventsController.close();
    _usernameController.close();
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
          handleData: (formErrors, sink) => sink.add(_formIsValid()),
        ),
      );

  Future<void> _handleEvents(BlocEvent event) async {
    switch (event.action) {
      case LoginScreenAction.SIGN_IN:
        animatedButtonBloc.eventsSink.add(
          BlocEvent(action: AnimatedButtonAction.FORWARD_SHRINK_ANIMATION),
        );
        if (_formIsValid()) {
          LoginScreenRepository.signIn(
            _usernameController.value,
            _passwordController.value,
            _handleSuccessfulSigning,
            _handleUnsuccessfulSigning,
          );
        } else {
         /* animatedButtonBloc.eventsSink.add(
            BlocEvent(action: AnimatedButtonAction.REWIND_SHRINK_ANIMATION),
          );*/
        }
        break;
      default:
    }
  }

  Function _handleChange(FieldId fieldId) => (String value) async {
        FormErrors formErrors = _errorsController.value;
        switch (fieldId) {
          case FieldId.USERNAME:
            formErrors.usernameError = UserValidator.validateUsername(value);
            break;
          case FieldId.PASSWORD:
            formErrors.passwordError = UserValidator.validatePassword(value);
            break;
        }
        errorsSink.add(formErrors);
      };

  bool _formIsValid() {
    FormErrors formErrors = _errorsController.value;
    return formErrors.usernameError == null && formErrors.passwordError == null;
  }

  Future<void> _handleSuccessfulSigning(User user) async {
    print(
        '[LoginScreenBloc] The user: ${user.username} is signed in. Redirecting...');
    animatedButtonBloc.eventsSink.add(
      BlocEvent(action: AnimatedButtonAction.FORWARD_ZOOM_ANIMATION),
    );
  }

  Future<void> _handleUnsuccessfulSigning(String error) async {
    print(
        '[LoginScreenBloc] Error trying to authenticate the user. Description: $error');
    animatedButtonBloc.eventsSink.add(
      BlocEvent(action: AnimatedButtonAction.REWIND_SHRINK_ANIMATION),
    );
  }
}

class FormErrors {
  String usernameError;
  String passwordError;
}

final loginScreenBloc = LoginScreenBloc();
