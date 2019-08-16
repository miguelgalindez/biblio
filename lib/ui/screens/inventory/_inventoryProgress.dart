import 'dart:async';

import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:biblio/models/tag.dart';
import 'package:flutter/material.dart';

const Color white = const Color(0xFFFFFFFF);
const Color red = const Color(0xFFF44336);
const Color green = const Color(0xFF4CAF50);
const Color yellow = const Color(0xFFFFEB3B);

const TextStyle whiteLabelTextStyle = const TextStyle(
  color: white,
  fontSize: 14,
  wordSpacing: 3.0,
);

const TextStyle greenLabelTextStyle = const TextStyle(
  color: green,
  fontSize: 14,
  fontWeight: FontWeight.bold,
  wordSpacing: 3.0,
);

const TextStyle yellowLabelTextStyle = const TextStyle(
  color: yellow,
  fontSize: 14,
  fontWeight: FontWeight.bold,
  wordSpacing: 3.0,
);

const TextStyle redLabelTextStyle = const TextStyle(
  color: red,
  fontSize: 14,
  fontWeight: FontWeight.bold,
  wordSpacing: 3.0,
);

class InventoryProgress extends StatefulWidget {
  final InventoryScreenBloc screenBloc;
  InventoryProgress({@required this.screenBloc});

  @override
  _InventoryProgressState createState() => _InventoryProgressState();
}

class _InventoryProgressState extends State<InventoryProgress>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation growAnimation;
  StreamSubscription<InventoryStatus> statusSubscription;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    growAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    statusSubscription = inventoryScreenBloc.status.listen(_statusListener);
  }

  @override
  void dispose() {
    statusSubscription.cancel();
    animationController.dispose();
    super.dispose();
  }

  void _statusListener(InventoryStatus status) {
    switch (status) {
      case InventoryStatus.INVENTORY_STARTED:
        animationController.forward();
        break;
      case InventoryStatus.INVENTORY_STOPPED:
        animationController.reverse();
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("[InventoryStatus] Building widget...");

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ShowAnimation(
              animationController: animationController,
              child: _ReadTags(screnBloc: widget.screenBloc),
              height: 40,
            ),
            ShowAnimation(
              animationController: animationController,
              child: SizedBox(height: 10),
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ShowAnimation(
                  animationController: animationController,
                  child: _StatusDescription(screenBloc: widget.screenBloc),
                  width: 100,
                ),
                ShowAnimation(
                  animationController: animationController,
                  child: SizedBox(width: 50),
                  width: 50,
                ),
                _Actions(
                  screenBloc: widget.screenBloc,
                  animationController: animationController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadTags extends StatelessWidget {
  final InventoryScreenBloc screnBloc;
  _ReadTags({@required this.screnBloc});

  static const TextStyle counterTextStyle = const TextStyle(
    color: white,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    print("[_ReadTags] Building widget...");

    return StreamBuilder(
      stream: screnBloc.allTags,
      builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
        if (!snapshot.hasError) {
          int numberOfReadTags = 0;
          if (snapshot.hasData) {
            numberOfReadTags = snapshot.data.length;
          }
          return Column(
            children: <Widget>[
              Text(numberOfReadTags.toString(), style: counterTextStyle),
              const Text("Etiquetas escaneadas", style: whiteLabelTextStyle),
            ],
          );
        } else {
          return const Text("Ocurrió un error", style: redLabelTextStyle);
        }
      },
    );
  }
}

class _StatusDescription extends StatelessWidget {
  final InventoryScreenBloc screenBloc;
  _StatusDescription({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    print("[_StatusDescription] Building widget...");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Estado:", style: whiteLabelTextStyle),
        StreamBuilder(
          stream: screenBloc.status,
          builder:
              (BuildContext context, AsyncSnapshot<InventoryStatus> snapshot) {
            if (!snapshot.hasError) {
              switch (snapshot.data) {
                case InventoryStatus.CLOSED:
                  return const Text("Lector cerrado",
                      style: yellowLabelTextStyle);

                case InventoryStatus.OPENED:
                  return const Text("Lector listo", style: whiteLabelTextStyle);

                case InventoryStatus.INVENTORY_STARTED:
                  return const Text("Escaneando", style: greenLabelTextStyle);

                case InventoryStatus.INVENTORY_STOPPED:
                  return const Text("Escaneo detenido",
                      style: yellowLabelTextStyle);

                default:
                  return const Text("Desconocido", style: redLabelTextStyle);
              }
            } else {
              return const Text("Error", style: redLabelTextStyle);
            }
          },
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final InventoryScreenBloc screenBloc;
  final AnimationController animationController;
  final Widget startButton;
  final Widget stopButton;
  _Actions({@required this.screenBloc, @required this.animationController})
      : startButton = _Button(
          // TODO: conditional text for 'Continuar'
          text: "INICIAR",
          textStyle: greenLabelTextStyle,
          color: green,
          onPressed: () async {
            screenBloc.actions.add(InventoryAction.START_INVENTORY);
          },
        ),
        stopButton = _Button(
          text: "PARAR",
          textStyle: redLabelTextStyle,
          color: red,
          onPressed: () async {
            screenBloc.actions.add(InventoryAction.STOP_INVENTORY);
          },
        );

  @override
  Widget build(BuildContext context) {
    print("[_Controls] Building widget...");

    return StreamBuilder(
      stream: screenBloc.status,
      builder: (BuildContext context, AsyncSnapshot<InventoryStatus> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != InventoryStatus.INVENTORY_STARTED) {
            return startButton;
          } else {
            return stopButton;
          }
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString(), style: redLabelTextStyle);
        }
        return const Center(child: const CircularProgressIndicator());
      },
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color color;
  final Function onPressed;
  _Button(
      {@required this.text,
      @required this.textStyle,
      @required this.color,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(text, style: textStyle),
      borderSide: BorderSide(color: color, width: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color,
      onPressed: onPressed,
    );
  }
}

class ShowAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;
  final double width;
  final double height;

  ShowAnimation(
      {@required this.child,
      @required this.animationController,
      this.width,
      this.height});

  double _getScale(double finalSize, double percentage) {
    if (finalSize != null && finalSize > 0) {
      return percentage * finalSize;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (BuildContext context, Widget child) {
        return animationController.isCompleted
            ? child
            : Container(
                width: _getScale(width, animationController.value),
                height: _getScale(height, animationController.value),
              );
      },
    );
  }
}
