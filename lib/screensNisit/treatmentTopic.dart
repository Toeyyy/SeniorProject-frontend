import 'package:flutter/material.dart';
import 'package:frontend/components/HoverColorListTile.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensNisit/treatmentDetail.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/screensNisit/treatmentTotal.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/nisit/selectedProblem_provider.dart';
import 'package:frontend/UIModels/nisit/selectedDiagnosis_provider.dart';
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
      appBar: AppbarNisit(),
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
              TitleAndExams(
                title: 'Examination ครั้งที่ 1',
                showList: examProvider.examList1,
                resultList: examProvider.resultList1,
              ),
              TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 2',
                  showList: problemProvider.problemAnsList2
                      .map((e) => e.name)
                      .toList()),
              TitleAndExams(
                title: 'Examination ครั้งที่ 2',
                showList: examProvider.examList2,
                resultList: examProvider.resultList2,
              ),
              TitleAndDottedListView(
                  title: 'Diagnosis',
                  showList: diagProvider.diagList.map((e) => e.name).toList()),
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

  RightPart_TreatmentTopic({required this.questionObj});

  @override
  State<RightPart_TreatmentTopic> createState() =>
      _RightPart_TreatmentTopicState();
}

class _RightPart_TreatmentTopicState extends State<RightPart_TreatmentTopic> {
  // Map<String, List<TreatmentObject>> _groupedByType =
  //     groupBy(preDefinedTreatmentAll, (e) => e.type);
  final Map<String, List<TreatmentObject>> _groupedByType =
      groupBy(treatmentListPreDefined, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Text(
            'Treatment',
            style: kHeaderTextStyle,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _groupedByType.keys.length,
              separatorBuilder: (context, index) => SizedBox(
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
            child: Text('Treatment ที่เลือก'),
          ),
        ],
      ),
    );
  }
}
