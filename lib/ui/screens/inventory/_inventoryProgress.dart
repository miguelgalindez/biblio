import 'dart:async';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:flutter/material.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';
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
  StreamSubscription<InventoryStatusWithReadTags>
      inventoryStatusWithReadTagsSubscription;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    growAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    inventoryStatusWithReadTagsSubscription =
        inventoryScreenBloc.statusWithReadTags.listen(_statusListener);
  }

  @override
  void dispose() {
    inventoryStatusWithReadTagsSubscription.cancel();
    animationController.dispose();
    super.dispose();
  }

  Future<void> _statusListener(
      InventoryStatusWithReadTags inventoryStatusWithReadTags) async {
    if (inventoryStatusWithReadTags.readTags.isNotEmpty) {
      animationController.forward();
    } else {
      animationController.reverse();
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
      stream: screnBloc.readTags,
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

                  case InventoryStatus.INVENTORY_STARTED:
                    return const Text(
                      "Escaneando",
                      style: greenLabelTextStyle,
                      textAlign: TextAlign.center,
                    );

                  case InventoryStatus.INVENTORY_STOPPED:
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
  final Widget readerError;
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
        ),
        readerError = ReaderError(
          message:
              'Ocurrió un error con el lector RFID. Contacte a soporte técnico.',
        );

  bool _showStartButton(InventoryStatusWithReadTags statusWithReadTags) {
    return statusWithReadTags.status == InventoryStatus.OPENED ||
        (statusWithReadTags.status == InventoryStatus.INVENTORY_STOPPED &&
            statusWithReadTags.readTags.isEmpty);
  }

  bool _showStopButton(InventoryStatusWithReadTags statusWithReadTags) {
    return statusWithReadTags.status == InventoryStatus.INVENTORY_STARTED;
  }

  bool _showContinueButton(InventoryStatusWithReadTags statusWithReadTags) {
    return statusWithReadTags.status == InventoryStatus.INVENTORY_STOPPED &&
        statusWithReadTags.readTags.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    print("[_Actions] Building widget...");

    return StreamBuilder(
      stream: screenBloc.statusWithReadTags,
      builder: (BuildContext context,
          AsyncSnapshot<InventoryStatusWithReadTags> snapshot) {
        if (!snapshot.hasError) {
          if (snapshot.hasData) {
            InventoryStatusWithReadTags statusWithReadTags = snapshot.data;
            if (statusWithReadTags.status == null) {
              return readerError;
            } else if (statusWithReadTags.status == InventoryStatus.CLOSED) {
              return const Center(child: const CircularProgressIndicator());
            } else if (_showStartButton(statusWithReadTags)) {
              return startButton;
            } else if (_showStopButton(statusWithReadTags)) {
              return stopButton;
            } else if (_showContinueButton(statusWithReadTags)) {
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
          return readerError;
        }
      },
    );
  }
}

class ReaderError extends StatelessWidget {
  final String message;
  ReaderError({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Icon(
          Icons.report,
          color: yellow,
          size: 50.0,
        ),
        Flexible(
          child: SizedBox(
            width: 200.0,
            child: Text(
              message,
              style: whiteLabelTextStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
          ),
        )
      ],
    );
  }
}
