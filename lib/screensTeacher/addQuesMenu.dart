import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensTeacher/addQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefinedListTopic.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddQuesMenu extends StatelessWidget {
  AddQuesMenu({super.key});

  FilePickerResult? userFile;

  Future<void> fetchPreDefined() async {
    await fetchPreDefinedProb();
    await fetchPreDefinedDiag();
    await fetchPreDefinedExam();
    await fetchPreDefinedTag();
    await fetchPreDefinedTreatment();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> postFile() async {
      final dio = Dio();
      var formData = FormData.fromMap({"file": userFile!.files});
      try {
        final response = await dio
            .post("${dotenv.env['API_PATH']}/question/upload", data: formData);
      } catch (error) {
        print('Error: $error');
      }
    }

    Future<void> getFile() async {
      try {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/question/template"),
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
        } else {
          print("Error: ${response.statusCode} - ${response.body}");
        }
      } catch (error) {
        print("Error: $error");
      }
    }

    void importFileModal(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.minPositive,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBF5FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['xlsx']);
                              if (result != null) {
                                setState(() {
                                  userFile = result;
                                });
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.attach_file),
                                Text('Upload .xlsx File'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      userFile != null
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFFE7F9FF),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      userFile!.names.first!,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        userFile = null;
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            )
                          : const Text('No File Selected',
                              textAlign: TextAlign.left),
                      userFile != null
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await postFile().then((value) {
                                    userFile = null;
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text('ยืนยัน'),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            });
          });
    }

    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'เพิ่มโจทย์',
                style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
              ),
              ElevatedButton(
                onPressed: () async {
                  await getFile();
                },
                child: const Text(
                  'Download Template',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  importFileModal(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DABF5),
                  textStyle: const TextStyle(fontSize: 30),
                ),
                child: const Text('แนบไฟล์ .xlsx'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchPreDefined().then((value) => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddQuestion()))
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B72BE),
                  textStyle: const TextStyle(fontSize: 30),
                ),
                child: const Text('กรอกโจทย์โดยตรง'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchPreDefined().then((value) => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditPredefinedListTopic()))
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF694873),
                  textStyle: const TextStyle(fontSize: 30),
                ),
                child: const Text('แก้ไข Predefined List'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
