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
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';

class EditPredefinedExamName extends StatefulWidget {
  String selectedType;
  EditPredefinedExamName({required this.selectedType});

  @override
  State<EditPredefinedExamName> createState() => _EditPredefinedExamNameState();
}

class _EditPredefinedExamNameState extends State<EditPredefinedExamName> {
  TextEditingController nameTextFieldController = TextEditingController();
  TextEditingController areaTextFieldController = TextEditingController();
  TextEditingController costTextFieldController = TextEditingController();
  int selectedTileIndex = -1;
  bool _isEditing = false;
  bool _isOtherPartVisible = false;
  ExamPreDefinedObject? oldItem;
  ExamPreDefinedObject? selectedItem;
  String selectedId = '';
  // final String apiUrl = "localhost:7197/api";
  final RegExp _formatName = RegExp(r'^\s*[\p{L}0-9\s]+$', unicode: true);
  final RegExp _formatCost = RegExp(r'^[0-9]+$');
  bool _isFormatNameCorrect = true;
  bool _isFormatCostCorrect = true;

  // List<String> areaList = groupBy(
  //         preDefinedExamAll.where((item) => item.area != null), (e) => e.area!)
  //     .keys
  //     .toList();
  List<String> areaList = groupBy(
          examListPreDefined.where((item) => item.area != null), (e) => e.area!)
      .keys
      .toList();

