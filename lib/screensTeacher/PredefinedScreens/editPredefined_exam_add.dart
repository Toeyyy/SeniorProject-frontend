import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/back_button.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/AllDataFile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditPreDefinedExamAdd extends StatefulWidget {
  const EditPreDefinedExamAdd({super.key});

  @override
  State<EditPreDefinedExamAdd> createState() => _EditPreDefinedExamAddState();
}

class _EditPreDefinedExamAddState extends State<EditPreDefinedExamAdd> {
  TextEditingController labTextController = TextEditingController();
  TextEditingController typeTextController = TextEditingController();
  TextEditingController areaTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController costTextController = TextEditingController();
  TextEditingController defaultTextController = TextEditingController();
  final RegExp _formatCost = RegExp(r'^[0-9]+$');
  bool _isFormatCorrect = false;
  List<ExamPreDefinedObject> addedList = [];
  List<ExamPreDefinedObject> fullList = examListPreDefined;

  /////lab/////
  late Map<String, List<ExamPreDefinedObject>> groupedByLab =
      groupBy(fullList, (e) => e.lab);
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
  late Map<String, List<ExamPreDefinedObject>> groupedByArea =
      groupBy(fullList.where((item) => item.area != null), (e) => e.area!);
  late List<String> areaNameList = groupedByArea.keys.toList();
  late List<String> areaDisplayList =
      filterList(areaTextController, areaNameList);

  /////name/////
  late List<ExamPreDefinedObject> selectedTypeList = groupedByType.values.first;
  late List<String> nameList = selectedTypeList.map((e) => e.name).toList();
  late List<String> nameDisplayList = filterList(nameTextController, nameList);

  bool _canSave = true;

  List<String> filterList(
      TextEditingController searchController, List<String> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.toLowerCase().startsWith(query))
        .toList();
  }

  /////post/////
  Future<void> _postAddData() async {
    try {
      var data = addedList.map((item) {
        return {
          "lab": item.lab,
          "type": item.type,
          "area": item.area == '' ? null : item.area,
          "name": item.name,
          "textDefault": item.defaultText,
          "cost": item.cost
        };
      }).toList();
      final http.Response response = await http.post(
        Uri.parse("${dotenv.env['API_PATH']}/exam"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if ((response.statusCode >= 200 && response.statusCode < 300)) {
        print("Posting complete");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  bool _checkEmpty() {
    return labTextController.text == '' &&
        typeTextController.text == '' &&
        nameTextController.text == '' &&
        costTextController.text == '' &&
        defaultTextController.text == '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
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
                  const DividerWithSpace(),
                  /////lab/////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('แผนกการตรวจ', style: kSubHeaderTextStyle),
                      ElevatedButton(
                          onPressed: () {
                            labTextController.clear();
                            typeTextController.clear();
                            areaTextController.clear();
                            defaultTextController.clear();
                            nameTextController.clear();
                            defaultTextController.clear();
                            setState(() {
                              _canSave = true;
                            });
                          },
                          child: const Text('Clear All')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: labTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        labDisplayList =
                            filterList(labTextController, labNameList);
                        _canSave = _checkEmpty();
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อแผนกการตรวจ เช่น อัลตราซาวด์",
                    ),
                  ),
                  Card(
                    color: const Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: labDisplayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: const Color(0xFFA0E9FF),
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
                                _canSave = _checkEmpty();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const DividerWithSpace(),
                  /////type//////
                  const Text('หัวข้อการตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: typeTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        typeDisplayList =
                            filterList(typeTextController, typeNameList);
                        _canSave = _checkEmpty();
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "หัวข้อการตรวจ",
                    ),
                  ),
                  Card(
                    color: const Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: typeDisplayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: const Color(0xFFA0E9FF),
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
                                _canSave = _checkEmpty();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const DividerWithSpace(),
                  /////area/////
                  const Text('ตัวอย่างที่ใช้ในการส่งตรวจ (Optional)',
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
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ตัวอย่างที่ใช้ในการส่งตรวจ เช่น Nasal Swab",
                    ),
                  ),
                  Card(
                    color: const Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: areaDisplayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: const Color(0xFFA0E9FF),
                            title: Text(areaDisplayList[index]),
                            onTap: () {
                              setState(() {
                                areaTextController.text =
                                    areaDisplayList[index];
                                _canSave = _checkEmpty();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const DividerWithSpace(),
                  /////name/////
                  const Text('ชื่อการส่งตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        nameDisplayList =
                            filterList(nameTextController, nameList);
                        _canSave = _checkEmpty();
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อการตรวจ",
                    ),
                  ),
                  Card(
                    color: const Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: nameDisplayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            hoverColor: const Color(0xFFA0E9FF),
                            title: Text(nameDisplayList[index]),
                            onTap: () {
                              setState(() {
                                nameTextController.text =
                                    nameDisplayList[index];
                                _canSave = _checkEmpty();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const DividerWithSpace(),
                  /////cost/////
                  const Text('ราคาการส่งตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: costTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        _isFormatCorrect =
                            value == '' ? false : _formatCost.hasMatch(value);
                        _canSave = _checkEmpty();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(),
                      hintText: "ราคาการส่งตรวจ [ใส่แค่ตัวเลข]",
                      errorText:
                          _isFormatCorrect ? null : "ใส่แค่ตัวเลขเท่านั้น",
                    ),
                  ),
                  const DividerWithSpace(),
                  ////default////
                  const Text('ค่าผลตรวจ Default', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: defaultTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        _canSave = _checkEmpty();
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ค่าผลตรวจ Default",
                    ),
                  ),
                  const DividerWithSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(myContext: context),
                      !_canSave
                          ? ElevatedButton(
                              onPressed: () {
                                if (_isFormatCorrect &&
                                    nameTextController.text != '' &&
                                    typeTextController.text != '' &&
                                    labTextController.text != '' &&
                                    defaultTextController.text != '' &&
                                    costTextController.text != '') {
                                  ExamPreDefinedObject newItem =
                                      ExamPreDefinedObject(
                                    id: 'X',
                                    lab: labTextController.text,
                                    type: typeTextController.text,
                                    area: areaTextController.text,
                                    name: nameTextController.text,
                                    defaultText: defaultTextController.text,
                                    cost: int.parse(costTextController.text),
                                  );
                                  setState(() {
                                    fullList.add(newItem);
                                    groupedByLab =
                                        groupBy(fullList, (e) => e.lab);
                                    labNameList = groupedByLab.keys.toList();
                                    selectedLabList = groupedByLab.values.first;
                                    groupedByType =
                                        groupBy(selectedLabList, (e) => e.type);
                                    typeNameList = groupedByType.keys.toList();
                                    groupedByArea = groupBy(
                                        fullList.where((item) =>
                                            (item.area != null &&
                                                item.area != '')),
                                        (e) => e.area!);
                                    areaNameList = groupedByArea.keys.toList();
                                    selectedTypeList =
                                        groupedByType.values.first;
                                    nameList = selectedTypeList
                                        .map((e) => e.name)
                                        .toList();
                                    _canSave = true;
                                    labDisplayList = labNameList;
                                    typeDisplayList = typeNameList;
                                    areaDisplayList = areaNameList;
                                  });
                                  addedList.add(newItem);
                                  labTextController.clear();
                                  typeTextController.clear();
                                  areaTextController.clear();
                                  nameTextController.clear();
                                  defaultTextController.clear();
                                  costTextController.clear();
                                }
                              },
                              child: const Text('เพิ่ม'),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await _postAddData()
                                    .then((value) => Navigator.pop(context));
                              },
                              child: const Text('บันทึก')),
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
