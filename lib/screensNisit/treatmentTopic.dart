import 'package:flutter/material.dart';
import 'package:frontend/components/HoverColorListTile.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensNisit/treatmentDetail.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/screensNisit/treatmentTotal.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';

class TreatmentTopic extends StatelessWidget {
  QuestionObject questionObj;

  TreatmentTopic({super.key, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);
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
              TitleAndExams(
                title: 'Examination',
                showList: examProvider.examList,
                resultList: examProvider.resultList,
              ),
              TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 2',
                  showList: problemProvider.problemAnsList2
                      .map((e) => e.name)
                      .toList()),
              TitleAndDottedListView(
                  title: 'Definitive/Tentative Diagnosis',
                  showList:
                      diagProvider.tenDiagList.map((e) => e.name).toList()),
            ],
          ),
        ),
        rightPart: RightPart_TreatmentTopic(
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPart_TreatmentTopic extends StatefulWidget {
  QuestionObject questionObj;

  RightPart_TreatmentTopic({super.key, required this.questionObj});

  @override
  State<RightPart_TreatmentTopic> createState() =>
      _RightPart_TreatmentTopicState();
}

class _RightPart_TreatmentTopicState extends State<RightPart_TreatmentTopic> {
  final Map<String, List<TreatmentObject>> _groupedByType =
      groupBy(treatmentListPreDefined, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          const Text(
            'Treatment',
            style: kHeaderTextStyle,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _groupedByType.keys.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
              itemBuilder: (context, index) {
                return HoverColorListTile(
                  hoverColor: Color(0xFF42C2FF),
                  title: Text(_groupedByType.keys.toList()[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TreatmentDetail(
                          _groupedByType.keys.toList()[index],
                          questionObj: widget.questionObj,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TreatmentTotal(
                    questionObj: widget.questionObj,
                  ),
                ),
              );
            },
            child: const Text('Treatment ที่เลือก'),
          ),
        ],
      ),
    );
  }
}
