import 'package:biblio/ui/screens/blocEvent.dart';
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
    return Container(
      color: index != null && index % 2 == 0 ? Colors.grey[100] : null,
      child: ListTile(
        leading: Text(index != null ? index.toString() : ''),
        title: Text(tag.epc),
        subtitle: tag.distance != null
            ? Text('Distancia aprox.: ${tag.distance.toString()} metros')
            : const Text('Distancia desconocida'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            inventoryScreenBloc.events.add(
              BlocEvent(action: InventoryAction.DISCARD_TAG, data: tag.epc),
            );
          },
        ),
        dense: true,        
      ),
    );
  }
}
