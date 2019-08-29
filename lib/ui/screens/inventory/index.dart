import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblio/ui/components/changeSizeAnimation.dart';
import 'package:biblio/ui/components/showAnimation.dart';
import 'package:biblio/ui/screens/inventory/_readTagsList.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:biblio/ui/screens/inventory/_inventoryProgress.dart';
import 'package:biblio/ui/screens/inventory/_inventoryOptions.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> with TickerProviderStateMixin {
  AnimationController showReadTagsAnimationController;
  AnimationController showInventoryOptionsController;
  StreamSubscription<InventoryStatus> statusSubscription;
  InventoryProgress inventoryProgressWidget;
  ReadTagslist readTagsListWidget;
  InventoryOptions inventoryOptionsWidget;

  @override
  void initState() {
    _setPreferredOrientations();
    inventoryScreenBloc.init();
    showReadTagsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    showInventoryOptionsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    Tween(begin: 0.0, end: 1.0).animate(showReadTagsAnimationController);
    Tween(begin: 0.0, end: 1.0).animate(showInventoryOptionsController);

    statusSubscription = inventoryScreenBloc.status.listen(_statusListener);

    inventoryProgressWidget =
        InventoryProgress(screenBloc: inventoryScreenBloc);
    readTagsListWidget = ReadTagslist(screenBloc: inventoryScreenBloc);
    inventoryOptionsWidget = InventoryOptions();

    super.initState();
  }

  @override
  void dispose() {
    _clearPreferredOrientations();
    showReadTagsAnimationController.dispose();
    showInventoryOptionsController.dispose();
    statusSubscription.cancel();
    inventoryScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("[InventoryIndex] Building widget...");

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              ChangeSizeAnimation(
                animationController: showReadTagsAnimationController,
                child: inventoryProgressWidget,
                initialSize: Size(constraints.maxWidth, constraints.maxHeight),
                finalSize: Size(constraints.maxWidth, 125.0),
              ),
              ShowAnimation(
                animationController: showReadTagsAnimationController,
                child: Expanded(child: readTagsListWidget),
              ),
              ShowAnimation(
                animationController: showInventoryOptionsController,
                child: inventoryOptionsWidget,
                height: 70,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _setPreferredOrientations() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _clearPreferredOrientations() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _statusListener(InventoryStatus status) async {
    switch (status) {
      case InventoryStatus.INVENTORY_STARTED_WITH_TAGS:
      case InventoryStatus.INVENTORY_STOPPED_WITH_TAGS:
        // Firing show read tags animation
        if (!showReadTagsAnimationController.isAnimating &&
            !showReadTagsAnimationController.isCompleted) {
          showReadTagsAnimationController.forward();
        }

        // Firing show inventory options animation
        if (status == InventoryStatus.INVENTORY_STOPPED_WITH_TAGS) {
          showInventoryOptionsController.forward();
        } else if (showInventoryOptionsController.isCompleted ||
            showInventoryOptionsController.isAnimating) {
          showInventoryOptionsController.reverse();
        }

        break;
      default:
    }
  }
}
