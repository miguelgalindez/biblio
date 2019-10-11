import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/blocs/animatedButtonBloc.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/components/buttons/plainButton.dart';
import 'package:biblio/components/buttons/shrinkButtonAnimation.dart';
import 'package:biblio/components/buttons/zoomButtonAnimation.dart';

class AnimatedButton extends StatefulWidget {
  final AnimatedButtonBloc animatedButtonBloc;
  final String text;

  /// Function that will be executed once the plain button is clicked
  final Function onTap;

  /// Function that will be executed once the animation is completed
  final Function onAnimationCompleted;
  final double width;
  final double widthAfterShrinking;
  final bool enableZoomButtonAnimation;
  final double horizontalPadding;

  AnimatedButton(
      {Key key,
      @required this.animatedButtonBloc,
      @required this.text,
      @required this.onTap,
      this.onAnimationCompleted,
      this.horizontalPadding = 0,
      @required this.width,
      this.widthAfterShrinking = 70.0,
      this.enableZoomButtonAnimation = true})
      : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController shrinkButtonAnimationController;
  AnimationController zoomButtonAnimationController;
  StreamSubscription<BlocEvent> _eventsSubscription;

  @override
  void initState() {
    _eventsSubscription =
        widget.animatedButtonBloc.events.listen(_handleEvents);
    shrinkButtonAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    zoomButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    shrinkButtonAnimationController
        .addStatusListener(_handleShrinkAnimationStatus);

    zoomButtonAnimationController.addStatusListener(_handleZoomAnimationStatus);
    super.initState();
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    shrinkButtonAnimationController
        .removeStatusListener(_handleShrinkAnimationStatus);
    zoomButtonAnimationController
        .removeStatusListener(_handleZoomAnimationStatus);
    zoomButtonAnimationController.dispose();
    shrinkButtonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AnimationWidget(
      animatedButtonBloc: widget.animatedButtonBloc,
      text: widget.text,
      onTap: widget.onTap,
      initialWidth: widget.width,
      widthAfterShrinking: widget.widthAfterShrinking,
      shrinkButtonAnimationController: shrinkButtonAnimationController,
      zoomButtonAnimationController: zoomButtonAnimationController,
      horizontalPadding: widget.horizontalPadding,
      screenSize: screenSize,
    );
  }

  Future<void> _handleEvents(BlocEvent event) async {
    switch (event.action) {
      case AnimatedButtonAction.FORWARD_SHRINK_ANIMATION:
        await shrinkButtonAnimationController.forward();
        break;

      case AnimatedButtonAction.REWIND_SHRINK_ANIMATION:
        await shrinkButtonAnimationController.reverse();
        break;

      case AnimatedButtonAction.FORWARD_ZOOM_ANIMATION:
        if (widget.enableZoomButtonAnimation) {
          await zoomButtonAnimationController.forward();
        } else {
          widget.animatedButtonBloc.eventsSink.add(BlocEvent(
            action: AnimatedButtonAction.ZOOM_ANIMATION_COMPLETED,
          ));
        }
        break;

      case AnimatedButtonAction.REWIND_ZOOM_ANIMATION:
        if (widget.enableZoomButtonAnimation) {
          await zoomButtonAnimationController.reverse();
        }
        break;

      case AnimatedButtonAction.ZOOM_ANIMATION_COMPLETED:
        if (widget.onAnimationCompleted != null) {
          await widget.onAnimationCompleted();
        }
        zoomButtonAnimationController.reset();
        shrinkButtonAnimationController.reset();
        break;
    }
  }

  Future<void> _handleShrinkAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      widget.animatedButtonBloc.eventsSink.add(BlocEvent(
        action: AnimatedButtonAction.SHRINK_ANIMATION_COMPLETED,
      ));
    } else if (status == AnimationStatus.dismissed) {
      widget.animatedButtonBloc.eventsSink.add(BlocEvent(
        action: AnimatedButtonAction.SHRINK_ANIMATION_DISMISSED,
      ));
    }
  }

  Future<void> _handleZoomAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      widget.animatedButtonBloc.eventsSink.add(BlocEvent(
        action: AnimatedButtonAction.ZOOM_ANIMATION_COMPLETED,
      ));
    } else if (status == AnimationStatus.dismissed) {
      widget.animatedButtonBloc.eventsSink.add(BlocEvent(
        action: AnimatedButtonAction.ZOOM_ANIMATION_DISMISSED,
      ));
    }
  }
}

class AnimationWidget extends StatelessWidget {
  final AnimatedButtonBloc animatedButtonBloc;
  final Widget shrinkAnimatedButton;
  final Widget zoomAnimatedButton;
  final Widget plainButton;
  final bool enableZoomButtonAnimation;
  final double horizontalPadding;

  AnimationWidget({
    @required this.animatedButtonBloc,
    this.enableZoomButtonAnimation = true,
    @required String text,
    @required Function onTap,
    @required double initialWidth,
    @required double widthAfterShrinking,
    @required this.horizontalPadding,
    @required AnimationController shrinkButtonAnimationController,
    @required AnimationController zoomButtonAnimationController,
    @required Size screenSize,
  })  : zoomAnimatedButton = ZoomButtonAnimation(
          begin: widthAfterShrinking,
          animationController: zoomButtonAnimationController,
          screenSize: screenSize,
        ),
        shrinkAnimatedButton = ShrinkButtonAnimation(
            begin: initialWidth,
            end: widthAfterShrinking,
            animationController: shrinkButtonAnimationController),
        plainButton = PlainButton(
          initialWidth: initialWidth,
          text: text,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: animatedButtonBloc.buttons,
      builder: (BuildContext context, AsyncSnapshot<Button> snapshot) {
        return Padding(
          padding: _showZoomButtonAnimation(snapshot)
              ? EdgeInsets.all(0.0)
              : EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _getWidget(context, snapshot),
        );
      },
    );
  }

  Widget _getWidget(BuildContext context, AsyncSnapshot<Button> snapshot) {
    if (!snapshot.hasError) {
      if (snapshot.hasData) {
        switch (snapshot.data) {
          case Button.ZOOM_BUTTON:
            return enableZoomButtonAnimation
                ? zoomAnimatedButton
                : shrinkAnimatedButton;

          case Button.SHRINK_BUTTON:
            return shrinkAnimatedButton;

          default:
            return plainButton;
        }
      } else {
        return plainButton;
      }
    } else {
      return const Text('Error');
    }
  }

  bool _showZoomButtonAnimation(AsyncSnapshot<Button> snapshot) {
    return enableZoomButtonAnimation &&
        snapshot.hasData &&
        snapshot.data == Button.ZOOM_BUTTON;
  }
}
