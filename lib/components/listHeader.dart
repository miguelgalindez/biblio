import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/models/sortingCriteria.dart';
import 'package:biblio/components/sortingDialog.dart';

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

  Future<void> showSortingDialog(BuildContext context) async {
    String dialogTitle = "Ordenar valoraciones por";

    SortingCriteria sortingCriteria = await showDialog<SortingCriteria>(
      context: context,
      builder: (BuildContext context) {
        return SortingDialog(
          title: dialogTitle,
          sortingCriterias: sortingCriterias,
          selectedSortingCriteria: selectedSortingCriteria,
        );
      },
    );

    if (sortingCriteria != null) {
      onSortingCriteriaChage(sortingCriteria);
    }
  }

  List<Widget> _getWidgets(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(title != null ? title : SizedBox(width: 1.0));

    if (selectedSortingCriteria != null ||
        (sortingCriterias != null && sortingCriterias.isNotEmpty)) {
      ThemeData themeData = Theme.of(context);

      TextStyle sortingCaptionTextStyle = themeData.textTheme.caption
          .copyWith(fontWeight: FontWeight.normal, color: Colors.black);

      String selectedSortingCriteriaDescription =
          selectedSortingCriteria != null
              ? selectedSortingCriteria.description ?? ""
              : "";

      Widget sortingWidget = Row(
        children: <Widget>[
          Text(selectedSortingCriteriaDescription,
              style: sortingCaptionTextStyle),
          SizedBox(width: 6.0),
          Visibility(
            visible: sortingCriterias != null && sortingCriterias.isNotEmpty,
            child: Icon(Icons.sort),
          ),
        ],
      );

      if (sortingCriterias == null || sortingCriterias.isEmpty) {
        widgets.add(sortingWidget);
      } else {
        widgets.add(InkWell(
            child: sortingWidget,
            onTap: () async => showSortingDialog(context)));
      }
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
