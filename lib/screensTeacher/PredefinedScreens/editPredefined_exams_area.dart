import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditPredefinedExamArea extends StatefulWidget {
  String selectedType;

  EditPredefinedExamArea({required this.selectedType});

  @override
  State<EditPredefinedExamArea> createState() => _EditPredefinedExamAreaState();
}

class _EditPredefinedExamAreaState extends State<EditPredefinedExamArea> {
  TextEditingController textFieldController = TextEditingController();
  int selectedTileIndex = -1;
  bool isEditing = false;
  ExamPreDefinedObject? oldItem;
  final String apiUrl = "localhost:7197/api";

  List<ExamPreDefinedObject> filterList(TextEditingController searchController,
      List<ExamPreDefinedObject> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.name.toLowerCase().startsWith(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);
    List<ExamPreDefinedObject> groupedExam =
        examProvider.getGroupByType(widget.selectedType);
    Map<String, List<ExamPreDefinedObject>> groupedArea =
        groupBy(groupedExam.where((item) => item.area != null), (e) => e.area!);
    List<String> areaList = groupedArea.keys.toList();
    List<ExamPreDefinedObject> displayList =
        filterList(textFieldController, groupedExam);

    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text('Edit area in ${widget.selectedType}',
                    style: kSubHeaderTextStyle),
                SizedBox(height: 20),
                TextField(
                  controller: textFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      displayList =
                          filterList(textFieldController, groupedExam);
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: "Area name",
                    suffixIcon: !isEditing
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                ExamPreDefinedObject newItem =
                                    ExamPreDefinedObject(
                                        id: 'X',
                                        lab: groupedExam.first.lab,
                                        type: groupedExam.first.type,
                                        area: textFieldController.text,
                                        name: groupedExam.first.name,
                                        cost: groupedExam.first.cost);
                                // _postAddData(newItem);
                                examProvider.addNewItem(newItem);
                                groupedExam.add(newItem);
                                //TODO put post
                                textFieldController.clear();
                                displayList = groupedExam;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                //TODO put update
                                // _postUpdateData(oldItem!, txt);
                                examProvider.updateAreaName(oldItem!.id,
                                    textFieldController.text, oldItem!.lab);
                                isEditing = false;
                                textFieldController.clear();
                                selectedTileIndex = -1;
                                groupedExam
                                    .sort((a, b) => a.area!.compareTo(b.area!));
                                displayList = groupedExam;
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
                                                textFieldController.text;
                                            setState(() {
                                              oldItem = displayList[
                                                  selectedTileIndex];
                                              isEditing = true;
                                            });
                                          },
                                          icon: Icon(CupertinoIcons.pencil),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              ExamPreDefinedObject item =
                                                  displayList[
                                                      selectedTileIndex];
                                              //TODO put delete
                                              // _postDeleteData(item.id);
                                              groupedExam.remove(item);
                                              examProvider.deleteItem(item);
                                              groupedExam.sort((a, b) =>
                                                  a.area!.compareTo(b.area!));
                                              displayList = groupedExam;
                                              textFieldController.clear();
                                              selectedTileIndex = -1;
                                            });
                                          },
                                          icon: Icon(CupertinoIcons.delete),
                                        ),
                                      ],
                                    )
                                  : null,
                              title: Text(displayList[index].area.toString()),
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
                        }),
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
