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

  Future<void> addTagsFromJson(List<dynamic> json) async {
    Future.forEach(json.cast<Map<dynamic, dynamic>>(),
        (Map<dynamic, dynamic> tagJson) => addTag(Tag.fromJson(tagJson)));
  }

  void addTag(Tag tag) {
    if (!tags.containsKey(tag.epc)) {
      tags[tag.epc] = tag;
    }
  }

  List<Tag> getTagsAsCollection() {    
    return List<Tag>.from(tags.values);
  }

  void clear() {
    tags.clear();
  }

  void dispose() {
    tags = null;
  }
}
