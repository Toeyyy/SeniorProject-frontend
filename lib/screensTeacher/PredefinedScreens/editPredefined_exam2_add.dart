import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam2_topic.dart';

class EditPreDefinedExam2Add extends StatefulWidget {
  const EditPreDefinedExam2Add({super.key});

  @override
  State<EditPreDefinedExam2Add> createState() => _EditPreDefinedExam2AddState();
}

class _EditPreDefinedExam2AddState extends State<EditPreDefinedExam2Add> {
  TextEditingController labTextController = TextEditingController();
  TextEditingController typeTextController = TextEditingController();
  TextEditingController areaTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController costTextController = TextEditingController();
  final RegExp _formatCost = RegExp(r'^[0-9]+$');
  final String apiUrl = "localhost:7197/api";
  bool _isFormatCorrect = false;

  /////lab/////
  Map<String, List<ExamPreDefinedObject>> groupedByLab =
      groupBy(preDefinedExamAll, (e) => e.lab);
  late List<String> labNameList = groupedByLab.keys.toList();
  late List<String> labDisplayList = filterList(labTextController, labNameList);

  /////type/////
  late List<ExamPreDefinedObject> selectedLabList = groupedByLab.values.first;
  late Map<String, List<ExamPreDefinedObject>> groupedByType =
      groupBy(selectedLabList, (e) => e.type);
  late List<String> typeNameList = groupedByType.keys.toList();
  late List<String> typeDisplayList =
      filterList(typeTextController, typeNameList);

  /////area/////
  Map<String, List<ExamPreDefinedObject>> groupedByArea = groupBy(
      preDefinedExamAll.where((item) => item.area != null), (e) => e.area!);
  late List<String> areaNameList = groupedByArea.keys.toList();
  late List<String> areaDisplayList =
      filterList(areaTextController, areaNameList);

  /////name/////
  late List<ExamPreDefinedObject> selectedTypeList = groupedByType.values.first;
  late List<String> nameList = selectedTypeList.map((e) => e.name).toList();
  late List<String> nameDisplayList = filterList(nameTextController, nameList);

  List<String> filterList(
      TextEditingController searchController, List<String> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.toLowerCase().startsWith(query))
        .toList();
  }

  /////post/////
  Future<void> _postAddData() async {
    var data = {
      "lab": labTextController.text,
      "type": typeTextController.text,
      "area": areaTextController.text,
      "name": nameTextController.text,
      "cost": int.parse(costTextController.text),
    };
    final http.Response response = await http.post(
      Uri.parse("$apiUrl/exam/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'เพิ่ม Examination',
                    style:
                        kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                  ),
                  DividerWithSpace(),
                  /////lab/////
                  Text('แผนกการตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: labTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        labDisplayList =
                            filterList(labTextController, labNameList);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อแผนกการตรวจ เช่น อัลตราซาวด์",
                    ),
                  ),
                  Card(
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: labDisplayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: Color(0xFFA0E9FF),
                            title: Text(labDisplayList[index]),
                            onTap: () {
                              setState(() {
                                labTextController.text = labDisplayList[index];
                                typeTextController.text = '';
                                nameTextController.text = '';
                                selectedLabList =
                                    groupedByLab[labDisplayList[index]]!;
                                groupedByType =
                                    groupBy(selectedLabList, (e) => e.type);
                                typeNameList = groupedByType.keys.toList();
                                typeDisplayList = filterList(
                                    typeTextController, typeNameList);
                                /////
                                selectedTypeList = groupedByType.values.first;
                                nameList = selectedTypeList
                                    .map((e) => e.name)
                                    .toList();
                                nameDisplayList =
                                    filterList(nameTextController, nameList);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  DividerWithSpace(),
                  /////type//////
                  Text('หัวข้อการตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: typeTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        typeDisplayList =
                            filterList(typeTextController, typeNameList);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "หัวข้อการตรวจ",
                    ),
                  ),
                  Card(
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: typeDisplayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: Color(0xFFA0E9FF),
                            title: Text(typeDisplayList[index]),
                            onTap: () {
                              setState(() {
                                typeTextController.text =
                                    typeDisplayList[index];
                                nameTextController.text = '';
                                groupedByType =
                                    groupBy(selectedLabList, (e) => e.type);
                                selectedTypeList =
                                    groupedByType[typeDisplayList[index]]!;
                                nameList = selectedTypeList
                                    .map((e) => e.name)
                                    .toList();
                                nameDisplayList =
                                    filterList(nameTextController, nameList);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  DividerWithSpace(),
                  /////area/////
                  Text('ตัวอย่างที่ใช้ในการส่งตรวจ',
                      style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: areaTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        areaDisplayList =
                            filterList(areaTextController, areaNameList);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ตัวอย่างที่ใช้ในการส่งตรวจ เช่น Nasal Swab",
                    ),
                  ),
                  Card(
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
                                color: Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: Color(0xFFA0E9FF),
                            title: Text(areaDisplayList[index]),
                            onTap: () {
                              setState(() {
                                areaTextController.text =
                                    areaDisplayList[index];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  DividerWithSpace(),
                  /////name/////
                  Text('ชื่อการส่งตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        nameDisplayList =
                            filterList(nameTextController, nameList);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อการตรวจ",
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
                            hoverColor: Color(0xFFA0E9FF),
                            title: Text(nameDisplayList[index]),
                            onTap: () {
                              setState(() {
                                nameTextController.text =
                                    nameDisplayList[index];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  DividerWithSpace(),
                  /////cost/////
                  Text('ราคาการส่งตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: costTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        _isFormatCorrect =
                            value == '' ? false : _formatCost.hasMatch(value);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ราคาการส่งตรวจ [ใส่แค่ตัวเลข]",
                      errorText:
                          _isFormatCorrect ? null : "ใส่แค่ตัวเลขเท่านั้น",
                    ),
                  ),
                  DividerWithSpace(),
                  ////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(myContext: context),
                      ElevatedButton(
                        onPressed: () {
                          if (_isFormatCorrect &&
                              nameTextController.text != '' &&
                              typeTextController.text != '' &&
                              labTextController.text != '') {
                            ExamPreDefinedObject newItem = ExamPreDefinedObject(
                              id: 'X',
                              lab: labTextController.text,
                              type: typeTextController.text,
                              area: areaTextController.text,
                              name: nameTextController.text,
                              cost: int.parse(costTextController.text),
                            );
                            preDefinedExamAll.add(newItem);
                            _postAddData();
                            Navigator.pop(context);
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
      ),
    );
  }
}
