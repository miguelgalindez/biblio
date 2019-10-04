import 'package:flutter/material.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/blocs/loginScreenBloc.dart';
import 'package:biblio/components/buttons/animatedButton.dart';
import 'package:biblio/ui/screens/login/_loginForm.dart';

class LoginScreen extends StatefulWidget {
  static final double _horizontalPadding = 24.0;
  final Image _backgroundImage;
  final Image _logo;
  final Widget _form;

  LoginScreen()
      : _backgroundImage = Image(
          image: const AssetImage("assets/img/login-background.jpg"),
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.77),
          colorBlendMode: BlendMode.darken,
        ),
        _logo = Image(
          image: const AssetImage("assets/img/appLogo.png"),
          height: 200,
          width: 200,
        ),
        _form = LoginForm();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    loginScreenBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    loginScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    print('Orientation $orientation');

    /// TODO: how to prevent keyboard opening causes the widget to rebuild
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.77),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            widget._backgroundImage,
            Center(
              child: SingleChildScrollView(
                child: orientation == Orientation.portrait
                    ? PortraitForm(
                        logo: widget._logo,
                        form: widget._form,
                      )
                    : LandscapeForm(
                        logo: widget._logo,
                        form: widget._form,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortraitForm extends StatelessWidget {
  final Widget logo;
  final Widget form;
  PortraitForm({@required this.logo, @required this.form});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: LoginScreen._horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              SizedBox(height: 40.0),
              form,
              SizedBox(height: 80.0),
            ],
          ),
        ),
        LoginButton(enableZoomButtonAnimation: true),
      ],
    );
  }
}

class LandscapeForm extends StatelessWidget {
  final Widget logo;
  final Widget form;
  LandscapeForm({@required this.logo, @required this.form});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: LoginScreen._horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Column(
                    children: <Widget>[
                      form,
                      SizedBox(height: 20.0),
                      LoginButton(enableZoomButtonAnimation: false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final bool enableZoomButtonAnimation;
  LoginButton({this.enableZoomButtonAnimation = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      animatedButtonBloc: loginScreenBloc.animatedButtonBloc,
      text: 'Iniciar sesión',
      enableZoomButtonAnimation: enableZoomButtonAnimation,
      onTap: () async {
        loginScreenBloc.eventsSink.add(
          BlocEvent(action: LoginScreenAction.SIGN_IN),
        );
      },
    );
  }
}
