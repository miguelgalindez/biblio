import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';
import 'package:biblio/screens/login/shrinkButtonAnimation.dart';

class AnimatedButton extends StatefulWidget {
  final Function onTap;

  AnimatedButton({Key key, this.onTap});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController shrinkButtonAnimationController;
  bool buttonClicked;

  @override
  void initState() {
    super.initState();
    buttonClicked = false;
    shrinkButtonAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    shrinkButtonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _playShrinkAnimation() async {
    await shrinkButtonAnimationController.forward().orCancel;
  }

  Future<void> _rewindShrinkAnimation() async {
    await shrinkButtonAnimationController.reverse().orCancel;
  }

  _getOnTap() async {
    setState(() {
      buttonClicked = true;
    });

    _playShrinkAnimation();

    try {
      await widget.onTap(); 
      print("OK");
    } catch (e) {
      print(e.toString());
      _rewindShrinkAnimation();
    } finally {
      setState(() {
        buttonClicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !buttonClicked
        ? PlainButton(text: "Sign in", onTap: _getOnTap())
        : ShrinkButtonAnimation(
            animationController: shrinkButtonAnimationController,
          );
  }
}