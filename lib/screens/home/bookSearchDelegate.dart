import 'package:flutter/material.dart';
import 'package:biblio/services/ciudades.dart';

class BookSearchDelegate extends SearchDelegate<String> {
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
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        shape: StadiumBorder(),
        child: Center(
          child: Text(
            query,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((city) => city.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = suggestionList[index];
              showResults(context);
            },
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.black),
                    ),
                  ]),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
}
