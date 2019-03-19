import 'package:flutter/material.dart';

class SimpleListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;

  SimpleListTile({this.leading, this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 2.0, color: Colors.grey),
            ),
          ),
          child: leading,
        ),
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}

/*
return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 2.0, color: Colors.grey),
              ),
            ),
            child: leading,
          ),
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
*/