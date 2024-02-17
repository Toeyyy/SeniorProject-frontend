import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/components/backButton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditPredefinedOtherEdit extends StatefulWidget {
  final String title;

  EditPredefinedOtherEdit({required this.title});

  @override
  State<EditPredefinedOtherEdit> createState() =>
      _EditPredefinedOtherEditState();
}

class _EditPredefinedOtherEditState extends State<EditPredefinedOtherEdit> {
  TextEditingController textFieldController = TextEditingController();
  late List<dynamic> fullList = filterEditTopicList(widget.title);
  late List<dynamic> displayList = filterEditTopicList(widget.title);
  int selectedTileIndex = -1;
  bool isEditing = false;
  String? oldItem;
  String? oldItemID;
  String? newItem;
  List<dynamic> deletedList = [];
  List<dynamic> editedList = [];

  Future<void> _postDeleteData(String title) async {
    var data = deletedList.map((item) {
      return {"id": item.id};
    }).toList();
    try {
      if (title == 'Problem List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/problem/delete"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else if (title == 'Diagnosis List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/diagnostic/delete"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else if (title == 'Tag List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/tag/delete"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> _postEditData(String title) async {
    var data = editedList.map((item) {
      return {"id": item.id, "name": item.name};
    }).toList();
    try {
      if (title == 'Problem List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/problem/update"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else if (title == 'Diagnosis List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/diagnostic/update"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else if (title == 'Tag List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/tag/update"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  List<dynamic> filterNameList(
      TextEditingController searchController, List<dynamic> listForSearch) {
    if (selectedTileIndex == -1) {
      String query = searchController.text.toLowerCase();
      return listForSearch
          .where((item) => item.name.toLowerCase().startsWith(query))
          .toList();
    } else {
      return listForSearch;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  'แก้ไข/ลบ ${widget.title}',
                  style: kSubHeaderTextStyle,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      displayList =
                          filterNameList(textFieldController, fullList);
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    suffixIcon: !isEditing
                        ? null
                        : IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                newItem = textFieldController.text;
                                for (var item in fullList) {
                                  if (item.id == oldItemID) {
                                    editedList.add(item);
                                    item.name = newItem;
                                  }
                                }
                                isEditing = false;
                                textFieldController.clear();
                                selectedTileIndex = -1;
                                fullList
                                    .sort((a, b) => a.name.compareTo(b.name));
                                displayList = fullList;
                              });
                            }),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            tileColor: index == selectedTileIndex
                                ? Color(0xFFA0E9FF)
                                : Color(0xFFE7F9FF),
                            hoverColor: Color(0xFFA0E9FF),
                            trailing: index == selectedTileIndex
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          textFieldController.text =
                                              displayList[selectedTileIndex]
                                                  .name;
                                          setState(() {
                                            oldItem =
                                                displayList[selectedTileIndex]
                                                    .name;
                                            oldItemID =
                                                displayList[selectedTileIndex]
                                                    .id;
                                            isEditing = true;
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.pencil),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            deletedList.add(
                                                displayList[selectedTileIndex]);
                                            fullList.remove(
                                                displayList[selectedTileIndex]);
                                            fullList.sort((a, b) =>
                                                a.name.compareTo(b.name));
                                            displayList = fullList;
                                            textFieldController.clear();
                                            selectedTileIndex = -1;
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.delete),
                                      ),
                                    ],
                                  )
                                : null,
                            title: Text(displayList[index].name),
                            onTap: () {
                              setState(() {
                                if ((selectedTileIndex != -1) &
                                    (selectedTileIndex == index)) {
                                  selectedTileIndex = -1;
                                  isEditing = false;
                                } else {
                                  selectedTileIndex = index;
                                  isEditing = false;
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyBackButton(myContext: context),
                    ElevatedButton(
                      onPressed: () async {
                        if (editedList.isNotEmpty) {
                          await _postEditData(widget.title).then((value) {
                            Navigator.pop(context);
                          });
                        }
                        if (deletedList.isNotEmpty) {
                          await _postDeleteData(widget.title)
                              .then((value) => Navigator.pop(context));
                        }
                      },
                      child: Text('บันทึก'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
