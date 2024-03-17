import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_choice.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_choice.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_choice.dart';
import 'package:go_router/go_router.dart';

class EditPredefinedInit extends StatefulWidget {
  const EditPredefinedInit({super.key});

  @override
  State<EditPredefinedInit> createState() => _EditPredefinedInitState();
}

class _EditPredefinedInitState extends State<EditPredefinedInit> {
  bool _isLoadData = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoadData = true;
    });
    fetchPreDefined();
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadData
        ? const Center(
            child: SizedBox(width: 30, child: CircularProgressIndicator()))
        : const EditPredefinedListTopic();
  }
}

class EditPredefinedListTopic extends StatelessWidget {
  const EditPredefinedListTopic({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> editPredefinedTopicList = [
      'Problem',
      'Differential Diagnosis',
      'Tentative/Definitive Diagnosis',
      'Treatment',
      'Examination',
      'Tag',
    ];

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
                          if (editPredefinedTopicList[index] == 'Examination') {
                            context.go('/questionMenu/editPredefined/exam');
                          } else if (editPredefinedTopicList[index] ==
                              'Treatment') {
                            context
                                .go('/questionMenu/editPredefined/treatment');
                          } else {
                            String myTitle = '';
                            if (editPredefinedTopicList[index] ==
                                'Differential Diagnosis') {
                              myTitle = 'Differential';
                            } else if (editPredefinedTopicList[index] ==
                                'Tentative/Definitive Diagnosis') {
                              myTitle = 'TentativeAndDefinitive';
                            } else {
                              myTitle = editPredefinedTopicList[index];
                            }
                            context.goNamed(
                              'editPredefinedOther',
                              pathParameters: {
                                'title': myTitle,
                              },
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
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B72BE),
                  ),
                  child: const Text(
                    'ยกเลิก',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
