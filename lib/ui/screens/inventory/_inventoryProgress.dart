import 'dart:async';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:flutter/material.dart';
import 'package:biblio/ui/screens/inventory/inventoryScreenBloc.dart';
import 'package:biblio/models/tag.dart';
import 'package:biblio/ui/components/outlinedButton.dart';
import 'package:biblio/ui/components/showAnimation.dart';
import 'package:biblio/ui/screens/inventory/_style.dart';

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

  Future<void> _statusListener(InventoryStatus status) async {
    switch (status) {
      case InventoryStatus.INVENTORY_STARTED_WITHOUT_TAGS:
        animationController.forward();
        break;

      case InventoryStatus.INVENTORY_STOPPED_WITHOUT_TAGS:
        animationController.reverse();
        break;

      /**
       * When the stop status is reported before the tags are processed the
       * animation is required to take place (only if it is not already played)
       */
      case InventoryStatus.INVENTORY_STOPPED_WITH_TAGS:
        animationController.forward();
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("[InventoryProgress] Building widget...");

    return Center(
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
  final Widget startButton;
  final Widget continueButton;
  final Widget stopButton;
  _Actions({@required this.screenBloc, @required this.animationController})
      : startButton = OutlinedButton(
          text: "INICIAR",
          textStyle: greenLabelTextStyle,
          color: green,
          onPressed: () async {
            screenBloc.events.add(
              BlocEvent(action: InventoryAction.START_INVENTORY),
            );
          },
        ),
        stopButton = OutlinedButton(
          text: "PARAR",
          textStyle: redLabelTextStyle,
          color: red,
          onPressed: () async {
            screenBloc.events.add(
              BlocEvent(action: InventoryAction.STOP_INVENTORY),
            );
          },
        ),
        continueButton = OutlinedButton(
          text: "CONTINUAR",
          textStyle: greenLabelTextStyle,
          color: green,
          onPressed: () async {
            screenBloc.events.add(
              BlocEvent(action: InventoryAction.START_INVENTORY),
            );
          },
        );

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
    print("[_Actions] Building widget...");

    return StreamBuilder(
      stream: screenBloc.status,
      builder: (BuildContext context, AsyncSnapshot<InventoryStatus> snapshot) {
        if (!snapshot.hasError) {
          if (snapshot.hasData) {
            InventoryStatus status = snapshot.data;
            if (status == InventoryStatus.CLOSED) {
              return const Center(child: const CircularProgressIndicator());
            } else if (_showStartButton(status)) {
              return startButton;
            } else if (_showStopButton(status)) {
              return stopButton;
            } else if (_showContinueButton(status)) {
              return continueButton;
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
