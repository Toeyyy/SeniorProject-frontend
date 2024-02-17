import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/backButton.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditPreDefinedOtherAdd extends StatefulWidget {
  String title;
  EditPreDefinedOtherAdd({required this.title});

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
      if (title == 'Problem List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/problem/add"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else if (title == 'Diagnosis List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/diagnostic/add"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else if (title == 'Tag List') {
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/tag/add"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
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
                          if (widget.title == 'Problem List') {
                            ProblemObject newItem = ProblemObject(
                                id: 'X', name: textFieldController.text);
                            fullList.add(newItem);
                            addedList.add(newItem);
                          } else if (widget.title == 'Diagnosis List') {
                            DiagnosisObject newItem = DiagnosisObject(
                                id: 'X', name: textFieldController.text);
                            fullList.add(newItem);
                            addedList.add(newItem);
                          } else if (widget.title == 'Tag List') {
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
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: displayList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFB5C1BE), width: 1.0),
                            ),
                            child: ListTile(
                              hoverColor: Color(0xFFA0E9FF),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyBackButton(myContext: context),
                    ElevatedButton(
                      onPressed: () async {
                        await _postAddData(widget.title).then((value) {
                          Navigator.pop(context);
                        });
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
    );
  }
}
