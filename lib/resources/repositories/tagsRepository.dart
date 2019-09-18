import 'dart:async';
import 'dart:collection';

import 'package:biblio/models/tag.dart';

class TagsRepository {
  HashMap<String, Tag> tags;

  TagsRepository() {
    tags = HashMap<String, Tag>();
  }

  Tag tagById(String id) {
    return tags[id];
  }

  Future<void> addTagsFromJson(
      List<dynamic> json, double readerRssiAtOneMeter) async {
    if (json.length > 0) {
      Future.forEach(
        json.cast<Map<dynamic, dynamic>>(),
        (Map<dynamic, dynamic> tagJson) =>
            addTag(Tag.fromJson(tagJson), readerRssiAtOneMeter),
      );
    }
  }

  void addTag(Tag tag, double readerRssiAtOneMeter) {
    if (readerRssiAtOneMeter != null) {
      tag.calculateDistance(readerRssiAtOneMeter);
    }
    tags[tag.epc] = tag;
  }

  void removeTag(String tagEpc) {
    tags.remove(tagEpc);    
  }

  List<Tag> getTagsAsCollection() {
    return List<Tag>.from(tags.values);
  }

  void clear() {
    tags.clear();    
  }

  void dispose() {
    clear();
  }
}
