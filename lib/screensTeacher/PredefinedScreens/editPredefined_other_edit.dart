import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/components/back_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/my_secure_storage.dart';

class EditPredefinedOtherEdit extends StatefulWidget {
  final String title;

  const EditPredefinedOtherEdit({super.key, required this.title});

  @override
  State<EditPredefinedOtherEdit> createState() =>
      _EditPredefinedOtherEditState();
}

class _EditPredefinedOtherEditState extends State<EditPredefinedOtherEdit> {
  TextEditingController textFieldController = TextEditingController();
  late List<dynamic> fullList = filterEditTopicList(widget.title);
  late List<dynamic> displayList = filterEditTopicList(widget.title);
  int selectedTileIndex = -1;
  bool isEditing = false;
  String? oldItem;
  String? oldItemID;
  String? newItem;
  List<dynamic> deletedList = [];
  List<dynamic> editedList = [];
  bool _isLoadData = true;

  Future<void> _postDeleteData(String title) async {
    if (deletedList.isNotEmpty) {
      var data = deletedList.map((item) {
        return {"id": item.id};
      }).toList();
      try {
        if (title == 'Problem') {
          final http.Response response = await http.delete(
            Uri.parse("${dotenv.env['API_PATH']}/problem"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
            },
            body: jsonEncode(data),
          );
        } else if (title == 'Differential Diagnosis' ||
            title == 'Tentative/Definitive Diagnosis') {
          final http.Response response = await http.delete(
            Uri.parse("${dotenv.env['API_PATH']}/diagnostic"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
            },
            body: jsonEncode(data),
          );
        } else if (title == 'Tag') {
          final http.Response response = await http.delete(
            Uri.parse("${dotenv.env['API_PATH']}/tag"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
            },
            body: jsonEncode(data),
          );
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  }

  Future<void> _postEditData(String title) async {
    if (editedList.isNotEmpty) {
      var data = editedList.map((item) {
        return {"id": item.id, "name": item.name};
      }).toList();
      try {
        if (title == 'Problem') {
          final http.Response response = await http.put(
            Uri.parse("${dotenv.env['API_PATH']}/problem"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
            },
            body: jsonEncode(data),
          );
        } else if (title == 'Diagnosis List') {
          final http.Response response = await http.put(
            Uri.parse("${dotenv.env['API_PATH']}/diagnostic"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
            },
            body: jsonEncode(data),
          );
        } else if (title == 'Tag') {
          print('in case tag');
          final http.Response response = await http.put(
            Uri.parse("${dotenv.env['API_PATH']}/tag"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
            },
            body: jsonEncode(data),
          );
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  }

  List<dynamic> filterNameList(
      TextEditingController searchController, List<dynamic> listForSearch) {
    if (selectedTileIndex == -1) {
      String query = searchController.text.toLowerCase();
      return listForSearch
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    } else {
      return listForSearch;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoadData = true;
    });
    getProbDiagTag(widget.title);
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoadData
        ? Scaffold(
            appBar: const AppbarTeacher(),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      Text(
                        'แก้ไข/ลบ ${widget.title}',
                        style: kSubHeaderTextStyle,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: textFieldController,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          setState(() {
                            displayList =
                                filterNameList(textFieldController, fullList);
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          suffixIcon: !isEditing
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.save),
                                  onPressed: () {
                                    setState(() {
                                      newItem = textFieldController.text;
                                      for (var item in fullList) {
                                        if (item.id == oldItemID) {
                                          editedList.add(item);
                                          item.name = newItem;
                                        }
                                      }
                                      isEditing = false;
                                      textFieldController.clear();
                                      selectedTileIndex = -1;
                                      fullList.sort(
                                          (a, b) => a.name.compareTo(b.name));
                                      displayList = fullList;
                                    });
                                  }),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: const Color(0xFFF2F5F7),
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            itemCount: displayList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFB5C1BE),
                                      width: 1.0),
                                ),
                                child: ListTile(
                                  tileColor: index == selectedTileIndex
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
                                              onPressed: () {
                                                textFieldController.text =
                                                    displayList[
                                                            selectedTileIndex]
                                                        .name;
                                                setState(() {
                                                  oldItem = displayList[
                                                          selectedTileIndex]
                                                      .name;
                                                  oldItemID = displayList[
                                                          selectedTileIndex]
                                                      .id;
                                                  isEditing = true;
                                                });
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  deletedList.add(displayList[
                                                      selectedTileIndex]);
                                                  fullList.remove(displayList[
                                                      selectedTileIndex]);
                                                  fullList.sort((a, b) =>
                                                      a.name.compareTo(b.name));
                                                  displayList = fullList;
                                                  textFieldController.clear();
                                                  selectedTileIndex = -1;
                                                });
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.delete),
                                            ),
                                          ],
                                        )
                                      : null,
                                  title: Text(displayList[index].name),
                                  onTap: () {
                                    setState(() {
                                      if ((selectedTileIndex != -1) &
                                          (selectedTileIndex == index)) {
                                        selectedTileIndex = -1;
                                        isEditing = false;
                                      } else {
                                        selectedTileIndex = index;
                                        isEditing = false;
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyPopButton(myContext: context),
                          ElevatedButton(
                            onPressed: () async {
                              await _postEditData(widget.title);
                              await _postDeleteData(widget.title).then(
                                (value) => context.pop(),
                              );
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
          )
        : const Center(
            child: SizedBox(width: 30, child: CircularProgressIndicator()));
  }
}
