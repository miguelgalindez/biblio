import 'package:flutter/material.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  void didChangeDependencies() {
    inventoryScreenBloc.init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    inventoryScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: StreamBuilder(
          stream: inventoryScreenBloc.status,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              return buildButtons(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget buildButtons(AsyncSnapshot snapshot) {
    Function onPressed = snapshot.data == 0
        ? inventoryScreenBloc.startInventory
        : inventoryScreenBloc.stopInventory;
    
    Widget child =
        Text(snapshot.data == 0 ? "Start inventory" : "Stop inventory");
    
    return RaisedButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
