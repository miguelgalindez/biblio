import 'package:flutter/material.dart';
import '../models/page.dart';
import 'package:biblio/models/appConfig.dart';

class TabBarWidget extends StatelessWidget {
  final TabController controller;
  final List<Page> allPages;
  TabBarWidget({this.controller, this.allPages});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0))),
      margin: EdgeInsets.only(bottom: 5.0),
      child: TabBar(
        labelStyle: TextStyle(fontSize: 12.0),
        controller: controller,
        isScrollable: true,
        indicatorColor: AppConfig.of(context).secondaryColor,
        labelColor: AppConfig.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        tabs: allPages.map((Page page) {
          return Tab(
            text: page.text,
            icon: new Icon(page.icon, size: 18.0),
          );
        }).toList(),
      ),
    );
  }
}
