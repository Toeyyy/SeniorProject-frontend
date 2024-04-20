import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/examination_object.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/models/full_question_object.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/models/statModels/stat_question_object.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:collection/collection.dart';
import 'package:frontend/components/exam_container.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';

class ReturnPointInit extends StatefulWidget {
  final String quesId;
  const ReturnPointInit({super.key, required this.quesId});

  @override
  State<ReturnPointInit> createState() => _ReturnPointInitState();
}

class _ReturnPointInitState extends State<ReturnPointInit> {
  StatQuestionObject? stat;

  Future getData() async {
    var loadedData = await fetchStatQuestion(widget.quesId);
    setState(() {
      stat = loadedData;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ReturnPoint(
      stat: stat,
      quesId: widget.quesId,
    );
  }
}

class ReturnPoint extends StatelessWidget {
  StatQuestionObject? stat;
  final String quesId;

  ReturnPoint({super.key, required this.stat, required this.quesId});

  late Map<String, List<ProblemObject>> splitProblems =
      groupBy(stat!.problems, (e) => e.round.toString());
  late Map<String, List<DiagnosisObject>> splitDiag =
      groupBy(stat!.diagnostics, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    int findTotalCost() {
      int res = 0;
      for (var item in stat!.examinations) {
        res += item.cost;
      }
      for (var item in stat!.treatments) {
        res += item.cost;
      }
      return res;
    }

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: stat != null
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text(
                            'รายงานคะแนน',
                            style: kHeaderTextStyle,
                          ),
                        ),
                        const DividerWithSpace(),
                        Text(
                          'Problem List ครั้งที่ 1, คะแนนที่ได้: ${stat!.problem1Score.toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: splitProblems.containsKey('1')
                              ? splitProblems['1']!.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(splitProblems['1']![index].name),
                              leading: const Icon(
                                Icons.circle,
                                size: 15,
                              ),
                            );
                          },
                        ),
                        const DividerWithSpace(),
                        /////diff diag/////
                        Text(
                          'Differential Diagnosis, คะแนนที่ได้: ${stat!.diffDiagScore.toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: splitDiag.containsKey('differential')
                              ? splitDiag['differential']!.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(splitDiag['differential']![index].name),
                              leading: const Icon(
                                Icons.circle,
                                size: 15,
                              ),
                            );
                          },
                        ),
                        const DividerWithSpace(),
                        //exam
                        Text(
                          'Examination, คะแนนที่ได้: ${stat!.examinationScore.toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 15),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: stat!.examinations.length,
                            itemBuilder: (context, index) {
                              var item = stat!.examinations[index];
                              return ShowExamContainer(
                                  lab: item.lab,
                                  type: item.type,
                                  area: item.area,
                                  name: item.name);
                            }),
                        const DividerWithSpace(),
                        /////prob2/////
                        Text(
                          'Problem List ครั้งที่ 2, คะแนนที่ได้: ${stat!.problem2Score.toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: splitProblems.containsKey('2')
                              ? splitProblems['2']!.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(splitProblems['2']![index].name),
                              leading: const Icon(
                                Icons.circle,
                                size: 15,
                              ),
                            );
                          },
                        ),
                        const DividerWithSpace(),
                        /////ten diag/////
                        Text(
                          'Definitive/Tentative Diagnosis, คะแนนที่ได้: ${stat!.tenDiagScore.toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: splitDiag.containsKey('tentative')
                              ? splitDiag['tentative']!.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(splitDiag['tentative']![index].name),
                              leading: const Icon(
                                Icons.circle,
                                size: 15,
                              ),
                            );
                          },
                        ),
                        const DividerWithSpace(),
                        /////treatment/////
                        Text(
                          'Treatment, คะแนนที่ได้: ${stat!.treatmentScore.toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: stat!.treatments.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(stat!.treatments[index].name),
                              leading: const Icon(
                                Icons.circle,
                                size: 15,
                              ),
                            );
                          },
                        ),
                        const DividerWithSpace(),
                        Text(
                          'คะแนนรวม: ${(stat!.problem1Score + stat!.problem2Score + stat!.examinationScore + stat!.diffDiagScore + stat!.treatmentScore + stat!.tenDiagScore).toStringAsFixed(2)} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        Text(
                          'ราคาค่าตรวจรวม: ${findTotalCost()} บาท',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const DividerWithSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.go('/mainShowQuestion');
                              },
                              child: const Text('หน้าแรก'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.goNamed(
                                  'questionAnswer',
                                  queryParameters: {"id": quesId},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA0E9FF),
                              ),
                              child: const Text(
                                'เฉลยคำตอบ',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Color(0xFF42C2FF),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
