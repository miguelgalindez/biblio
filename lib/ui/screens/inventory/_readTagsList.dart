import 'package:flutter/material.dart';
import 'package:biblio/models/tag.dart';
import 'package:biblio/ui/screens/inventory/inventoryScreenBloc.dart';
import '_style.dart';

class ReadTagslist extends StatelessWidget {
  final InventoryScreenBloc screenBloc;
  final Color backgroundColor;
  ReadTagslist(
      {@required this.screenBloc, this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: StreamBuilder(
        stream: screenBloc.allTags,
        builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReadTag(
                    index: index + 1,
                    tag: snapshot.data[index],
                  );
                },
              );
            } else {
              return Container();
            }
          } else if (snapshot.hasError) {
            return const Text("Error", style: redLabelTextStyle);
          } else {
            return const Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ReadTag extends StatelessWidget {
  final int index;
  final Tag tag;
  ReadTag({this.index, @required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(index != null ? index.toString() : ''),
      title: Text(tag.epc),
      subtitle: Text(tag.rssi ?? ''),
      trailing: Icon(Icons.delete),
      dense: true,
      isThreeLine: true,
    );
  }
}
