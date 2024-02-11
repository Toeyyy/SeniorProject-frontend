import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefinedListDetail.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_topics.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_topic.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';

class EditPredefinedListTopic extends StatelessWidget {
  const EditPredefinedListTopic({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> editPredefinedTopicList = [
      'Problem List',
      'Diagnosis List',
      'Treatment List',
      'Examination List',
    ];

    Future<void> getTreatment() async {
      await fetchPreDefinedTreatment();
    }

    Future<void> getExams() async {
      await fetchPreDefinedExam();
    }

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
                  'Edit Predefined List',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: editPredefinedTopicList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(
                          editPredefinedTopicList[index],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          if (editPredefinedTopicList[index] ==
                              'Examination List') {
                            getExams();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPreDefinedExam2Topic(),
                              ),
                            );
                          } else if (editPredefinedTopicList[index] ==
                              'Treatment List') {
                            getTreatment();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPredefinedTreatmentType(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPredefinedListDetail(
                                    title: editPredefinedTopicList[index]),
                              ),
                            );
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 8,
                    ),
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
