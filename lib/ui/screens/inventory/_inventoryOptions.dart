import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:flutter/material.dart';
import 'package:biblio/ui/components/outlinedButton.dart';
import 'package:biblio/ui/screens/inventory/_style.dart';

class InventoryOptions extends StatelessWidget {
  final InventoryScreenBloc screenBloc;
  final Widget clearButton;
  final Widget saveButton;

  InventoryOptions({@required this.screenBloc})
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
        child: ButtonBar(          
          mainAxisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[clearButton, saveButton],
        ),
      ),
    );
  }
}
