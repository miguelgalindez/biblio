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

  List<Widget> _buildSortingCriteriaRadios(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

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

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // TODO: make these look alike flat buttons
        SimpleDialogOption(
          child: Text("Cancelar"),
          onPressed: () => Navigator.pop(context, null),
        ),
        SimpleDialogOption(
          child: Text("Aplicar"),
          onPressed: () =>
              Navigator.pop(context, widget.sortingCriterias[_radioValue]),
        ),
      ],
    );
  }


  List<Widget> _buildWidgets(BuildContext context) {
    List<Widget> widgets = [];
    widgets.addAll(_buildSortingCriteriaRadios(context));
    widgets.add(_buildOptions());

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
