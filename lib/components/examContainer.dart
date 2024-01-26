import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExamContainer extends StatefulWidget {
  String id;
  String round;
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
      required this.selectedArea,
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
    List<ExamContainer> examList = widget.round == "1"
        ? examProvider.examContainers1
        : examProvider.examContainers2;
    // bool isAreaNull = true;

    Map<String, List<ExamPreDefinedObject>> groupedByLab =
        groupBy(preDefinedExamAll, (e) => e.lab);

    Map<String, List<ExamPreDefinedObject>> groupedByType() {
      return groupBy(
          groupedByLab[widget.selectedDepartment]!.toList(), (e) => e.type);
    }

    void checkArea() {
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
      // print('isAreaNull = ${widget.areaNull}');
    }

    Future<void> pickImage() async {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        setState(() {
          // Set the image path for display
          widget.imageResult = result.files.first;
        });
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('เลือกแผนกการตรวจ'),
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
                          checkArea();
                          widget.selectedExamName =
                              groupedByType()[widget.selectedExamTopic]!
                                  .first
                                  .name;
                          widget.selectedArea =
                              groupedByType()[widget.selectedExamTopic]!
                                  .first
                                  .area;
                        });
                      }),
                ],
              ),
              IconButton(
                  onPressed: () {
                    examProvider.deleteExamContainer(examList, widget.key);
                  },
                  icon: Icon(Icons.remove)),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("เลือกหัวข้อการตรวจ"),
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedExamTopic,
                  // list: filterExam(widget.selectedDepartment),
                  list: groupedByType().keys.toList(),
                  hintText: "เลือกหัวข้อการตรวจ",
                  onChanged: (value) {
                    setState(() {
                      widget.selectedExamTopic = value.toString();
                      // print('topic = ${widget.selectedExamTopic}');
                      widget.selectedExamName =
                          groupedByType()[widget.selectedExamTopic]!.first.name;
                      widget.selectedArea =
                          groupedByType()[widget.selectedExamTopic]!.first.area;
                    });
                  }),
            ],
          ),
          SizedBox(height: 15),
          Visibility(
            visible: !widget.areaNull,
            child: widget.selectedArea != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("เลือกบริเวณส่งตรวจ"),
                      DropDownButtonInAddQ(
                          selectedValue: widget.selectedArea,
                          list: groupBy(
                              groupedByType()[widget.selectedExamTopic]!,
                              (e) => e.area!).keys.toList(),
                          hintText: "เลือกบริเวณส่งตรวจ",
                          onChanged: (value) {
                            setState(() {
                              widget.selectedArea = value.toString();
                            });
                          }),
                    ],
                  )
                : SizedBox(),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("เลือกการตรวจ"),
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedExamName,
                  list: groupedByType()[widget.selectedExamTopic]!
                      .map((e) => e.name)
                      .toList(),
                  hintText: "เลือกการตรวจ",
                  onChanged: (value) {
                    setState(() {
                      widget.selectedExamName = value.toString();
                    });
                  }),
            ],
          ),
          SizedBox(height: 10),
          TextBoxMultiLine(
            myController: widget.examController,
            hintText: "ผลการส่งตรวจ",
            titleText: "",
            maxLine: 2,
            boxColor: Color(0xFFE7F9FF),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: Text('เพิ่มรูป (Optional)'),
              ),
              SizedBox(width: 20),
              Visibility(
                visible: widget.imageResult != null,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // widget.imageResult = null;
                      widget.imagePath = null;
                    });
                  },
                  child: Text('ลบรูป'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B72BE),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          widget.imagePath != null
              // ? Image.memory(
              //     Uint8List.fromList(widget.imageResult!.bytes!),
              //     height: 200,
              //     width: 300,
              //     fit: BoxFit.cover,
              //   )
              ? Image.network(
                  "${dotenv.env['RESOURCE_PATH']}${widget.imagePath?.replaceFirst("upload/", "")}",
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover,
                )
              : Text('No Image Selected'),
        ],
      ),
    );
  }
}

class ShowExamContainer extends StatelessWidget {
  String department;
  String exam;
  String results;
  PlatformFile? imagePath;

  ShowExamContainer(
      {required this.department,
      required this.exam,
      required this.results,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'ประเภทการส่งตรวจ',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(width: 10),
                Text(department, style: kNormalTextStyle),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'หัวข้อการส่งตรวจ',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(width: 10),
                Text(exam, style: kNormalTextStyle),
              ],
            ),
          ),
          Container(
            height: 70,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            color: Color(0xFFE7F9FF),
            child: Text(results),
          ),
          SizedBox(height: 15),
          imagePath != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  // child: Image.network(
                  //   File(imagePath!),
                  //   // imagePath!,
                  //   height: 200,
                  //   width: 300,
                  //   fit: BoxFit.cover,
                  // ),
                  child: Image.memory(imagePath!.bytes!),
                )
              : Container(),
        ],
      ),
    );
  }
}
