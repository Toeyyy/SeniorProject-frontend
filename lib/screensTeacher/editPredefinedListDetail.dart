import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';

class EditPredefinedListDetail extends StatefulWidget {
  final String title;

  EditPredefinedListDetail({required this.title});

  @override
  State<EditPredefinedListDetail> createState() =>
      _EditPredefinedListDetailState();
}

class _EditPredefinedListDetailState extends State<EditPredefinedListDetail> {
  TextEditingController textFieldController = TextEditingController();
  late List<String> fullList = filterEditList(widget.title);
  late List<String> displayList = filterEditList(widget.title);
  int selectedTileIndex = -1;
  bool isEditing = false;
  String? oldItem;
  String? newItem;

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
                  widget.title,
                  style: kSubHeaderTextStyle,
                ),
                SizedBox(height: 20),
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
                    border: OutlineInputBorder(),
                    suffixIcon: !isEditing
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                fullList.add(textFieldController.text);
                                textFieldController.clear();
                                displayList = fullList;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                newItem = textFieldController.text;
                                fullList.remove(oldItem);
                                fullList.add(newItem!);
                                isEditing = false;
                                textFieldController.clear();
                                selectedTileIndex = -1;
                                fullList.sort();
                                displayList = fullList;
                              });
                            }),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFF2F5F7),
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFB5C1BE), width: 1.0),
                          ),
                          child: ListTile(
                            tileColor: index == selectedTileIndex
                                ? Color(0xFFA0E9FF)
                                : Color(0xFFE7F9FF),
                            hoverColor: Color(0xFFA0E9FF),
                            trailing: index == selectedTileIndex
                                ? Icon(Icons.check)
                                : null,
                            title: Text(displayList[index]),
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
                SizedBox(height: 10),
                Visibility(
                  visible: selectedTileIndex == -1 ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            textFieldController.text =
                                displayList[selectedTileIndex];
                            setState(() {
                              oldItem = displayList[selectedTileIndex];
                              isEditing = true;
                            });
                          },
                          child: Text('แก้ไข'),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              fullList.remove(displayList[selectedTileIndex]);
                              // fullList.removeAt(selectedTileIndex);
                              textFieldController.clear();
                              selectedTileIndex = -1;
                              fullList.sort();
                              displayList = fullList;
                            });
                          },
                          child: Text('ลบ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B72BE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('กลับ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8B72BE),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
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
