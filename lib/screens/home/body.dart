import 'package:flutter/material.dart';
import 'package:biblio/components/tabBar.dart';
import 'package:biblio/screens/home/tabs/mainTabView.dart';
import 'package:biblio/screens/home/tabs/secondaryTabView.dart';
import 'package:biblio/models/category.dart';

class HomeBody extends StatefulWidget {
  final List<Category> bookCategories;
  final double tabsIconSize = 18.0;

  HomeBody({@required this.bookCategories});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
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
    print("tabs.length " + tabs.length.toString());
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
    print("tabsViews.length " + tabsViews.length.toString());
    return tabsViews;
  }

  _goToTab(String categoryId) {}

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
