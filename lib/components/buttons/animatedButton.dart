import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/components/buttons/plainButton.dart';
import 'package:biblio/components/buttons/shrinkButtonAnimation.dart';
import 'package:biblio/components/buttons/zoomButtonAnimation.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/models/appConfig.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final double width;
  final double widthAfterShrinking;
  final double horizontalPadding;
  final bool enableZoomButtonAnimation;

  AnimatedButton(
      {Key key,
      this.horizontalPadding = 0,
      this.width,
      this.widthAfterShrinking = 70.0,
      @required this.text,
      this.enableZoomButtonAnimation = true})
      : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController shrinkButtonAnimationController;
  AnimationController zoomButtonAnimationController;
  bool showShrinkButtonAnimation;
  bool showZoomButtonAnimation;
  Future<User> loginPromise;
  AppConfig appConfig;

  @override
  void initState() {
    super.initState();
    showShrinkButtonAnimation = false;
    showZoomButtonAnimation = false;
    shrinkButtonAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    zoomButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    zoomButtonAnimationController.dispose();
    shrinkButtonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _playShrinkAnimation() async {
    setState(() {
      showShrinkButtonAnimation = true;
    });
    await shrinkButtonAnimationController.forward();
  }

  Future<void> _rewindShrinkAnimation() async {
    await shrinkButtonAnimationController.reverse();
    setState(() {
      showShrinkButtonAnimation = false;
    });
  }

  Future<void> _playZoomButtonAnimation() async {
    setState(() {
      showZoomButtonAnimation = true;
    });
    await zoomButtonAnimationController.forward();
  }

  Future<void> _executeOnTapFunction(BuildContext context) async {
    Scaffold.of(context).removeCurrentSnackBar();    
    if (widget.formKey == null || widget.formKey.currentState.validate()) {
      await _playShrinkAnimation();
      try {
        if (widget.onTap != null) {
          await widget.onTap();
        }
        if (widget.enableZoomButtonAnimation) {
          _playZoomButtonAnimation();
        } else {
          widget.onAnimationCompleted();
        }
      } catch (e) {
        print("Error: " + e.toString());
        await _rewindShrinkAnimation();
        _showSnackbar(e.toString(), null, context);
      }
    }
  }

  Future<void> _showSnackbar(
      String msg, SnackBarAction action, BuildContext context) async {
    var textStyle = Theme.of(context).textTheme.subhead.copyWith(
          color: Colors.white,
        );

    var snackbar = SnackBar(
      content: Text(msg, style: textStyle),
      action: action,
      duration: Duration(seconds: 8),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  void _handleAnimationCompleted() {
    widget.onAnimationCompleted();
    zoomButtonAnimationController.reset();
    shrinkButtonAnimationController.reset();
    setState(() {
      showZoomButtonAnimation = false;
      showShrinkButtonAnimation = false;
    });
  }

  double _getInitialWidth(BoxConstraints boxConstraints) {
    return widget.width != null && widget.width > 0
        ? widget.width
        : boxConstraints.maxWidth;
  }

  Widget _getAnimationWidget(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      if (showZoomButtonAnimation != null && showZoomButtonAnimation) {
        return ZoomButtonAnimation(
          begin: widget.widthAfterShrinking,
          screenSize: widget.screenSize,
          animationController: zoomButtonAnimationController,
          onAnimationCompleted: _handleAnimationCompleted,
        );
      } else if (showShrinkButtonAnimation != null &&
          showShrinkButtonAnimation) {
        return ShrinkButtonAnimation(
            begin: _getInitialWidth(boxConstraints),
            end: widget.widthAfterShrinking,
            animationController: shrinkButtonAnimationController);
      } else {
        return PlainButton(
          initialWidth: _getInitialWidth(boxConstraints),
          text: widget.text,
          onTap: () async => _executeOnTapFunction(context),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: showZoomButtonAnimation
            ? EdgeInsets.all(0.0)
            : EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: _getAnimationWidget(context));
  }
}
