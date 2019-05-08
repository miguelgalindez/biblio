import 'package:flutter/material.dart';
import 'package:biblio/models/appConfig.dart';

class TabBarWidget extends StatelessWidget {
  final TabController controller;
  final List<Tab> tabs;

  TabBarWidget({this.controller, this.tabs});

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      margin: EdgeInsets.only(bottom: 5.0),
      child: TabBar(
          labelStyle: TextStyle(fontSize: 12.0),
          controller: controller,
          isScrollable: true,
          indicatorColor: appConfig.secondaryColor,
          labelColor: appConfig.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: tabs),
    );
  }
}
