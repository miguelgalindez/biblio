import 'package:flutter/material.dart';
import 'package:biblio/models/page.dart';
import 'package:biblio/components/tabBar.dart';

List<Page> _allPages = <Page>[
  Page(icon: Icons.usb, text: 'Tecnología y ciencias aplicadas', category: 'category-name'),
  Page(icon: Icons.group, text: 'Ciencias sociales', category: 'category-name'),
  Page(icon: Icons.import_contacts, text: 'Literatura', category: 'category-name'),  
  Page(icon: Icons.wallpaper, text: 'Artes', category: 'category-name'),
  Page(icon: Icons.public, text: 'Historia y geografía', category: 'category-name'),
  Page(icon: Icons.account_balance, text: 'Filosofía', category: 'category-name'),
];

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with SingleTickerProviderStateMixin {
  Key _key;
  TabController _tabController;

  @override
  void initState() {
    _key = new PageStorageKey({});
    _tabController=new TabController(vsync: this, length: _allPages.length);    
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final List<Widget> tabChildrenPages=<Widget>[];
    //_allPages.forEach((Page page)=>tabChildrenPages.add());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TabBarWidget(
          controller: _tabController,
          allPages: _allPages,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: TabBarView(
              key: _key,
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [],
            ),
          ),
        ),
      ],
    );
  }
}