  List<ExamPreDefinedObject> nameFilterList(
      TextEditingController searchController,
      List<ExamPreDefinedObject> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.name.toLowerCase().startsWith(query))
        .toList();
  }

  List<String> areaFilterList(
      TextEditingController searchController, List<String> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.toLowerCase().startsWith(query))
        .toList();
  }

  //////post///////

  Future<void> _postDeleteData(String id) async {
    final http.Response response = await http.post(
      Uri.parse("${dotenv.env['API_PATH']}/exam/delete/$id"),
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<void> _postUpdateData(
      String id, String newName, String newArea, int newCost) async {
    var data = {
      "name": newName,
      "area": newArea == '' ? null : newArea,
      "cost": newCost,
    };
    final http.Response response = await http.post(
      Uri.parse("${dotenv.env['API_PATH']}/exam/update/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  /////

  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);
    List<ExamPreDefinedObject> groupedExam =
        examProvider.getGroupByType(widget.selectedType);
    List<ExamPreDefinedObject> nameDisplayList =
        nameFilterList(nameTextFieldController, groupedExam);
    // List<ExamPreDefinedObject> nameDisplayList = groupedExam;
    List<String> areaDisplayList =
        areaFilterList(areaTextFieldController, areaList);
    // List<String> areaDisplayList = areaList;

    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      groupedExam.first.type,
                      style: kSubHeaderTextStyle,
                    ),
                  ),
                  DividerWithSpace(),
                  Text('ชื่อการตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameTextFieldController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        _isFormatNameCorrect = _formatName.hasMatch(value);
                        nameDisplayList = nameFilterList(
                            nameTextFieldController, groupedExam);
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: "Exam name",
                      errorText:
                          _isFormatNameCorrect ? null : "Please fill text box",
                      suffixIcon: _isEditing
                          ? IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () {
                                setState(() {
                                  if (_isFormatNameCorrect == true &&
                                      _isFormatCostCorrect == true) {
                                    examProvider.updateItem(
                                        selectedId,
                                        nameTextFieldController.text,
                                        areaTextFieldController.text,
                                        int.parse(costTextFieldController.text),
                                        selectedItem!.lab);
                                    _postUpdateData(
                                        selectedId,
                                        nameTextFieldController.text,
                                        areaTextFieldController.text,
                                        int.parse(
                                            costTextFieldController.text));
                                    _isEditing = false;
                                  } else {
                                    null;
                                  }
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  Card(
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: nameDisplayList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFB5C1BE), width: 1.0),
                            ),
                            child: ListTile(
                              tileColor: selectedTileIndex == index
                                  ? Color(0xFFA0E9FF)
                                  : Color(0xFFE7F9FF),
                              hoverColor: Color(0xFFA0E9FF),
                              trailing: index == selectedTileIndex
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(CupertinoIcons.pencil),
                                          onPressed: () {
                                            nameTextFieldController.text =
                                                nameDisplayList[index].name;
                                            setState(() {
                                              _isEditing = true;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(CupertinoIcons.delete),
                                          onPressed: () {
                                            setState(() {
                                              examProvider
                                                  .deleteItem(selectedItem!);
                                              groupedExam.remove(selectedItem);
                                              _postDeleteData(selectedId);
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  : null,
                              title: Text(nameDisplayList[index].name),
                              onTap: () {
                                setState(() {
                                  if (selectedTileIndex == -1 ||
                                      selectedTileIndex != index) {
                                    selectedItem = nameDisplayList[index];
                                    // print(selectedItem);
                                    selectedId = selectedItem!.id;
                                    if (groupedExam == nameDisplayList) {
                                      selectedTileIndex =
                                          groupedExam.indexOf(selectedItem!);
                                    } else {
                                      selectedTileIndex = nameDisplayList
                                          .indexOf(selectedItem!);
                                    }
                                    print(
                                        'selectedTileIndex = $selectedTileIndex');
                                    _isOtherPartVisible = true;
                                    areaTextFieldController.text =
                                        (selectedItem?.area ?? "");
                                    costTextFieldController.text =
                                        selectedItem!.cost.toString();
                                  } else {
                                    selectedId = '';
                                    selectedTileIndex = -1;
                                    selectedItem = null;
                                    _isEditing = false;
                                    _isOtherPartVisible = false;
                                  }
                                });
                              },
                            ),
                          );
                        }),
                  ),
                  DividerWithSpace(),
                  /////area/////
                  Visibility(
                    visible: _isOtherPartVisible,
                    child: Container(
                      margin: EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ตัวอย่างที่ใช้ในการส่งตรวจ',
                              style: kSubHeaderTextStyle),
                          const SizedBox(height: 20),
                          TextField(
                            enabled: _isEditing,
                            controller: areaTextFieldController,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) {
                              setState(() {
                                areaDisplayList = areaFilterList(
                                    areaTextFieldController, areaList);
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: "ชื่อตัวอย่างที่ใช้ในการส่งตรวจ",
                            ),
                          ),
                          Visibility(
                            visible: _isEditing,
                            child: Card(
                              color: Color(0xFFF2F5F7),
                              elevation: 0,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: areaDisplayList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFB5C1BE),
                                            width: 1.0),
                                      ),
                                      child: ListTile(
                                        // tileColor: index == selectedTileIndex
                                        //     ? Color(0xFFA0E9FF)
                                        //     : Color(0xFFE7F9FF),
                                        tileColor: Color(0xFFE7F9FF),
                                        hoverColor: Color(0xFFA0E9FF),
                                        title: Text(areaDisplayList[index]),
                                        onTap: () {
                                          setState(() {
                                            areaTextFieldController.text =
                                                areaDisplayList[index];
                                          });
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          DividerWithSpace(),
                          /////cost/////
                          Text('ราคาการส่งตรวจ', style: kSubHeaderTextStyle),
                          const SizedBox(height: 20),
                          TextField(
                            enabled: _isEditing,
                            controller: costTextFieldController,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) {
                              setState(() {
                                _isFormatCostCorrect =
                                    _formatCost.hasMatch(value);
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: "ราคาการส่งตรวจ",
                              errorText: _isFormatCostCorrect
                                  ? null
                                  : "Please fill text box",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: MyBackButton(myContext: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// suffixIcon: IconButton(
//   icon: Icon(CupertinoIcons.pencil),
//   onPressed: () {
//     !_isFormatNameCorrect
//         ? null
//         : setState(() {
//             // _postUpdateData(oldItem!, textFieldController.text);
//             // examProvider.updateItem(
//             //     oldItem!.id, nameTextFieldController.text, oldItem!.lab);
//             // isEditing = false;
//             // nameTextFieldController.clear();
//             // selectedTileIndex = -1;
//             // groupedExam.sort((a, b) =>
//             //     a.name.compareTo(b.name));
//             // displayList = groupedExam;
//           });
//   },
// ),
