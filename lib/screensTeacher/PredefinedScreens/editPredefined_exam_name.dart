import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:dio/dio.dart';

class EditPredefinedExamName extends StatefulWidget {
  String selectedType;
  EditPredefinedExamName({super.key, required this.selectedType});

  @override
  State<EditPredefinedExamName> createState() => _EditPredefinedExamNameState();
}

class _EditPredefinedExamNameState extends State<EditPredefinedExamName> {
  TextEditingController nameTextFieldController = TextEditingController();
  TextEditingController areaTextFieldController = TextEditingController();
  TextEditingController costTextFieldController = TextEditingController();
  TextEditingController defaultTextFieldController = TextEditingController();
  String? imagePath;
  PlatformFile? imageDefault;
  int selectedTileIndex = -1;
  bool _isEditing = false;
  bool _isOtherPartVisible = false;
  ExamPreDefinedObject? selectedItem;
  final RegExp _formatCost = RegExp(r'^[0-9]+$');
  bool _isFormatCostCorrect = true;
  List<ExamPreDefinedObject> editedList = [];
  List<ExamPreDefinedObject> deletedList = [];

  List<String> areaList = groupBy(
          examListPreDefined.where((item) => item.area != null), (e) => e.area!)
      .keys
      .toList();

  bool _checkNotEmpty() {
    return nameTextFieldController.text != '' &&
        costTextFieldController.text != '';
  }

  List<ExamPreDefinedObject> nameFilterList(
      TextEditingController searchController,
      List<ExamPreDefinedObject> listForSearch) {
    if (selectedTileIndex == -1) {
      String query = searchController.text.toLowerCase();
      return listForSearch
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    } else {
      return listForSearch;
    }
  }

