import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';
import 'package:biblio/screens/login/shrinkButtonAnimation.dart';

class AnimatedButton extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return !buttonClicked
        ? PlainButton(
            text: "Sign in",
            onTap: () {
              setState(() {
                buttonClicked = true;
              });
              _playShrinkAnimation();
            },
          )
        : ShrinkButtonAnimation(animationController: shrinkButtonAnimationController,);
  }
}
