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
  final Function onTap;
  final double width;
  final double widthAfterShrinking;
  final bool enableZoomButtonAnimation;
  final double horizontalPadding;

  AnimatedButton(
      {Key key,
      @required this.animatedButtonBloc,
      @required this.text,
      @required this.onTap,
      this.horizontalPadding = 0,
      this.width,
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
    super.initState();
    widget.animatedButtonBloc.init();
    _eventsSubscription =
        widget.animatedButtonBloc.events.listen(_handleEvents);
    shrinkButtonAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    zoomButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    shrinkButtonAnimationController
        .addStatusListener(_handleShrinkAnimationStatus);

    zoomButtonAnimationController.addStatusListener(_handleZoomAnimationStatus);
  }

  @override
  void dispose() {
    print('[AnimatedButton] Disposing...');
    _eventsSubscription.cancel();
    shrinkButtonAnimationController
        .removeStatusListener(_handleShrinkAnimationStatus);
    zoomButtonAnimationController
        .removeStatusListener(_handleZoomAnimationStatus);
    widget.animatedButtonBloc.dispose();
    zoomButtonAnimationController.dispose();
    shrinkButtonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints boxConstraints) {
        return AnimationWidget(
          animatedButtonBloc: widget.animatedButtonBloc,
          text: widget.text,
          onTap: widget.onTap,
          initialWidth: _getInitialWidth(boxConstraints),
          widthAfterShrinking: widget.widthAfterShrinking,
          shrinkButtonAnimationController: shrinkButtonAnimationController,
          zoomButtonAnimationController: zoomButtonAnimationController,
          horizontalPadding: widget.horizontalPadding,
          screenSize: screenSize,
        );
      },
    );
  }

  Future<void> _handleEvents(BlocEvent event) async {
    switch (event.action) {
      case AnimatedButtonAction.FORWARD_SHRINK_ANIMATION:
        print('await shrinkButtonAnimationController.forward();');
        await shrinkButtonAnimationController.forward();
        break;
      case AnimatedButtonAction.REWIND_SHRINK_ANIMATION:
        await shrinkButtonAnimationController.reverse();
        break;
      case AnimatedButtonAction.FORWARD_ZOOM_ANIMATION:
        await zoomButtonAnimationController.forward();
        break;
      case AnimatedButtonAction.REWIND_ZOOM_ANIMATION:
        await zoomButtonAnimationController.reverse();
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

  double _getInitialWidth(BoxConstraints boxConstraints) {
    return widget.width != null && widget.width > 0
        ? widget.width
        : boxConstraints.maxWidth;
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
        print('[AnimatedButton] Button to display ${snapshot.data}' );
        switch (snapshot.data) {

          /// Nuevo stream para botón. Para evitar renderizado múltiple del mismo componente
          /// cuando se retrocede la animación
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
