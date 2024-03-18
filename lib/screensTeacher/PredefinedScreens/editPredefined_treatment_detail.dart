import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/my_secure_storage.dart';

class EditPredefinedTreatmentDetail extends StatefulWidget {
  Map<String, List<TreatmentObject>> groupedByType;
  String selectedType;

  EditPredefinedTreatmentDetail(
      {super.key, required this.groupedByType, required this.selectedType});

  @override
  State<EditPredefinedTreatmentDetail> createState() =>
      _EditPredefinedTreatmentDetailState();
}

class _EditPredefinedTreatmentDetailState
    extends State<EditPredefinedTreatmentDetail> {
  TextEditingController textFieldController = TextEditingController();
  TextEditingController costTextFieldController = TextEditingController();
  late List<TreatmentObject> fullList =
      widget.groupedByType[widget.selectedType]!;
  late List<TreatmentObject> displayList =
      widget.groupedByType[widget.selectedType]!;
  int selectedTileIndex = -1;
  TreatmentObject? oldItem;
  bool isEditing = false;
  bool isOtherPartVisible = false;
  final RegExp _formatCost = RegExp(r'^[0-9]+$');
  bool _isCostCorrect = true;
  String? oldItemId;
  List<TreatmentObject> deletedList = [];
  List<TreatmentObject> editedList = [];

  List<TreatmentObject> filterList(TextEditingController searchController,
      List<TreatmentObject> listForSearch) {
    if (selectedTileIndex == -1) {
      String query = searchController.text.toLowerCase();
      return listForSearch
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    } else {
      return listForSearch;
    }
  }

  ////post/////

  Future<void> _postDeleteData() async {
    if (deletedList.isNotEmpty) {
      var data = deletedList.map((item) {
        return {"id": item.id};
      }).toList();
      try {
        final http.Response response = await http.delete(
          Uri.parse("${dotenv.env['API_PATH']}/treatment"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer ${MySecureStorage().readSecureData('accessToken')}"
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
  }

  Future<void> _postUpdateData() async {
    if (editedList.isNotEmpty) {
      var data = editedList.map((item) {
        return {"id": item.id, "name": item.name, "cost": item.cost};
      }).toList();
      try {
        final http.Response response = await http.put(
          Uri.parse("${dotenv.env['API_PATH']}/treatment"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer ${MySecureStorage().readSecureData('accessToken')}"
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
  }

  bool checkNotEmpty() {
    if (_isCostCorrect == false) {
      return false;
    }
    return textFieldController.text != '' && costTextFieldController.text != '';
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
                children: [
                  Center(
                    child: Text(
                      widget.selectedType,
                      style: kSubHeaderTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('ชื่อ Treatment', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textFieldController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        displayList = filterList(textFieldController, fullList);
                        if (selectedTileIndex != -1) {
                          selectedTileIndex = displayList.indexOf(oldItem!);
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: "Treatment name",
                    ),
                  ),
                  Card(
                    color: const Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            tileColor: index == selectedTileIndex
                                ? const Color(0xFFA0E9FF)
                                : const Color(0xFFE7F9FF),
                            hoverColor: const Color(0xFFA0E9FF),
                            trailing: index == selectedTileIndex
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            textFieldController.text =
                                                displayList[index].name;
                                            costTextFieldController.text =
                                                displayList[index]
                                                    .cost
                                                    .toString();
                                            oldItem = displayList[index];
                                            isEditing = true;
                                          });
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            TreatmentObject item =
                                                displayList[selectedTileIndex];
                                            deletedList.add(item);
                                            fullList.remove(item);
                                            fullList.sort((a, b) =>
                                                a.name.compareTo(b.name));
                                            displayList = fullList;
                                            textFieldController.clear();
                                            costTextFieldController.clear();
                                            selectedTileIndex = -1;
                                          });
                                        },
                                        icon: const Icon(CupertinoIcons.delete),
                                      ),
                                    ],
                                  )
                                : null,
                            title: Text(displayList[index].name),
                            onTap: () {
                              setState(() {
                                if ((selectedTileIndex == -1) ||
                                    (selectedTileIndex != index)) {
                                  oldItem = displayList[index];
                                  costTextFieldController.text =
                                      displayList[index].cost.toString();
                                  isEditing = false;
                                  selectedTileIndex = index;
                                  isOtherPartVisible = true;
                                } else {
                                  oldItem = null;
                                  selectedTileIndex = -1;
                                  isEditing = false;
                                  isOtherPartVisible = false;
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const DividerWithSpace(),
                  /////cost/////
                  Visibility(
                    visible: isOtherPartVisible,
                    child: Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ราคา Treatment',
                              style: kSubHeaderTextStyle),
                          const SizedBox(height: 20),
                          TextField(
                            enabled: isEditing,
                            controller: costTextFieldController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              border: const OutlineInputBorder(),
                              hintText: "ราคา Treatment [ใส่แค่ตัวเลข]",
                              errorText: _isCostCorrect
                                  ? null
                                  : "ใส่แค่ตัวเลขเท่านั้น",
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isCostCorrect = value == ''
                                    ? false
                                    : _formatCost.hasMatch(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(myContext: context),
                      isEditing
                          ? ElevatedButton(
                              onPressed: () {
                                if (checkNotEmpty()) {
                                  oldItem!.name = textFieldController.text;
                                  oldItem!.cost =
                                      int.parse(costTextFieldController.text);
                                  editedList.add(oldItem!);
                                  setState(() {
                                    isEditing = false;
                                    textFieldController.clear();
                                    costTextFieldController.clear();
                                    selectedTileIndex = -1;
                                    fullList.sort(
                                        (a, b) => a.name.compareTo(b.name));
                                    displayList = fullList;
                                  });
                                }
                              },
                              child: const Text('บันทึกแก้ไข'))
                          : ElevatedButton(
                              onPressed: () async {
                                await _postUpdateData();
                                await _postDeleteData()
                                    .then((value) => Navigator.pop(context));
                              },
                              child: const Text('บันทึก'))
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
