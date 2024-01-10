import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/tagObject.dart';

class TagSearchBox extends StatelessWidget {
  List<TagObject> initTags;
  Function(List<TagObject>) updateListCallback;

  TagSearchBox({required this.initTags, required this.updateListCallback});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      items: allTagList
          .map((tag) => MultiSelectItem<TagObject>(tag, tag.name))
          .toList(),
      searchable: true,
      searchHint: "Search for tags",
      buttonText: Text("Select Tags"),
      title: Text("Tags"),
      backgroundColor: Color(0xFFE7F9FF),
      selectedColor: Color(0xFF42C2FF),
      initialValue: initTags,
      onConfirm: (results) {
        updateListCallback(results);
      },
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: Color(0xFF000411),
          width: 2,
        ),
      ),
    );
  }
}
