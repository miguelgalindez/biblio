import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;

  CustomListTile({this.leading, this.title, this.subtitle, this.trailing});

  static TextStyle getSuggestedTextStyleForTitle(BuildContext context) {
    return Theme.of(context).textTheme.subhead.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle getSuggestedTextStyleForSubtitle(BuildContext context) {
    return Theme.of(context).textTheme.caption.copyWith(
          color: Colors.grey[400],
          fontWeight: FontWeight.normal,
        );
  }

  Widget _getFlexibleContainer(Widget child) {
    return Flexible(
      //fit: FlexFit.loose,
      flex: 1,
      child: Container(child: child),
    );
  }

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];

    Widget leadingWidget,
        titleWidget,
        subtitleWidget,
        titleAndSubtitleWidget,
        trailingWidget;

    if (leading != null) {
      leadingWidget = leading;
    }

    if (title != null) {
      titleWidget = _getFlexibleContainer(title);
    }

    if (subtitle != null) {
      subtitleWidget = _getFlexibleContainer(subtitle);
    }

    if (title != null || subtitle != null) {
      titleAndSubtitleWidget = Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleWidget, subtitleWidget]
                .where((Widget widget) => widget != null)
                .toList(),
          ),
        ),
      );
    }

    if (trailing != null) {
      trailingWidget = Container(
        padding: EdgeInsets.only(right: 12.0),
        child: trailing,
      );
    }

    widgets.add(leadingWidget);
    widgets.add(titleAndSubtitleWidget);
    widgets.add(trailingWidget);

    return widgets.where((Widget widget) => widget != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(      
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: Row(            
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: _getWidgets(),
          ),
        ),
      ],
    );
  }
}
