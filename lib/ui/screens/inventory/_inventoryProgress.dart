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
      case InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS:
        animationController.forward();
        break;
      case InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS:
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ShowAnimation(
                    animationController: animationController,
                    child: Flexible(
                      child: _StatusDescription(screenBloc: widget.screenBloc),
                    ),
                    width: 100,
                  ),
                  ShowAnimation(
                    animationController: animationController,
                    child: SizedBox(width: 50),
                    width: 50,
                  ),
                  Flexible(
                    child: _Actions(
                      screenBloc: widget.screenBloc,
                      animationController: animationController,
                    ),
                  ),
                ],
              ),
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
              const Text(
                "Etiquetas escaneadas",
                style: whiteLabelTextStyle,
                textAlign: TextAlign.center,
              ),
              Text(
                numberOfReadTags.toString(),
                style: counterTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          return const Text(
            "Error",
            style: redLabelTextStyle,
            textAlign: TextAlign.center,
          );
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
        const Text(
          "Estado:",
          style: whiteLabelTextStyle,
          textAlign: TextAlign.center,
        ),
        StreamBuilder(
          stream: screenBloc.status,
          builder:
              (BuildContext context, AsyncSnapshot<InventoryStatus> snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.hasData) {
                switch (snapshot.data) {
                  case InventoryStatus.CLOSED:
                    return const Text(
                      "Lector cerrado",
                      style: yellowLabelTextStyle,
                      textAlign: TextAlign.center,
                    );

                  case InventoryStatus.OPENED:
                    return const Text(
                      "Lector listo",
                      style: whiteLabelTextStyle,
                      textAlign: TextAlign.center,
                    );

                  case InventoryStatus.INVENTORY_STARTED_WITH_TAGS:
                  case InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS:
                    return const Text(
                      "Escaneando",
                      style: greenLabelTextStyle,
                      textAlign: TextAlign.center,
                    );

                  case InventoryStatus.INVENTORY_STOPPED_WITH_TAGS:
                  case InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS:
                    return const Text(
                      "Escaneo detenido",
                      style: yellowLabelTextStyle,
                      textAlign: TextAlign.center,
                    );

                  default:
                    return const Text(
                      "Desconocido",
                      style: redLabelTextStyle,
                      textAlign: TextAlign.center,
                    );
                }
              } else {
                return const Center(child: const CircularProgressIndicator());
              }
            } else {
              return const Text(
                "Error",
                style: redLabelTextStyle,
                textAlign: TextAlign.center,
              );
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
  final Widget openButton;
  final Widget startButton;
  final Widget continueButton;
  final Widget stopButton;
  _Actions({@required this.screenBloc, @required this.animationController})
      : openButton = _Button(
          text: "ABRIR",
          textStyle: whiteLabelTextStyle,
          color: white,
          onPressed: () async {
            screenBloc.actions.add(InventoryAction.OPEN);
          },
        ),
        startButton = _Button(
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
        ),
        continueButton = _Button(
          text: "CONTINUAR",
          textStyle: greenLabelTextStyle,
          color: green,
          onPressed: () async {
            screenBloc.actions.add(InventoryAction.START_INVENTORY);
          },
        );

  bool _showOpenButton(InventoryStatus status) {
    return status == InventoryStatus.CLOSED;
  }

  bool _showStartButton(InventoryStatus status) {
    return status == InventoryStatus.OPENED ||
        status == InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS;
  }

  bool _showStopButton(InventoryStatus status) {
    return status == InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS ||
        status == InventoryStatus.INVENTORY_STARTED_WITH_TAGS;
  }

  bool _showContinueButton(InventoryStatus status) {
    return status == InventoryStatus.INVENTORY_STOPPED_WITH_TAGS;
  }

  @override
  Widget build(BuildContext context) {
    print("[_Controls] Building widget...");

    return StreamBuilder(
      stream: screenBloc.status,
      builder: (BuildContext context, AsyncSnapshot<InventoryStatus> snapshot) {
        if (!snapshot.hasError) {
          if (snapshot.hasData) {
            if (_showStartButton(snapshot.data)) {
              return startButton;
            } else if (_showStopButton(snapshot.data)) {
              return stopButton;
            } else if (_showContinueButton(snapshot.data)) {
              return continueButton;
            } else if (_showOpenButton(snapshot.data)) {
              return openButton;
            } else {
              return const Text(
                "No hay acciones disponibles",
                style: whiteLabelTextStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              );
            }
          } else {
            return const Center(child: const CircularProgressIndicator());
          }
        } else {
          return const Text("Error", style: redLabelTextStyle);
        }
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
