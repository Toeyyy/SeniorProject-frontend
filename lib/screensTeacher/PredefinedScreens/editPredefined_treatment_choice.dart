import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_add.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_topics.dart';

class EditPreDefinedTreatmentChoice extends StatelessWidget {
  EditPreDefinedTreatmentChoice({super.key});

  final List<String> _topicList = [
    'เพิ่ม',
    'แก้ไข/ลบ',
  ];

  Future<void> getData() async {
    await fetchPreDefinedTreatment();
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
                  'Treatment List',
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
                            await getData().then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPreDefinedTreatmentAdd(),
                                ),
                              );
                            });
                          } else if (_topicList[index] == 'แก้ไข/ลบ') {
                            await getData().then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPredefinedTreatmentType(),
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
