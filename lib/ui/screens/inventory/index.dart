import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/ui/components/changeSizeAnimation.dart';
import 'package:biblio/ui/components/showAnimation.dart';
import 'package:biblio/ui/screens/inventory/_readTagsList.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:biblio/ui/screens/inventory/_inventoryProgress.dart';
import 'package:biblio/ui/screens/inventory/_inventoryOptions.dart';

class InventoryScreen extends StatefulWidget {
  final Widget inventoryProgressWidget;
  final Widget readTagsListWidget;
  final Widget inventoryOptionsWidget;

  InventoryScreen()
      : inventoryProgressWidget =
            InventoryProgress(screenBloc: inventoryScreenBloc),
        readTagsListWidget = ReadTagslist(screenBloc: inventoryScreenBloc),
        inventoryOptionsWidget =
            InventoryOptions(screenBloc: inventoryScreenBloc);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  AnimationController showReadTagsAnimationController;
  AnimationController showInventoryOptionsController;
  StreamSubscription<InventoryStatusWithReadTags>
      inventoryStatusWithReadTagsSubscription;

  @override
  void initState() {
    inventoryScreenBloc.onShowScreen();
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

    inventoryStatusWithReadTagsSubscription =
        inventoryScreenBloc.statusWithReadTags.listen(_statusListener);

    super.initState();
  }

  @override
  void dispose() {
    showReadTagsAnimationController.dispose();
    showInventoryOptionsController.dispose();
    inventoryStatusWithReadTagsSubscription.cancel();
    inventoryScreenBloc.onLeaveScreen();
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
                child: widget.inventoryProgressWidget,
                initialSize: Size(constraints.maxWidth, constraints.maxHeight),
                finalSize: Size(constraints.maxWidth, 125.0),
              ),
              ShowAnimation(
                animationController: showReadTagsAnimationController,
                child: Expanded(child: widget.readTagsListWidget),
              ),
              ShowAnimation(
                animationController: showInventoryOptionsController,
                child: widget.inventoryOptionsWidget,
                height: 70,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          );
        },
      ),
    );
  }

  

  void _statusListener(
      InventoryStatusWithReadTags inventoryStatusWithReadTags) {
    _handleShowReadTagsAnimation(inventoryStatusWithReadTags);
    _handleShowInventoryOptionsAnimation(inventoryStatusWithReadTags);
  }

  void _handleShowReadTagsAnimation(
      InventoryStatusWithReadTags inventoryStatusWithReadTags) {
    if (inventoryStatusWithReadTags.readTags.isNotEmpty) {
      showReadTagsAnimationController.forward();
    } else {
      showReadTagsAnimationController.reverse();
    }
  }

  void _handleShowInventoryOptionsAnimation(
      InventoryStatusWithReadTags inventoryStatusWithReadTags) {
    if (inventoryStatusWithReadTags.status ==
            InventoryStatus.INVENTORY_STOPPED &&
        inventoryStatusWithReadTags.readTags.isNotEmpty) {
      showInventoryOptionsController.forward();
    } else {
      showInventoryOptionsController.reverse();
    }
  }
}