  List<String> areaFilterList(
      TextEditingController searchController, List<String> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.toLowerCase().contains(query))
        .toList();
  }

  //////post///////

  Future<void> _postDeleteData() async {
    if (deletedList.isNotEmpty) {
      try {
        var data = deletedList.map((item) {
          return {"id": item.id};
        }).toList();
        final http.Response response = await http.delete(
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
  }

  Future<void> _postUpdateData() async {
    if (editedList.isNotEmpty) {
      final dio = Dio();
      try {
        var data = editedList.map((item) {
          return {
            "id": item.id,
            "lab": item.lab,
            "type": item.type,
            "area": item.area != '' ? null : item.area,
            "name": item.name,
            "textDefault": item.textDefault != '' ? null : item.textDefault,
            "imgDefault": item.imgDefault != null
                ? MultipartFile.fromBytes(item.imgDefault!.bytes!,
                    filename: "image", contentType: MediaType("image", "png"))
                : null,
            "imgPath": item.imgPath != null ? imagePath : null,
            "cost": item.cost
          };
        });

        FormData formData = FormData.fromMap({
          "examinations": data,
        }, ListFormat.multiCompatible);

        var index = 0;
        for (var item in editedList) {
          if (item.imgDefault != null) {
            formData.files.add(
              MapEntry(
                "examinations[$index].imgDefault",
                MultipartFile.fromBytes(
                  item.imgDefault!.bytes!,
                  filename: "image1.png",
                  contentType: MediaType("image", "png"),
                ),
              ),
            );
          }
          index++;
        }

        final response =
            await dio.put("${dotenv.env['API_PATH']}/exam", data: formData);
        print('Response: ${response.statusCode} - ${response.data}');
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  /////

  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        imageDefault = result.files.first;
        imagePath = null;
      });
    }
  }

  Widget displayImage() {
    if (imagePath != null && imageDefault == null) {
      return Image.network(
        "${dotenv.env['RESOURCE_PATH']}${imagePath!.replaceFirst("Uploads", "")}",
        height: 200,
        width: 300,
        fit: BoxFit.cover,
      );
    } else if (imageDefault != null) {
      return Image.memory(
        Uint8List.fromList(imageDefault!.bytes!),
        height: 200,
        width: 300,
        fit: BoxFit.cover,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);
    examProvider.assignItem(examListPreDefined);
    List<ExamPreDefinedObject> groupedExam =
        examProvider.getGroupByType(widget.selectedType);
    List<ExamPreDefinedObject> nameDisplayList =
        nameFilterList(nameTextFieldController, groupedExam);
    List<String> areaDisplayList =
        areaFilterList(areaTextFieldController, areaList);

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
                  const DividerWithSpace(),
                  const Text('ชื่อการตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameTextFieldController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        nameDisplayList = nameFilterList(
                            nameTextFieldController, groupedExam);
                      });
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: "Exam name only",
                    ),
                  ),
                  nameDisplayList.isNotEmpty
                      ? Card(
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
                                        color: const Color(0xFFB5C1BE),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    tileColor: selectedTileIndex == index
                                        ? const Color(0xFFA0E9FF)
                                        : const Color(0xFFE7F9FF),
                                    hoverColor: const Color(0xFFA0E9FF),
                                    trailing: index == selectedTileIndex
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  setState(() {
                                                    nameTextFieldController
                                                            .text =
                                                        nameDisplayList[index]
                                                            .name;
                                                    nameDisplayList =
                                                        nameFilterList(
                                                            nameTextFieldController,
                                                            groupedExam);
                                                    selectedTileIndex =
                                                        nameDisplayList.indexOf(
                                                            selectedItem!);
                                                    _isEditing = true;
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    CupertinoIcons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    examProvider.deleteItem(
                                                        selectedItem!);
                                                    deletedList
                                                        .add(selectedItem!);
                                                    groupedExam
                                                        .remove(selectedItem);
                                                    nameDisplayList =
                                                        groupedExam;
                                                    nameTextFieldController
                                                        .clear();
                                                    costTextFieldController
                                                        .clear();
                                                    defaultTextFieldController
                                                        .clear();
                                                    imagePath = null;
                                                    imageDefault = null;
                                                    areaTextFieldController
                                                        .clear();
                                                    selectedTileIndex = -1;
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        : null,
                                    title: nameDisplayList[index].area != null
                                        ? Text(
                                            '${nameDisplayList[index].name}, ${nameDisplayList[index].area}')
                                        : Text(nameDisplayList[index].name),
                                    onTap: () {
                                      setState(() {
                                        if (selectedTileIndex == -1 ||
                                            selectedTileIndex != index) {
                                          selectedItem = nameDisplayList[index];
                                          if (groupedExam == nameDisplayList) {
                                            selectedTileIndex = index;
                                          } else {
                                            selectedTileIndex = nameDisplayList
                                                .indexOf(selectedItem!);
                                          }
                                          _isEditing = false;
                                          _isOtherPartVisible = true;
                                          areaTextFieldController.text =
                                              (selectedItem?.area ?? "");
                                          costTextFieldController.text =
                                              selectedItem!.cost.toString();
                                          defaultTextFieldController.text =
                                              (selectedItem?.textDefault ?? "");
                                          imagePath = selectedItem?.imgPath;
                                          imageDefault =
                                              selectedItem?.imgDefault;
                                        } else {
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
                        )
                      : const SizedBox(),
                  const DividerWithSpace(),
                  /////area/////
                  Visibility(
                    visible: _isOtherPartVisible,
                    child: Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ตัวอย่างที่ใช้ในการส่งตรวจ (Optional)',
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
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText:
                                  "ชื่อตัวอย่างที่ใช้ในการส่งตรวจ เช่น Nasal Swab",
                            ),
                          ),
                          Visibility(
                            visible: _isEditing,
                            child: Card(
                              color: const Color(0xFFF2F5F7),
                              elevation: 0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: areaDisplayList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFB5C1BE),
                                            width: 1.0),
                                      ),
                                      child: ListTile(
                                        tileColor: const Color(0xFFE7F9FF),
                                        hoverColor: const Color(0xFFA0E9FF),
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
                          const DividerWithSpace(),
                          /////cost/////
                          const Text('ราคาการส่งตรวจ',
                              style: kSubHeaderTextStyle),
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
                              border: const OutlineInputBorder(),
                              hintText: "ราคาการส่งตรวจ [ใส่แค่ตัวเลขเท่านั้น]",
                              errorText: _isFormatCostCorrect
                                  ? null
                                  : "Please use correct format: number only",
                            ),
                          ),
                          const DividerWithSpace(),
                          /////default/////
                          const Text('ค่าผลตรวจ Default (Optional)',
                              style: kSubHeaderTextStyle),
                          const SizedBox(height: 20),
                          TextField(
                            enabled: _isEditing,
                            controller: defaultTextFieldController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText:
                                  "ค่าผลตรวจ Default [ถ้าไม่ใส่จะมีค่าเป็น 'ค่าปกติ']",
                            ),
                          ),
                          const SizedBox(height: 15),
                          Visibility(
                            visible: _isEditing,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: pickImage,
                                  child:
                                      const Text('เพิ่มรูป Default (Optional)'),
                                ),
                                const SizedBox(width: 20),
                                Visibility(
                                  visible:
                                      imagePath != null || imageDefault != null,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        imagePath = null;
                                        imageDefault = null;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8B72BE),
                                    ),
                                    child: const Text('ลบรูป'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          displayImage(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(myContext: context),
                      _isEditing
                          ? ElevatedButton(
                              onPressed: () {
                                if (_checkNotEmpty() && _isFormatCostCorrect) {
                                  selectedItem!.name =
                                      nameTextFieldController.text;
                                  selectedItem!.area =
                                      areaTextFieldController.text == ''
                                          ? null
                                          : areaTextFieldController.text;
                                  selectedItem!.cost =
                                      int.parse(costTextFieldController.text);
                                  selectedItem!.textDefault =
                                      defaultTextFieldController.text;
                                  selectedItem!.imgDefault = imageDefault;
                                  selectedItem!.imgPath = imagePath;
                                  editedList.add(selectedItem!);
                                  setState(() {
                                    _isEditing = false;
                                    nameTextFieldController.clear();
                                    areaTextFieldController.clear();
                                    costTextFieldController.clear();
                                    defaultTextFieldController.clear();
                                    imagePath = null;
                                    imageDefault = null;
                                    selectedTileIndex = -1;
                                    groupedExam.sort(
                                        (a, b) => a.name.compareTo(b.name));
                                    nameDisplayList = groupedExam;
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
