import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/screensNisit/diffDiag.dart';
import 'package:frontend/screensNisit/tenDiag.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/AllDataFile.dart';

class ProbListAns extends StatelessWidget {
  QuestionObject questionObj;
  int round;

  ProbListAns({super.key, required this.questionObj, required this.round});

  ListView showAnsProbList(
      List<ProblemObject> ansList, List<ProblemObject> actualList) {
    List<bool> checkList = [];
    for (ProblemObject item in actualList) {
      if (ansList.map((e) => e.name).toList().contains(item.name)) {
        checkList.add(true);
      } else {
        checkList.add(false);
      }
    }
    return ListView.builder(
      itemCount: actualList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            actualList[index].name,
            style: TextStyle(
              color: checkList[index]
                  ? const Color(0xFF42C2FF)
                  : const Color(0xFF16302B),
            ),
          ),
          trailing: checkList[index]
              ? const Icon(
                  Icons.check,
                  color: Color(0xFF42C2FF),
                )
              : const Icon(
                  Icons.close,
                  color: Color(0xFF16302B),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);
    // SelectedQuestion questionProvider = Provider.of(context, listen: false);

    List<ProblemObject> correctProblem = round == 1
        ? problemProvider.problemAnsList1
        : problemProvider.problemAnsList2;
    List<ProblemObject> userProblem = round == 1
        ? problemProvider.problemList1
        : problemProvider.problemList2;

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: round == 1
            ? LeftPartContent(questionObj: questionObj)
            : LeftPartContent(
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
                        showList: diagProvider.diffDiagList
                            .map((e) => e.name)
                            .toList()),
                    TitleAndExams(
                      title: 'Examination',
                      showList: examProvider.examList,
                      resultList: examProvider.resultList,
                    ),
                  ],
                ),
              ),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              const Text(
                'Correct Problem List',
                style: kHeaderTextStyle,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: correctProblem.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(correctProblem[index].name),
                      leading: const Icon(
                        Icons.circle,
                        size: 15,
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'Your Problem List',
                style: kHeaderTextStyle,
              ),
              Expanded(
                child: showAnsProbList(correctProblem, userProblem),
              ),
              round == 1
                  ? ElevatedButton(
                      onPressed: () {
                        //go to diff diag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiffDiag(
                              questionObj: questionObj,
                            ),
                          ),
                        );
                      },
                      child: const Text('Differential Diagnosis'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        //go to ten diag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TentativeDiag(
                              questionObj: questionObj,
                            ),
                          ),
                        );
                      },
                      child: const Text('Definitive/Tentative Diagnosis'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
