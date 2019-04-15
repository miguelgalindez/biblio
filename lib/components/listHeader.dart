import 'package:flutter/material.dart';
import 'package:biblio/models/sortingCriteria.dart';

class ListHeader extends StatelessWidget {
  final Widget title;
  final SortingCriteria selectedSortingCriteria;
  final List<SortingCriteria> sortingCriterias;
  final Function onSortingCriteriaChage;

  ListHeader(
      {this.title,
      this.selectedSortingCriteria,
      @required this.sortingCriterias,
      @required this.onSortingCriteriaChage})
      : assert(title != null ||
            (sortingCriterias != null && sortingCriterias.isNotEmpty));

  List<Widget> _getWidgets(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    

    TextStyle sortingCaptionTextStyle = themeData.textTheme.caption
        .copyWith(fontWeight: FontWeight.normal, color: Colors.black);

    List<Widget> widgets = [];
    if (title != null) {
      widgets.add(title);
    } else {
      widgets.add(SizedBox(width: 1.0));
    }

    if (selectedSortingCriteria != null ||
        (sortingCriterias != null && sortingCriterias.isNotEmpty)) {
      String selectedSortingCriteriaDescription = "";

      if (selectedSortingCriteria != null) {
        selectedSortingCriteriaDescription =
            selectedSortingCriteria.description ?? "";
      }
      widgets.add(Row(
        children: <Widget>[
          Text(selectedSortingCriteriaDescription,
              style: sortingCaptionTextStyle),
          SizedBox(width: 6.0),
          Visibility(
            visible: sortingCriterias != null && sortingCriterias.isNotEmpty,
            child: Icon(Icons.sort),
          ),
        ],
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    BorderSide borderSide = BorderSide(width: 1.0, color: Colors.grey);

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border(
          top: borderSide,
          bottom: borderSide,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _getWidgets(context),
      ),
    );
  }
}
