import 'package:frontend/components/boxes_component.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/treatment_object.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/exam_container.dart';
import 'package:go_router/go_router.dart';

class AnswerInit extends StatefulWidget {
  final String quesId;
  const AnswerInit({super.key, required this.quesId});

  @override
  State<AnswerInit> createState() => _AnswerInitState();
}

class _AnswerInitState extends State<AnswerInit> {
  late List<ProblemObject> probList1;
  late List<ProblemObject> probList2;
  late List<ExamPreDefinedObject> examList;
  late List<DiagnosisObject> diagList;
  late List<TreatmentObject> treatmentList;
  bool _isLoadData = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      _isLoadData = true;
    });
    var loadProb1 = await fetchProblemAns(widget.quesId, 1);
    var loadProb2 = await fetchProblemAns(widget.quesId, 2);
    var loadExam = await fetchExamAns(widget.quesId);
    var loadTreatment = await fetchTreatmentAns(widget.quesId);
    var loadDiag = await fetchDiagAns(widget.quesId);
    setState(() {
      probList1 = loadProb1;
      probList2 = loadProb2;
      examList = loadExam;
      diagList = loadDiag;
      treatmentList = loadTreatment;
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoadData == false)
        ? AnswerScreen(
            probList1: probList1,
            probList2: probList2,
            examList: examList,
            diffDiagList:
                diagList.where((e) => e.type == 'differential').toList(),
            tenDiagList: diagList.where((e) => e.type == 'tentative').toList(),
            treatmentList: treatmentList)
        : const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Color(0xFF42C2FF),
                ),
              ),
            ),
          );
  }
}

class AnswerScreen extends StatelessWidget {
  final List<ProblemObject> probList1;
  final List<ProblemObject> probList2;
  final List<ExamPreDefinedObject> examList;
  final List<DiagnosisObject> diffDiagList;
  final List<DiagnosisObject> tenDiagList;
  final List<TreatmentObject> treatmentList;

  const AnswerScreen(
      {super.key,
      required this.probList1,
      required this.probList2,
      required this.examList,
      required this.diffDiagList,
      required this.tenDiagList,
      required this.treatmentList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarNisit(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'เฉลยคำตอบ',
                      style: kHeaderTextStyle,
                    ),
                  ),
                  const DividerWithSpace(),
                  /////prob1/////
                  const Text(
                    'Problem List ครั้งที่ 1',
                    style: kSubHeaderTextStyleInLeftPart,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: probList1.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(probList1[index].name),
                        leading: const Icon(
                          Icons.circle,
                          size: 15,
                        ),
                      );
                    },
                  ),
                  const DividerWithSpace(),
                  /////diff diag/////
                  const Text(
                    'Differential Diagnosis',
                    style: kSubHeaderTextStyleInLeftPart,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: diffDiagList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(diffDiagList[index].name),
                        leading: const Icon(
                          Icons.circle,
                          size: 15,
                        ),
                      );
                    },
                  ),
                  const DividerWithSpace(),
                  //exam
                  const Text(
                    'Examination',
                    style: kSubHeaderTextStyleInLeftPart,
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: examList.length,
                      itemBuilder: (context, index) {
                        var item = examList[index];
                        return ShowExamContainer(
                            lab: item.lab,
                            type: item.type,
                            area: item.area,
                            name: item.name);
                      }),
                  const DividerWithSpace(),
                  /////prob2/////
                  const Text(
                    'Problem List ครั้งที่ 2',
                    style: kSubHeaderTextStyleInLeftPart,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: probList2.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(probList2[index].name),
                        leading: const Icon(
                          Icons.circle,
                          size: 15,
                        ),
                      );
                    },
                  ),
                  const DividerWithSpace(),
                  /////ten diag/////
                  const Text(
                    'Definitive/Tentative Diagnosis',
                    style: kSubHeaderTextStyleInLeftPart,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: tenDiagList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tenDiagList[index].name),
                        leading: const Icon(
                          Icons.circle,
                          size: 15,
                        ),
                      );
                    },
                  ),
                  const DividerWithSpace(),
                  /////treatment/////
                  const Text(
                    'Treatment',
                    style: kSubHeaderTextStyleInLeftPart,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: treatmentList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(treatmentList[index].name),
                        leading: const Icon(
                          Icons.circle,
                          size: 15,
                        ),
                      );
                    },
                  ),
                  const DividerWithSpace(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/mainShowQuestion');
                      },
                      child: const Text('หน้าแรก'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
