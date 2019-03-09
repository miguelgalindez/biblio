import 'package:flutter/material.dart';
import 'package:biblio/models/page.dart';
import 'package:biblio/components/tabBar.dart';
import 'package:biblio/screens/home/tabs/main.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/services/categories-mock-data.dart';

class HomeBody extends StatefulWidget {

  List<Category> bookCategories;

  HomeBody({@required this.bookCategories});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with SingleTickerProviderStateMixin {
  Key _key;
  TabController _tabController;  

  @override
  void initState() {    
    _key = new PageStorageKey({});    
    _tabController=new TabController(vsync: this, length: widget.bookCategories.length);    
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  _goToTab(String categoryId){

  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabChildrenPages=<Widget>[];
    widget.bookCategories.forEach((Category category)=>tabChildrenPages.add(MainTab(categories: widget.bookCategories, goToTab: _goToTab,)));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TabBarWidget(
          controller: _tabController,
          categories: widget.bookCategories,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: TabBarView(
              key: _key,
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: tabChildrenPages,
            ),
          ),
        ),
      ],
    );
  }
}
