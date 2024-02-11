import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:frontend/AllDataFile.dart';

class TagSearchBox extends StatelessWidget {
  List<TagObject> initTags;
  Function(List<TagObject>) updateListCallback;

  TagSearchBox({required this.initTags, required this.updateListCallback});

  void printInitList() {
    print(initTags.map((item) => item.name));
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      // items: allTagList
      //     .map((tag) => MultiSelectItem<TagObject>(tag, tag.name))
      //     .toList(),
      items: tagListPreDefined
          .map((tag) => MultiSelectItem<TagObject>(tag, tag.name))
          .toList(),
      // items: initTags.map((tag) => MultiSelectItem(tag, tag.name)).toList(),
      searchable: true,
      searchHint: "Search for tags",
      buttonText: Text("Select Tags"),
      title: Text("Tags"),
      backgroundColor: Color(0xFFE7F9FF),
      selectedColor: Color(0xFF42C2FF),
      onConfirm: (results) {
        initTags = results;
        updateListCallback(initTags);
        // printInitList();
      },
      onSelectionChanged: (results) {
        initTags = results;
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

class TagMultiSelectDropDown extends StatelessWidget {
  List<TagObject> selectedList;
  final List<TagObject> displayList;
  String hintText;
  Function(List<TagObject>) updateListCallback;

  TagMultiSelectDropDown(
      {required this.selectedList,
      required this.displayList,
      required this.hintText,
      required this.updateListCallback});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
        searchEnabled: true,
        hint: hintText,
        chipConfig: ChipConfig(
            backgroundColor: Color(0xFF42C2FF), wrapType: WrapType.wrap),
        onOptionSelected: (List<ValueItem> selectedOptions) {
          updateListCallback(selectedOptions.map((item) {
            return TagObject(id: item.value, name: item.label);
          }).toList());
        },
        selectedOptions: selectedList.map((item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList(),
        options: displayList.map<ValueItem<String>>((TagObject item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList());
  }
}
