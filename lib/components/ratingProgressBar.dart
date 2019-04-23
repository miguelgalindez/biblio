import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RatingProgressBar extends StatelessWidget {
  final int starNumber;
  final double percent;
  final Color primaryColor;


  RatingProgressBar({@required this.starNumber, @required this.percent, this.primaryColor});  

  @override
  Widget build(BuildContext context) {
    Color color=primaryColor!=null ? primaryColor : Theme.of(context).primaryColor;        
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 6.0),
          child: Column(
            children: <Widget>[
              Text(starNumber.toString()),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return LinearPercentIndicator(
                    percent: percent,
                    progressColor: color,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    lineHeight: 10.0,
                    width: constraints.maxWidth,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}