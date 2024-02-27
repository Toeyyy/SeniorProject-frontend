import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/UIModels/nisit/selected_treatment_provider.dart';
import 'package:frontend/constants.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';
import 'package:frontend/screensNisit/returnPoint.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/models/statModels/StatQuestionObject.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/aboutData/postDataFunctions.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';

class TreatmentTotal extends StatelessWidget {
  QuestionObject questionObj;

  TreatmentTotal({super.key, required this.questionObj});

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
        rightPart: RightPart_TreatmentTotal(
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPart_TreatmentTotal extends StatefulWidget {
  QuestionObject questionObj;

  RightPart_TreatmentTotal({super.key, required this.questionObj});

  @override
  State<RightPart_TreatmentTotal> createState() =>
      _RightPart_TreatmentTotalState();
}

class _RightPart_TreatmentTotalState extends State<RightPart_TreatmentTotal> {
  late StatQuestionObject stat;
  bool _isSendingData = false;

  Future getData(String questionID) async {
    List<StatQuestionObject> loadedData = await fetchStatQuestion(questionID);

    setState(() {
      stat = loadedData.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedTreatment treatmentProvider =
        Provider.of<SelectedTreatment>(context);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);

    Future<void> postStat(BuildContext context) async {
      //prob List
      var probList1 = problemProvider.problemList1.map((item) {
        return {"id": item.id, "round": item.round};
      }).toList();
      var probList2 = problemProvider.problemList2.map((item) {
        return {"id": item.id, "round": item.round};
      }).toList();
      probList1.addAll(probList2);

      //exams
      var exam1 = examProvider.examList1.map((item) {
        return {"id": item.id, "round": item.round};
      }).toList();
      var exam2 = examProvider.examList2.map((item) {
        return {"id": item.id, "round": item.round};
      }).toList();
      exam1.addAll(exam2);

      //treatment
      var treatment = treatmentProvider.treatmentList.map((item) {
        return {"id": item.id};
      }).toList();

      //diag
      var diag = diagProvider.diagList.map((item) {
        return {"id": item.id};
      }).toList();

      Map<String, dynamic> data = {
        "problems": probList1,
        "examinations": exam1,
        "treatments": treatment,
        "diagnostics": diag,
        "heartProblem1": problemProvider.heart1,
        "heartProblem2": problemProvider.heart2,
      };

      await postSelectedItemNisit(data, widget.questionObj.id);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: !_isSendingData
          ? Column(
              children: [
                const Text(
                  "Treatment ที่เลือก",
                  style: kHeaderTextStyle,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: treatmentProvider.treatmentList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.circle, size: 15),
                        title:
                            Text(treatmentProvider.treatmentList[index].name),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TreatmentTopic(
                              questionObj: widget.questionObj,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B72BE),
                      ),
                      child: const Text('เลือก Treatment'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isSendingData = true;
                        });
                        //post answer//
                        await postStat(context);
                        ////get stat////
                        await getData(widget.questionObj.id).then((value) {
                          setState(() {
                            _isSendingData = false;
                          });
                          //clear data//
                          treatmentProvider.clearList();
                          problemProvider.clearList();
                          examProvider.clearList();
                          diagProvider.clearList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReturnPoint(
                                stat: stat,
                              ),
                            ),
                          );
                        });
                      },
                      child: const Text('ส่งคำตอบ'),
                    ),
                  ],
                ),
              ],
            )
          : const SizedBox(
              width: 10,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF42C2FF),
                ),
              ),
            ),
    );
  }
}
