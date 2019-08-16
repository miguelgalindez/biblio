import 'package:flutter/material.dart';
import 'package:biblio/blocs/inventoryScreenBloc.dart';
import 'package:biblio/ui/screens/inventory/_inventoryProgress.dart';

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
    return InventoryProgress(screenBloc: inventoryScreenBloc);
  }
}
