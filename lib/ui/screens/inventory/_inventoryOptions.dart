import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/ui/screens/inventory/inventoryScreenBloc.dart';
import 'package:flutter/material.dart';
import 'package:biblio/ui/components/outlinedButton.dart';
import 'package:biblio/ui/screens/inventory/_style.dart';

class InventoryOptions extends StatelessWidget {
  final Widget clearButton;
  final Widget saveButton;
  InventoryOptions()
      : clearButton = OutlinedButton(
          text: "DESCARTAR",
          color: yellow,
          textStyle: yellowLabelTextStyle,
          onPressed: () async {
            inventoryScreenBloc.events.add(
              BlocEvent(action: InventoryAction.DISCARD_ALL_TAGS),
            );
          },
        ),
        saveButton = OutlinedButton(
          text: "GUARDAR",
          color: white,
          textStyle: whiteLabelTextStyle,
          onPressed: () async {},
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[clearButton, saveButton],
          ),
        ),
      ),
    );
  }
}
