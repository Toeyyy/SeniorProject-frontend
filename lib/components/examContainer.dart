import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';

class ExamContainer extends StatefulWidget {
  String id;
  int round;
  Key key;
  String selectedExamTopic;
  String selectedDepartment;
  String selectedExamName;
  String? selectedArea;
  bool areaNull;
  String? imagePath;
  PlatformFile? imageResult;
  TextEditingController examController;
  bool haveImage;

  ExamContainer(
      {required this.id,
      required this.key,
      required this.round,
      required this.selectedDepartment,
      required this.selectedExamTopic,
      required this.selectedExamName,
      this.selectedArea,
      required this.areaNull,
      required this.examController,
      required this.imagePath,
      required this.imageResult,
      required this.haveImage});

  @override
  State<ExamContainer> createState() => _ExamContainerState();
}

class _ExamContainerState extends State<ExamContainer> {
  @override
  Widget build(BuildContext context) {
    ExamContainerProvider examProvider =
        Provider.of<ExamContainerProvider>(context);
    List<ExamContainer> examList = widget.round == 1
        ? examProvider.examContainers1
        : examProvider.examContainers2;
    Map<String, List<ExamPreDefinedObject>> groupedByLab =
        groupBy(examListPreDefined, (e) => e.lab);

    Map<String, List<ExamPreDefinedObject>> groupedByType() {
      return groupBy(
          groupedByLab[widget.selectedDepartment]!.toList(), (e) => e.type);
    }

    Map<String, List<ExamPreDefinedObject>> groupedByName() {
      return groupBy(
          groupedByType()[widget.selectedExamTopic]!.toList(), (e) => e.name);
    }

    void checkArea(String choice) {
      if (choice == 'type') {
        List<ExamPreDefinedObject> groupedType =
            groupedByType()[widget.selectedExamTopic]!;
        setState(() {
          widget.areaNull = true;
        });
        for (ExamPreDefinedObject item in groupedType) {
          if (item.area != null) {
            setState(() {
              widget.areaNull = false;
            });
            break;
          }
        }
      } else if (choice == 'name') {
        List<ExamPreDefinedObject> groupedName =
            groupedByName()[widget.selectedExamName]!;
        setState(() {
          widget.areaNull = true;
        });
        for (ExamPreDefinedObject item in groupedName) {
          if (item.area != null) {
            setState(() {
              widget.areaNull = false;
            });
            break;
          }
        }
      }
    }

    Future<void> pickImage() async {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        setState(() {
          // Set the image path for display
          widget.imageResult = result.files.first;
          widget.imagePath = null;
        });
      }
    }

    Widget displayImage() {
      if (widget.imagePath != null && widget.imageResult == null) {
        return Image.network(
          "${dotenv.env['RESOURCE_PATH']}${widget.imagePath!.replaceFirst("upload/", "")}",
          height: 200,
          width: 300,
          fit: BoxFit.cover,
        );
      } else if (widget.imageResult != null) {
        return Image.memory(
          Uint8List.fromList(widget.imageResult!.bytes!),
          height: 200,
          width: 300,
          fit: BoxFit.cover,
        );
      } else {
        return const Text('No Image Selected');
      }
    }

