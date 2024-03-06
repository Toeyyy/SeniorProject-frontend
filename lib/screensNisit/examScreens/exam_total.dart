import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/screensNisit/examScreens/exam_topics.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/resultContainer.dart';
import 'package:frontend/screensNisit/problemList.dart';
import 'package:frontend/screensNisit/diagnosis.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';

class ExamTotal extends StatelessWidget {
  int round;
  QuestionObject questionObj;

  ExamTotal({super.key, required this.round, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);
    List<ResultContainer> resultList = examProvider.getResultList(round);
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
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child:
                          Text('ผลการตรวจทั้งหมด', style: kSubHeaderTextStyle)),
                  DividerWithSpace(),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: resultList.length,
                    itemBuilder: (context, index) {
                      return resultList[index];
                    }),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const DividerWithSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamTopic(
                                  round: round, questionObj: questionObj),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B72BE),
                        ),
                        child: const Text('เลือกตรวจเพิ่ม'),
                      ),
                      round == 1
                          ? ElevatedButton(
                              onPressed: () {
                                //go to prob list 2
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProbList(
                                      round: 2,
                                      questionObj: questionObj,
                                    ),
                                  ),
                                );
                              },
                              child:
                                  const Text('เลือก Problem List ครั้งที่ 2'),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                //go to diag
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Diagnosis(
                                      questionObj: questionObj,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('วินิจฉัย'),
                            ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
