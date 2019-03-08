import 'package:flutter/material.dart';
import 'package:biblio/components/book/cardHeader.dart';
import 'package:biblio/components/book/card-section.dart';

import 'package:biblio/services/mock-data.dart';

class MainTab extends StatelessWidget {
  final Function goToTab;

  MainTab({@required this.goToTab});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      physics: ClampingScrollPhysics(),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
            child: Column(children: <Widget>[
              CardHeader(section: sections[index], goToTab: goToTab),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 20.0),
                child: CardSection(sections[index].products),
              ),
            ]),
          ),
        );
      },
    );
  }
}