    String findExamId() {
      return examListPreDefined
          .where((item) {
            return widget.selectedDepartment == item.lab &&
                widget.selectedExamTopic == item.type &&
                widget.selectedArea == item.area &&
                widget.selectedExamName == item.name;
          })
          .toList()
          .first
          .id;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('เลือกแผนกการตรวจ'),
                  DropDownButtonInAddQ(
                      selectedValue: widget.selectedDepartment,
                      list: groupedByLab.keys.toList(),
                      hintText: "เลือกแผนกการตรวจ",
                      onChanged: (value) {
                        setState(() {
                          widget.selectedDepartment = value.toString();
                          List<ExamPreDefinedObject>? newList =
                              groupedByLab[widget.selectedDepartment];
                          widget.selectedExamTopic = newList!.first.type;
                          checkArea('type');
                          widget.selectedExamName =
                              groupedByType()[widget.selectedExamTopic]!
                                  .first
                                  .name;
                          if (!widget.areaNull) {
                            widget.selectedArea =
                                groupedByType()[widget.selectedExamTopic]!
                                    .first
                                    .area;
                          }
                          widget.id = findExamId();
                        });
                      }),
                ],
              ),
              IconButton(
                  onPressed: () {
                    examProvider.deleteExamContainer(examList, widget.key);
                  },
                  icon: const Icon(Icons.remove)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("เลือกหัวข้อการตรวจ"),
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedExamTopic,
                  list: groupedByType().keys.toList(),
                  hintText: "เลือกหัวข้อการตรวจ",
                  onChanged: (value) {
                    setState(() {
                      widget.selectedExamTopic = value.toString();
                      widget.selectedExamName =
                          groupedByType()[widget.selectedExamTopic]!.first.name;
                      if (groupedByType()[widget.selectedExamTopic] != null) {
                        widget.selectedArea =
                            groupedByType()[widget.selectedExamTopic]!
                                .first
                                .area;
                      }
                      widget.id = findExamId();
                    });
                  }),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("เลือกการตรวจ"),
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedExamName,
                  list: groupedByType()[widget.selectedExamTopic]!
                      .map((e) => e.name)
                      .toSet()
                      .toList(),
                  hintText: "เลือกการตรวจ",
                  onChanged: (value) {
                    setState(() {
                      widget.selectedExamName = value.toString();
                      checkArea('name');
                      widget.selectedArea =
                          groupedByName()[widget.selectedExamName]!.first.area;
                      widget.id = findExamId();
                    });
                  }),
            ],
          ),
          const SizedBox(height: 15),
          Visibility(
            visible: !widget.areaNull,
            child: widget.selectedArea != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("เลือกตัวอย่างการส่งตรวจ"),
                      DropDownButtonInAddQ(
                          selectedValue: widget.areaNull == false
                              ? widget.selectedArea
                              : null,
                          list: widget.areaNull == false
                              ? groupBy(
                                  groupedByName()[widget.selectedExamName]!,
                                  (e) => e.area!).keys.toList()
                              : [],
                          hintText: "เลือกตัวอย่างการส่งตรวจ",
                          onChanged: (value) {
                            setState(() {
                              widget.selectedArea = value.toString();
                              widget.id = findExamId();
                            });
                          }),
                    ],
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 10),
          TextBoxMultiLine(
            myController: widget.examController,
            hintText: "ผลการส่งตรวจ",
            titleText: "",
            maxLine: 2,
            boxColor: const Color(0xFFE7F9FF),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('เพิ่มรูป (Optional)'),
              ),
              const SizedBox(width: 20),
              Visibility(
                visible: widget.imagePath != null || widget.imageResult != null,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.imageResult = null;
                      widget.imagePath = null;
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
          const SizedBox(height: 15),
          displayImage(),
        ],
      ),
    );
  }
}

class ShowExamContainer extends StatelessWidget {
  String lab;
  String type;
  String? area;
  String name;
  String? results;
  String? imagePath;

  ShowExamContainer(
      {super.key,
      required this.lab,
      required this.type,
      required this.area,
      required this.name,
      this.results,
      this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'แผนกการตรวจ',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 10),
                Text(lab, style: kNormalTextStyle),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'หัวข้อการส่งตรวจ',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 10),
                Text(type, style: kNormalTextStyle),
              ],
            ),
          ),
          area != null
              ? Container(
                  padding: const EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        'ตัวอย่างการส่งตรวจ',
                        style: kNormalTextStyle.copyWith(
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 10),
                      Text(area!, style: kNormalTextStyle),
                    ],
                  ),
                )
              : Container(),
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'ชื่อการส่งตรวจ',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 10),
                Text(name, style: kNormalTextStyle),
              ],
            ),
          ),
          results != null
              ? Container(
                  height: 70,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFE7F9FF),
                  child: Text(results!),
                )
              : Container(),
          imagePath != null
              ? Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.network(
                          "${dotenv.env['RESOURCE_PATH']}${imagePath!.replaceFirst("upload/", "")}",
                          height: 200,
                          width: 300,
                          fit: BoxFit.cover,
                        )
                        // child: Image.memory(imagePath!.bytes!),
                        ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
