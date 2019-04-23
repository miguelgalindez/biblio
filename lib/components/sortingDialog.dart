import 'package:flutter/material.dart';
import 'package:biblio/models/sortingCriteria.dart';

enum SortingDialogAnswer { CANCEL, APPLY }

class SortingDialog extends StatefulWidget {
  final String title;
  final List<SortingCriteria> sortingCriterias;
  final SortingCriteria selectedSortingCriteria;

  SortingDialog(
      {@required this.title,
      @required this.sortingCriterias,
      this.selectedSortingCriteria});

  @override
  _SortingDialogState createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  int _radioValue;

  @override
  initState() {
    if (widget.selectedSortingCriteria != null) {
      for (int i = 0; i < widget.sortingCriterias.length; i++) {
        if (widget.sortingCriterias[i].id ==
            widget.selectedSortingCriteria.id) {
          _radioValue = i;
          break;
        }
      }
    } else {
      _radioValue = 0;
    }
    super.initState();
  }

  void changeRadioValue(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  List<Widget> _buildSortingCriteriaRadios(Color primaryColor) {
    List<Widget> radios = [];
    if (widget.sortingCriterias != null && widget.sortingCriterias.isNotEmpty) {
      for (int i = 0; i < widget.sortingCriterias.length; i++) {
        radios.add(RadioListTile(
          value: i,
          groupValue: _radioValue,
          title: Text(widget.sortingCriterias[i].description),
          activeColor: primaryColor,
          onChanged: changeRadioValue,
        ));
      }
    }
    return radios;
  }

  Widget _buildActions(Color primaryColor, TextTheme textTheme) {
    TextStyle textStyle = textTheme.subtitle
        .copyWith(color: primaryColor, fontWeight: FontWeight.bold);
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
          child: Row(      
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text("CANCELAR", style: textStyle),          
            splashColor: primaryColor,
            onPressed: () => Navigator.pop(context, null),
          ),
          FlatButton(
            child: Text("APLICAR", style: textStyle),
            splashColor: primaryColor,
            onPressed: () => Navigator.pop(context, widget.sortingCriterias[_radioValue]),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWidgets(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color primaryColor = themeData.primaryColor;
    TextTheme textTheme = themeData.textTheme;
    List<Widget> widgets = [];
    widgets.addAll(_buildSortingCriteriaRadios(primaryColor));
    widgets.add(_buildActions(primaryColor, textTheme));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: _buildWidgets(context),
    );
  }
}
