import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_choice.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_choice.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_choice.dart';

class EditPredefinedListTopic extends StatelessWidget {
  const EditPredefinedListTopic({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> editPredefinedTopicList = [
      'Problem List',
      'Diagnosis List',
      'Treatment List',
      'Examination List',
      'Tag List',
    ];

    Future<void> getTreatment() async {
      await fetchPreDefinedTreatment();
    }

    Future<void> getExams() async {
      await fetchPreDefinedExam();
    }

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
                  'Edit Predefined List',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: editPredefinedTopicList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: const Color(0xFFA0E9FF),
                        hoverColor: const Color(0xFF42C2FF),
                        title: Text(
                          editPredefinedTopicList[index],
                          style: const TextStyle(
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
                                    EditPreDefinedExamChoice(),
                              ),
                            );
                          } else if (editPredefinedTopicList[index] ==
                              'Treatment List') {
                            getTreatment();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPreDefinedTreatmentChoice(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPreDefinedOtherChoice(
                                    title: editPredefinedTopicList[index]),
                              ),
                            );
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
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
