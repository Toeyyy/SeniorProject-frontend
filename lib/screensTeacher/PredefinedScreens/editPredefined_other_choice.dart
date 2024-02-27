import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_add.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_edit.dart';

class EditPreDefinedOtherChoice extends StatelessWidget {
  final String title;
  EditPreDefinedOtherChoice({super.key, required this.title});

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
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
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
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: const Color(0xFFA0E9FF),
                        hoverColor: const Color(0xFF42C2FF),
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
