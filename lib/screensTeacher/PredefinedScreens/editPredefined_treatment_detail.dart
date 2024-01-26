import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditPredefinedTreatmentDetail extends StatefulWidget {
  Map<String, List<TreatmentObject>> groupedByType;
  String selectedType;

  EditPredefinedTreatmentDetail(
      {required this.groupedByType, required this.selectedType});

  @override
  State<EditPredefinedTreatmentDetail> createState() =>
      _EditPredefinedTreatmentDetailState();
}

class _EditPredefinedTreatmentDetailState
    extends State<EditPredefinedTreatmentDetail> {
  TextEditingController textFieldController = TextEditingController();
  int selectedTileIndex = -1;
  TreatmentObject? oldItem;
  bool isEditing = false;

  // final String apiUrl = "localhost:7197/api";
  final RegExp _formatRegExp =
      RegExp(r'^\s*[\p{L}0-9\s]+,\s*[0-9]+\s*$', unicode: true);
  bool _isFormatCorrect = true;

  List<TreatmentObject> filterList(TextEditingController searchController,
      List<TreatmentObject> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.name.toLowerCase().startsWith(query))
        .toList();
  }

  ////post/////
  Future<void> _postAddData(TreatmentObject item) async {
    var data = {"type": item.type, "name": item.name, "cost": item.cost};
    final http.Response response = await http.post(
      Uri.parse("${dotenv.env['API_PATH']}/treatment/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  Future<void> _postDeleteData(String id) async {
    final http.Response response = await http.post(
      Uri.parse("${dotenv.env['API_PATH']}/treatment/delete/$id"),
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<void> _postUpdateData(
      TreatmentObject oldItem, List<String> newItem) async {
    var data = {
      "name": newItem[0],
      "cost": int.parse(newItem[1]),
    };
    final http.Response response = await http.post(
      Uri.parse("${dotenv.env['API_PATH']}/treatment/update/${oldItem.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedType = widget.selectedType;
    List<TreatmentObject> fullList = widget.groupedByType[selectedType]!;
    List<TreatmentObject> displayList =
        filterList(textFieldController, widget.groupedByType[selectedType]!);

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
                  selectedType,
                  style: kSubHeaderTextStyle,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: textFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      _isFormatCorrect =
                          value == '' ? true : _formatRegExp.hasMatch(value);
                      displayList = filterList(textFieldController, fullList);
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: "Exam name, cost",
                    errorText: _isFormatCorrect
                        ? null
                        : "Please use the correct format: 'Exam name,cost'",
                    suffixIcon: !isEditing
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              !_isFormatCorrect
                                  ? null
                                  : setState(() {
                                      List<String> txt = textFieldController
                                          .text
                                          .split(',')
                                          .map((e) => e.trim())
                                          .toList();
                                      TreatmentObject newItem = TreatmentObject(
                                          id: 'X',
                                          type: widget
                                              .groupedByType[selectedType]!
                                              .first
                                              .type,
                                          name: txt[0],
                                          cost: int.parse(txt[1]));
                                      _postAddData(newItem);
                                      fullList.add(newItem);
                                      textFieldController.clear();
                                      displayList = fullList;
                                    });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              !_isFormatCorrect
                                  ? null
                                  : setState(() {
                                      List<String> txt = textFieldController
                                          .text
                                          .split(',')
                                          .map((e) => e.trim())
                                          .toList();
                                      _postUpdateData(oldItem!, txt);
                                      oldItem!.name = txt[0];
                                      oldItem!.cost = int.parse(txt[1]);
                                      isEditing = false;
                                      _isFormatCorrect = true;
                                      textFieldController.clear();
                                      selectedTileIndex = -1;
                                      fullList.sort(
                                          (a, b) => a.name.compareTo(b.name));
                                      displayList = fullList;
                                    });
                            },
                          ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: fullList.length,
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
                                              '${fullList[selectedTileIndex].name},${fullList[selectedTileIndex].cost}';
                                          setState(() {
                                            oldItem =
                                                displayList[selectedTileIndex];
                                            isEditing = true;
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.pencil),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            TreatmentObject item =
                                                displayList[selectedTileIndex];
                                            _postDeleteData(item.id);
                                            fullList.remove(item);
                                            fullList.sort((a, b) =>
                                                a.name.compareTo(b.name));
                                            displayList = widget
                                                .groupedByType[selectedType]!;
                                            textFieldController.clear();
                                            _isFormatCorrect = true;
                                            selectedTileIndex = -1;
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.delete),
                                      ),
                                    ],
                                  )
                                : null,
                            title: Text(
                                '${fullList[index].name},${fullList[index].cost}'),
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
                MyBackButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
