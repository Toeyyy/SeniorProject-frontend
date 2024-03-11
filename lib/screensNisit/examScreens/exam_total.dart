import 'package:flutter/material.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/screensNisit/examScreens/exam_topics.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/resultContainer.dart';
import 'package:frontend/screensNisit/problemList.dart';
import 'package:frontend/screensNisit/tenDiag.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';

class ExamTotal extends StatelessWidget {
  // QuestionObject questionObj;

  ExamTotal({super.key});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);
    List<ResultContainer> resultList = examProvider.getResultList();
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(
          questionObj: currentQuestion!,
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
                              builder: (context) => ExamTopic(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B72BE),
                        ),
                        child: const Text('เลือกตรวจเพิ่ม'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //go to prob list 2
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProbList(
                                round: 2,
                              ),
                            ),
                          );
                        },
                        child: const Text('เลือก Problem List ครั้งที่ 2'),
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
