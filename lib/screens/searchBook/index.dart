import 'package:flutter/material.dart';
import 'package:biblio/components/tabBar.dart';
import 'package:biblio/screens/searchBook/mainTabView.dart';
import 'package:biblio/screens/searchBook/secondaryTabView.dart';
import 'package:biblio/models/category.dart';

class SearchBookScreen extends StatefulWidget {
  final List<Category> bookCategories;
  final double tabsIconSize = 18.0;

  SearchBookScreen({@required this.bookCategories});

  @override
  _SearchBookScreenState createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen>
    with SingleTickerProviderStateMixin {
  Key _key;
  TabController _tabController;

  @override
  void initState() {
    _key = new PageStorageKey({});
    _tabController = new TabController(
        vsync: this, length: widget.bookCategories.length + 1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Tab> _getTabs() {
    final List<Tab> tabs = [];

    final Tab mainTab = Tab(
      text: "Explorar",
      icon: Icon(Icons.explore, size: widget.tabsIconSize),
    );

    final List<Tab> tabsForCategories =
        widget.bookCategories.map((Category category) {
      return Tab(
        text: category.name,
        icon: Icon(category.icon, size: widget.tabsIconSize),
      );
    }).toList();

    tabs.add(mainTab);
    tabs.addAll(tabsForCategories);
    return tabs;
  }

  List<Widget> _getTabsViews() {
    final List<Widget> tabsViews = <Widget>[];
    final MainTabView mainTabView = MainTabView(
      categories: widget.bookCategories,
      goToTab: _goToTab,
    );

    final List<SecondaryTabView> secondaryTabsViews = widget.bookCategories
        .map((Category category) => SecondaryTabView(
              category: category,
            ))
        .toList();

    tabsViews.add(mainTabView);
    tabsViews.addAll(secondaryTabsViews);
    return tabsViews;
  }

  _goToTab(String categoryId) {
    int categoryIndex = widget.bookCategories
        .indexWhere((Category category) => category.id == categoryId);
    int newTabIndex = categoryIndex + 1;
    if (newTabIndex < _tabController.length) {
      _tabController.index = newTabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TabBarWidget(
          controller: _tabController,
          tabs: _getTabs(),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: TabBarView(
              key: _key,
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: _getTabsViews(),
            ),
          ),
        ),
      ],
    );
  }
}
