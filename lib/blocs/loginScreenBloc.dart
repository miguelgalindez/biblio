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
    animatedButtonBloc.init();
    _eventsController = BehaviorSubject<BlocEvent>();
    _usernameController = BehaviorSubject<String>();
    _passwordController = BehaviorSubject<String>();
    _eventsSubscription = events.listen(_handleEvents);

    _usernameSubscription =
        username.listen((value) => _validateField(FieldId.USERNAME));
    _passwordSubscription =
        password.listen((value) => _validateField(FieldId.PASSWORD));

    _errorsController = BehaviorSubject();
    _errorsController.add(FormErrors());
  }

  @override
  void dispose() {
    animatedButtonBloc.dispose();
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
  StreamSink<FormErrors> get _errorsSink => _errorsController.sink;

  Observable<BlocEvent> get events => _eventsController.stream.distinct();
  ValueObservable<String> get username => _usernameController.stream;
  ValueObservable<String> get password => _passwordController.stream;

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
        _signIn();
        break;
      default:
    }
  }

  Future<void> _signIn() async {
    await Future.wait([
      _validateField(FieldId.USERNAME),
      _validateField(FieldId.PASSWORD),
    ]);

    if (_formIsValid()) {
      animatedButtonBloc.eventsSink.add(
        BlocEvent(action: AnimatedButtonAction.FORWARD_SHRINK_ANIMATION),
      );

      LoginScreenRepository.signIn(
        _usernameController.value,
        _passwordController.value,
        _handleSuccessfulSigning,
        _handleUnsuccessfulSigning,
      );
    }
  }

  Future<void> _validateField(FieldId fieldId) async {
    FormErrors formErrors = _errorsController.value;
    switch (fieldId) {
      case FieldId.USERNAME:
        formErrors.usernameError =
            UserValidator.validateUsername(_usernameController.value);
        break;
      case FieldId.PASSWORD:
        formErrors.passwordError =
            UserValidator.validatePassword(_passwordController.value);
        break;
    }
    _errorsSink.add(formErrors);
  }

  bool _formIsValid() {
    FormErrors formErrors = _errorsController.value;
    return formErrors.usernameError == null && formErrors.passwordError == null;
  }

  Future<void> _handleSuccessfulSigning(User user) async {
    animatedButtonBloc.eventsSink.add(
      BlocEvent(action: AnimatedButtonAction.FORWARD_ZOOM_ANIMATION),
    );
  }

  Future<void> _handleUnsuccessfulSigning(String error) async {
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
