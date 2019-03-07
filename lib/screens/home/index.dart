import 'package:flutter/material.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/services/ciudades.dart';

class Home extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    AppConfig appConfig=AppConfig.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appConfig.primaryColor,
          title: Text(appConfig.appName),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                }),
          ],
        ),
        drawer: Drawer(),
        body: Center(child: Text("Home Page")),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isNotEmpty
        ? [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = "";
              },
            )
          ]
        : [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    AppConfig appConfig=AppConfig.of(context);
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((city) => city.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.black),),                        
                  ]),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
}
