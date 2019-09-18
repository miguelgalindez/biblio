import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblio/ui/components/changeSizeAnimation.dart';
import 'package:biblio/ui/components/showAnimation.dart';
import 'package:biblio/ui/screens/inventory/_readTagsList.dart';
import 'package:biblio/ui/screens/inventory/inventoryScreenBloc.dart';
import 'package:biblio/ui/screens/inventory/_inventoryProgress.dart';
import 'package:biblio/ui/screens/inventory/_inventoryOptions.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  AnimationController showReadTagsAnimationController;
  AnimationController showInventoryOptionsController;
  StreamSubscription<InventoryStatusWithReadTags>
      inventoryStatusWithReadTagsSubscription;
  InventoryProgress inventoryProgressWidget;
  ReadTagslist readTagsListWidget;
  InventoryOptions inventoryOptionsWidget;

  @override
  void initState() {
    _setPreferredOrientations();
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

  void _statusListener(
      InventoryStatusWithReadTags inventoryStatusWithReadTags) {
    _handleShowReadTagsAnimation(inventoryStatusWithReadTags);
    _handleShowInventoryOptionsAnimation(inventoryStatusWithReadTags);
  }

  void _handleShowReadTagsAnimation(
      InventoryStatusWithReadTags inventoryStatusWithReadTags) {
    //InventoryStatus currentStatus=inventoryStatusWithReadTags.status;
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
