import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:http/http.dart' as http;

class EditPredefinedListDetail extends StatefulWidget {
  final String title;

  EditPredefinedListDetail({required this.title});

  @override
  State<EditPredefinedListDetail> createState() =>
      _EditPredefinedListDetailState();
}

class _EditPredefinedListDetailState extends State<EditPredefinedListDetail> {
  TextEditingController textFieldController = TextEditingController();
  late List<dynamic> fullList = filterEditTopicList(widget.title);
  late List<dynamic> displayList = filterEditTopicList(widget.title);
  int selectedTileIndex = -1;
  bool isEditing = false;
  String? oldItem;
  String? oldItemID;
  String? newItem;
  final String apiUrl = "localhost:7901/api";

  Future<void> _PostAddData(String title, String item) async {
    if (title == 'Problem List') {
      var data = {"name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/problem/add"),
        body: jsonEncode(data),
      );
    } else if (title == 'Diagnosis List') {
      var data = {"name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/diagnostic/add"),
        body: jsonEncode(data),
      );
    } else if (title == 'Nutrition Support List') {
      var data = {"type": "Nutritional support", "name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/treatment/add"),
        body: jsonEncode(data),
      );
    } else {
      var data = {"type": title.split(' ')[0], "name": item};
      // print('data = ${title.split(' ')[0]}');
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/treatment/add"),
        body: jsonEncode(data),
      );
    }
  }

  Future<void> _postDeleteData(String title, String id) async {
    if (title == 'Problem List') {
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/problem/delete/$id"),
      );
    } else if (title == 'Diagnosis List') {
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/diagnostic/delete/$id"),
      );
    } else {
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/treatment/delete/$id"),
      );
    }
  }

  Future<void> _postEditData(String title, String id, String item) async {
    if (title == 'Problem List') {
      var data = {"name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/problem/update/$id"),
        body: jsonEncode(data),
      );
    } else if (title == 'Diagnosis List') {
      var data = {"name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/diagnostic/update/$id"),
        body: jsonEncode(data),
      );
    } else if (title == 'Nutrition Support List') {
      var data = {"type": "Nutritional support", "name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/treatment/update/$id"),
        body: jsonEncode(data),
      );
    } else {
      var data = {"type": title.split(' ')[0], "name": item};
      final http.Response response = await http.post(
        Uri.parse("$apiUrl/treatment/update/$id"),
        body: jsonEncode(data),
      );
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
                  widget.title,
                  style: kSubHeaderTextStyle,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: textFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      displayList = filterList(textFieldController, fullList);
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    suffixIcon: !isEditing
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (widget.title == 'Problem List') {
                                  ProblemObject newItem = ProblemObject(
                                      id: 'X', name: textFieldController.text);
                                  fullList.add(newItem);
                                } else if (widget.title == 'Diagnosis List') {
                                  DiagnosisObject newItem = DiagnosisObject(
                                      id: 'X', name: textFieldController.text);
                                  fullList.add(newItem);
                                } else {
                                  TreatmentObject newItem = TreatmentObject(
                                      id: 'X',
                                      type: (widget.title ==
                                              'Nutrition Support List')
                                          ? "Nutritional support"
                                          : widget.title.split(' ')[0],
                                      name: textFieldController.text);
                                  fullList.add(newItem);
                                }
                                _PostAddData(widget.title,
                                    textFieldController.text); //send data
                                textFieldController.clear();
                                displayList = fullList;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                newItem = textFieldController.text;
                                for (var item in fullList) {
                                  if (item.id == oldItemID) {
                                    _postEditData(
                                        widget.title, item.id, item.name);
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
                    margin: EdgeInsets.symmetric(horizontal: 15),
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
                                            _postDeleteData(
                                                widget.title,
                                                displayList[selectedTileIndex]
                                                    .id);
                                            fullList.remove(
                                                displayList[selectedTileIndex]);
                                            // print('state1 = ${fullList.map((e) => e.name).toList()}');
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('กลับ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B72BE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
