import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/statModels/StatQuestionObject.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';

class ReturnPoint extends StatelessWidget {
  late StatQuestionObject? stat;

  ReturnPoint({super.key, required this.stat});

  late Map<String, List<ProblemObject>> splitProblems =
      groupBy(stat!.problems, (e) => e.round.toString());
  // late Map<String, List<ExamPreDefinedObject>> splitExams =
  //     groupBy(stat!.examinations, (e) => e.round.toString());

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
                        const Column(
                          children: [
                            Text(
                              'รายงานคะแนน',
                              style: kHeaderTextStyle,
                            ),
                            DividerWithSpace(),
                          ],
                        ),
                        Text(
                          'Problem List ครั้งที่ 1, คะแนนที่ได้: ${stat!.problem1Score} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: splitProblems['1']!.length,
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
                        Text(
                          'Examination, คะแนนที่ได้: ${stat!.examinationScore} คะแนน',
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
                        /////prob&exam2/////
                        Text(
                          'Problem List ครั้งที่ 2, คะแนนที่ได้: ${stat!.problem2Score} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: splitProblems['2']!.length,
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
                        /////diag/////
                        Text(
                          'Diagnosis, คะแนนที่ได้: ${stat!.diffDiagScore} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: stat!.diagnostics.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(stat!.diagnostics[index].name),
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
                          'Treatment, คะแนนที่ได้: ${stat!.treatmentScore} คะแนน',
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
                          'คะแนนรวม: ${stat!.problem1Score + stat!.problem2Score + stat!.examinationScore + stat!.diffDiagScore + stat!.treatmentScore} คะแนน',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        Text(
                          'ราคาค่าตรวจรวม: ${findTotalCost()} บาท',
                          style: kSubHeaderTextStyleInLeftPart,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/mainShowQuestionNisit'),
                              );
                            },
                            child: const Text('หน้าแรก'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  width: 10,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
