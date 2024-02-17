import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_add.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_edit.dart';

class EditPreDefinedOtherChoice extends StatelessWidget {
  String title;
  EditPreDefinedOtherChoice({required this.title});

  final List<String> _topicList = [
    'เพิ่ม',
    'แก้ไข/ลบ',
  ];

  Future<void> getData(String title) async {
    if (title == 'Problem List') {
      await fetchPreDefinedProb();
    } else if (title == 'Diagnosis List') {
      await fetchPreDefinedDiag();
    } else {
      await fetchPreDefinedTag();
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
                  title,
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(
                          _topicList[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () async {
                          if (_topicList[index] == 'เพิ่ม') {
                            await getData(title).then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPreDefinedOtherAdd(title: title),
                                ),
                              );
                            });
                          } else if (_topicList[index] == 'แก้ไข/ลบ') {
                            await getData(title).then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPredefinedOtherEdit(title: title),
                                ),
                              );
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
                MyBackButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
