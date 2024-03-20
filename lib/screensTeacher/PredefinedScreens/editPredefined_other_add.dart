import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/back_button.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditPreDefinedOtherAdd extends StatefulWidget {
  String title;
  EditPreDefinedOtherAdd({super.key, required this.title});

  @override
  State<EditPreDefinedOtherAdd> createState() => _EditPreDefinedOtherAddState();
}

class _EditPreDefinedOtherAddState extends State<EditPreDefinedOtherAdd> {
  TextEditingController textFieldController = TextEditingController();
  late List<dynamic> fullList = filterEditTopicList(widget.title);
  late List<dynamic> displayList = filterEditTopicList(widget.title);
  List<dynamic> addedList = [];

  Future<void> _postAddData(String title) async {
    var data = addedList.map((item) {
      return {"name": item.name};
    }).toList();
    try {
      if (title == 'Problem') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/problem"),
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
      } else if (title == 'Differential Diagnosis' ||
          title == 'Tentative/Definitive Diagnosis') {
        data = addedList.map((item) {
          return {"type": item.type, "name": item.name};
        }).toList();
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/diagnostic"),
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
      } else if (title == 'Tag') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/tag"),
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
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  'เพิ่ม ${widget.title}',
                  style: kSubHeaderTextStyle,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      displayList = filterList(textFieldController, fullList);
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (textFieldController.text != '') {
                          if (widget.title == 'Problem') {
                            ProblemObject newItem = ProblemObject(
                                id: 'X', name: textFieldController.text);
                            fullList.add(newItem);
                            addedList.add(newItem);
                          } else if (widget.title ==
                              'Tentative/Definitive Diagnosis') {
                            DiagnosisObject newItem = DiagnosisObject(
                                id: 'X',
                                type: "tentative",
                                name: textFieldController.text);
                            fullList.add(newItem);
                            addedList.add(newItem);
                          } else if (widget.title == 'Differential Diagnosis') {
                            DiagnosisObject newItem = DiagnosisObject(
                                id: 'X',
                                type: "differential",
                                name: textFieldController.text);
                            fullList.add(newItem);
                            addedList.add(newItem);
                          } else if (widget.title == 'Tag') {
                            TagObject newItem = TagObject(
                                id: 'X', name: textFieldController.text);
                            fullList.add(newItem);
                            addedList.add(newItem);
                          }
                          textFieldController.clear();
                          setState(() {
                            displayList = fullList;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
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
                              hoverColor: const Color(0xFFA0E9FF),
                              title: Text(displayList[index].name),
                              onTap: () {
                                setState(() {
                                  textFieldController.text =
                                      displayList[index].name;
                                });
                              },
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyPopButton(myContext: context),
                    ElevatedButton(
                      onPressed: () async {
                        await _postAddData(widget.title).then((value) {
                          context.pop();
                        });
                      },
                      child: const Text('บันทึก'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
