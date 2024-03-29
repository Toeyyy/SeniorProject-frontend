import 'package:flutter/material.dart';
import 'package:frontend/components/split_screen_nisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:collection/collection.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/screensNisit/examScreens/exam_details.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';

class ExamTopic extends StatelessWidget {
  final QuestionObject questionObj;

  const ExamTopic({super.key, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(
          questionObj: questionObj,
          addedContent: Column(
            children: [
              TitleAndDottedListView(
                title: 'Problem List ครั้งที่ 1',
                showList:
                    problemProvider.problemAnsList1.map((e) => e.name).toList(),
              ),
              TitleAndDottedListView(
                  title: 'Differential Diagnosis',
                  showList:
                      diagProvider.diffDiagList.map((e) => e.name).toList()),
            ],
          ),
        ),
        rightPart: RightPartExamTopic(
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPartExamTopic extends StatelessWidget {
  final QuestionObject questionObj;

  RightPartExamTopic({super.key, required this.questionObj});

  final Map<String, List<ExamPreDefinedObject>> groupedByLab =
      groupBy(examListPreDefined, (e) => e.lab);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          const Text('เลือกแผนกการตรวจ', style: kSubHeaderTextStyle),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: groupedByLab.keys.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: const Color(0xFFA0E9FF),
                  hoverColor: const Color(0xFF42C2FF),
                  title: Text(groupedByLab.keys.toList()[index]),
                  onTap: () {
                    String labName = groupedByLab.keys.toList()[index];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamDetailType(
                          list: groupedByLab[labName]!,
                          title: labName,
                          questionObj: questionObj,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
