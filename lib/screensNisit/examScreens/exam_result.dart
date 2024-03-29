import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/models/exam_result_object.dart';
import 'package:frontend/components/split_screen_nisit.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/result_container.dart';
import 'package:frontend/screensNisit/examScreens/exam_total.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';

class ExamResult extends StatelessWidget {
  ExamPreDefinedObject selectedExam;
  ExamResultObject result;
  QuestionObject questionObj;

  ExamResult(
      {super.key,
      required this.selectedExam,
      required this.result,
      required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);
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
                  showList: problemProvider.problemAnsList1
                      .map((e) => e.name)
                      .toList()),
              TitleAndDottedListView(
                  title: 'Differential Diagnosis',
                  showList:
                      diagProvider.diffDiagList.map((e) => e.name).toList()),
            ],
          ),
        ),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: result != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                            child:
                                Text('ผลการตรวจ', style: kSubHeaderTextStyle)),
                        const DividerWithSpace(),
                        ResultContainer(
                            result: result, selectedExam: selectedExam),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        examProvider.addNewResult(ResultContainer(
                            result: result, selectedExam: selectedExam));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamTotal(
                              questionObj: questionObj,
                            ),
                          ),
                        );
                      },
                      child: const Text('ผลการตรวจทั้งหมด'),
                    ),
                  ],
                )
              : const SizedBox(
                  width: 10, child: Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}
