import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/components/back_button.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/AllDataFile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/my_secure_storage.dart';

class EditPreDefinedTreatmentAdd extends StatefulWidget {
  const EditPreDefinedTreatmentAdd({super.key});

  @override
  State<EditPreDefinedTreatmentAdd> createState() =>
      _EditPreDefinedTreatmentAddState();
}

class _EditPreDefinedTreatmentAddState
    extends State<EditPreDefinedTreatmentAdd> {
  TextEditingController typeTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController costTextController = TextEditingController();

  List<TreatmentObject> fullList = treatmentListPreDefined;

  /////type/////
  late Map<String, List<TreatmentObject>> groupedByType =
      groupBy(fullList, (e) => e.type);
  late List<String> typeNameList = groupedByType.keys.toList();
  late List typeDisplayList =
      filterStringList(typeTextController, typeNameList);

  /////name//////
  late String selectedType = groupedByType.values.first.first.type;
  // late List<String> nameList =
  //     groupedByType[selectedType]!.map((e) => e.name).toList();
  // late List nameDisplayList = filterStringList(nameTextController, nameList);
  late List<String> nameList = [];
  late List nameDisplayList = [];

  List<TreatmentObject> addedList = [];
  bool _isEditing = false;
  final RegExp _formatCost = RegExp(r'^[0-9]+$');
  bool _isCostCorrect = true;

  bool checkInput() {
    if (_formatCost.hasMatch(costTextController.text) == false) {
      return false;
    }
    return typeTextController.text != '' &&
        nameTextController.text != '' &&
        costTextController.text != '';
  }

  Future<void> _postAddData() async {
    var data = addedList.map((item) {
      return {"type": item.type, "name": item.name, "cost": item.cost};
    }).toList();
    try {
      final http.Response response = await http.post(
        Uri.parse("${dotenv.env['API_PATH']}/treatment"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
        },
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
                  Center(
                    child: Text(
                      'เพิ่ม Treatment',
                      style: kHeaderTextStyle.copyWith(
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const DividerWithSpace(),
                  /////type/////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('หัวข้อ Treatment',
                          style: kSubHeaderTextStyle),
                      ElevatedButton(
                        onPressed: () {
                          typeTextController.clear();
                          nameTextController.clear();
                          costTextController.clear();
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: typeTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        typeDisplayList =
                            filterStringList(typeTextController, typeNameList);
                        _isEditing = typeTextController.text != '' ||
                            nameTextController.text != '' ||
                            costTextController.text != '';
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "หัวข้อ Treatment",
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
                                  selectedType = typeDisplayList[index];
                                  nameList = groupedByType[selectedType]!
                                      .map((e) => e.name)
                                      .toList();
                                  _isEditing = typeTextController.text != '' ||
                                      nameTextController.text != '' ||
                                      costTextController.text != '';
                                });
                              },
                            ),
                          );
                        }),
                  ),
                  const DividerWithSpace(),
                  /////name/////
                  const Text('ชื่อ Treatment', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        nameDisplayList =
                            filterStringList(nameTextController, nameList);
                        _isEditing = typeTextController.text != '' ||
                            nameTextController.text != '' ||
                            costTextController.text != '';
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อ Treatment",
                    ),
                  ),
                  Card(
                    color: const Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: nameList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFB5C1BE), width: 1.0),
                            ),
                            child: ListTile(
                              hoverColor: const Color(0xFFA0E9FF),
                              title: Text(nameList[index]),
                              onTap: () {
                                setState(() {
                                  nameTextController.text = nameList[index];
                                  _isEditing = typeTextController.text != '' ||
                                      nameTextController.text != '' ||
                                      costTextController.text != '';
                                });
                              },
                            ),
                          );
                        }),
                  ),
                  const DividerWithSpace(),
                  /////cost/////
                  const Text('ราคา Treatment', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: costTextController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(),
                      hintText: "ราคา Treatment [ใส่แค่ตัวเลข]",
                      errorText: _isCostCorrect ? null : "ใส่แค่ตัวเลขเท่านั้น",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isCostCorrect =
                            value == '' ? false : _formatCost.hasMatch(value);
                      });
                    },
                  ),
                  const DividerWithSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyCancelButton(myContext: context),
                      _isEditing
                          ? ElevatedButton(
                              onPressed: () {
                                if (checkInput() == true) {
                                  TreatmentObject newItem = TreatmentObject(
                                    id: 'X',
                                    type: typeTextController.text,
                                    name: nameTextController.text,
                                    cost: int.parse(costTextController.text),
                                  );
                                  setState(() {
                                    fullList.add(newItem);
                                    groupedByType =
                                        groupBy(fullList, (e) => e.type);
                                    typeNameList = groupedByType.keys.toList();
                                    selectedType = typeTextController.text;
                                    nameList = groupedByType[selectedType]!
                                        .map((e) => e.name)
                                        .toList();
                                    _isEditing = false;
                                    typeDisplayList = typeNameList;
                                  });
                                  addedList.add(newItem);
                                  typeTextController.clear();
                                  nameTextController.clear();
                                  costTextController.clear();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF926096),
                              ),
                              child: const Text('เพิ่ม'),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await _postAddData().then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('บันทึก'),
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
