import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/resultContainer.dart';
import 'package:frontend/screensNisit/examScreens/exam_total.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';

class ExamResult extends StatelessWidget {
  ExamPreDefinedObject selectedExam;
  int round;
  QuestionObject questionObj;
  ExamResultObject result;

  ExamResult(
      {super.key,
      required this.selectedExam,
      required this.round,
      required this.questionObj,
      required this.result});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: round == 1
            ? LeftPartContent(
                questionObj: questionObj,
                addedContent: TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 1',
                  showList: problemProvider.problemAnsList1
                      .map((e) => e.name)
                      .toList(),
                ),
              )
            : LeftPartContent(
                questionObj: questionObj,
                addedContent: Column(
                  children: [
                    TitleAndDottedListView(
                        title: 'Problem List ครั้งที่ 1',
                        showList: problemProvider.problemAnsList1
                            .map((e) => e.name)
                            .toList()),
                    TitleAndExams(
                      title: 'Examination ครั้งที่ 1',
                      showList: examProvider.examList,
                      resultList: examProvider.resultList,
                    ),
                    TitleAndDottedListView(
                        title: 'Problem List ครั้งที่ 2',
                        showList: problemProvider.problemAnsList2
                            .map((e) => e.name)
                            .toList()),
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
                        examProvider.addNewResult(
                            ResultContainer(
                                result: result, selectedExam: selectedExam),
                            round);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamTotal(
                              round: round,
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
