import 'package:flutter/material.dart';

class BasicRating extends StatelessWidget {
  final double numberOfStar;
  final TextStyle textStyle;
  final double spaceBetween;
  final double iconSize;
  final Color iconColor;
  // If true, the star icon will be displayed even if the numberOfStar variable is null
  final bool alwaysShowIcon;

  BasicRating(
      {@required this.numberOfStar,
      this.textStyle,
      this.spaceBetween = 3,
      this.iconSize,
      this.iconColor,
      this.alwaysShowIcon = false});

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    Icon icon = Icon(
      Icons.star,
      size: iconSize,
      color: iconColor,
    );

    if (numberOfStar != null) {
      String text;
      if (numberOfStar % 1 == 0) {
        text = numberOfStar.truncate().toString();
      } else {
        text = numberOfStar.toString();
      }

      widgets.add(Text(text, style: textStyle));
      widgets.add(SizedBox(width: spaceBetween));
      widgets.add(icon);
    } else if(alwaysShowIcon){
      widgets.add(icon);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getWidgets(),
    );
  }
}
