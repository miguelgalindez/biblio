import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:biblio/models/tag.dart';
import 'package:flutter/material.dart';

class InventoryStatus extends StatefulWidget {
  final InventoryScreenBloc screenBloc;
  InventoryStatus({@required this.screenBloc});

  @override
  _InventoryStatusState createState() => _InventoryStatusState();
}

class _InventoryStatusState extends State<InventoryStatus>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation growAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    growAnimation = Tween<int>(begin: 0, end: 100).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  double _getScale(double finalSize, double percentage) {
    return percentage * finalSize / 100;
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
            AnimatedBuilder(
              animation: animationController,
              child: _ReadTags(screnBloc: widget.screenBloc),
              builder: (BuildContext context, Widget child) {
                return Transform.scale(
                  scale: animationController.value,
                  child: child,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _StatusDescription(
                  screenBloc: widget.screenBloc,
                  animationController: animationController,
                ),
                //SizedBox(width: 50),
                // TODO: Create scaleAnimation
                /*
                AnimatedBuilder(
                  animation: animationController,
                  child: _StatusDescription(screenBloc: widget.screenBloc),
                  builder: (BuildContext context, Widget child) {
                    return animationController.isAnimating ||
                            animationController.isCompleted
                        ? Transform.scale(
                            scale: animationController.value,
                            child: child,
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          );
                  },
                ),*/
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

class _StatusDescription extends StatelessWidget {
  final InventoryScreenBloc screenBloc;
  final AnimationController animationController;
  _StatusDescription(
      {@required this.screenBloc, @required this.animationController});

  @override
  Widget build(BuildContext context) {
    print("[_StatusDescription] Building widget...");
    return AnimatedBuilder(
      animation: animationController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Estado:"),
          StreamBuilder(
            stream: screenBloc.status,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (!snapshot.hasError) {
                switch (snapshot.data) {
                  case 0:
                    return const Text("Lector cerrado");

                  case 1:
                    return const Text("Lector listo");

                  case 2:
                    return const Text("Escaneando");

                  case 3:
                    return const Text("Escaneo detenido");

                  default:
                    return const Text("Desconocido");
                }
              } else {
                return const Text("Error");
              }
            },
          ),
        ],
      ),
      builder: (BuildContext context, Widget child) {
        return Transform.scale(
          scale: animationController.value,
          child: child,
        );
      },
    );
  }
}

class _Actions extends StatelessWidget {
  final InventoryScreenBloc screenBloc;
  final AnimationController animationController;
  _Actions({@required this.screenBloc, @required this.animationController});

  @override
  Widget build(BuildContext context) {
    print("[_Controls] Building widget...");

    return StreamBuilder(
      stream: screenBloc.status,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != 2) {
            return RaisedButton(
                child: const Text("Iniciar"),
                onPressed: () async {
                  animationController.forward();
                  screenBloc.startInventory();
                });
          } else {
            return RaisedButton(
              child: const Text("Parar"),
              onPressed: screenBloc.stopInventory,
            );
          }
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: const CircularProgressIndicator());
      },
    );
  }
}

class _ReadTags extends StatelessWidget {
  final InventoryScreenBloc screnBloc;
  _ReadTags({@required this.screnBloc});

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
              Text(numberOfReadTags.toString()),
              const Text("Etiquetas leidas"),
            ],
          );
        } else {
          return const Text("Ocurrió un error");
        }
      },
    );
  }
}
