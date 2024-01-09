import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/UIModels/examContainer_provider.dart';
import 'package:provider/provider.dart';
import '../tmpQuestion.dart';
import 'package:frontend/components/functions.dart';

class ExamContainer extends StatefulWidget {
  int id;
  String round;
  Key key;
  String selectedExamTopic;
  String selectedDepartment;
  PlatformFile? imageFile;
  TextEditingController examController;
  bool haveImage;

  ExamContainer(
      {required this.id,
      required this.key,
      required this.round,
      required this.selectedDepartment,
      required this.selectedExamTopic,
      required this.examController,
      required this.imageFile,
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

    Future<void> pickImage() async {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        setState(() {
          // Set the image path for display
          widget.imageFile = result.files.first;
          // final imageBytes = result.files.first.bytes;
        });
      }
    }

    // void printImageTmp() {
    //   print(widget.imageFile?.path?.split('/'));
    // }

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
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedDepartment,
                  list: departmentList,
                  onChanged: (value) {
                    setState(() {
                      widget.selectedDepartment = value.toString();
                      widget.selectedExamTopic =
                          filterExam(widget.selectedDepartment).first;
                    });
                  }),
              IconButton(
                  onPressed: () {
                    examProvider.deleteExamContainer(
                        widget.id, examList, widget.key);
                  },
                  icon: Icon(Icons.remove)),
            ],
          ),
          SizedBox(height: 15),
          DropDownButtonInAddQ(
              selectedValue: widget.selectedExamTopic,
              list: filterExam(widget.selectedDepartment),
              onChanged: (value) {
                setState(() {
                  widget.selectedExamTopic = value.toString();
                });
              }),
          SizedBox(height: 10),
          TextBoxMultiLine(
            myController: widget.examController,
            hintText: "ผลการส่งตรวจ",
            titleText: "",
            maxLine: 2,
            boxColor: Color(0xFFE7F9FF),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: pickImage,
            child: Text('เพิ่มรูป (Optional)'),
          ),
          SizedBox(
            height: 15,
          ),
          widget.imageFile != null
              ? Image.memory(
                  Uint8List.fromList(widget.imageFile!.bytes!),
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover,
                )
              : Text('No Image Selected'),
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       printImageTmp();
          //     });
          //   },
          //   child: Text('Print path'),
          // ),
        ],
      ),
    );
  }
}

class ShowExamContainer extends StatelessWidget {
  // PlatformFile? imagePath =
  //     'https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg'
  //         as PlatformFile;

  String department;
  String exam;
  String results;
  String imagePath;

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
            child: Text(
              'exam result nafdflksfsjfkljglsjdfg',
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.network(
              imagePath,
              height: 200,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
