import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/statModels/StatNisitObject.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:collection/collection.dart';

class ShowStatDetail extends StatelessWidget {
  List<StatNisitObject> statList;
  ShowStatDetail({super.key, required this.statList});

  @override
  Widget build(BuildContext context) {
    Map<String, List<ProblemObject>> splitProblems;
    Map<String, List<ExamPreDefinedObject>> splitExams;

    int findTotalCost(StatNisitObject stat) {
      int res = 0;
      for (var item in stat.examinations) {
        res += item.cost;
      }
      for (var item in stat.treatments) {
        res += item.cost;
      }
      return res;
    }

    int findTotalPoint(StatNisitObject stat) {
      int res = 0;
      res = stat.problem1Score +
          stat.problem2Score +
          stat.examination1Score +
          stat.examination1Score +
          stat.diagnosticScore +
          stat.treatmentScore;
      return res;
    }

    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                const Text(
                  'สถิตินิสิตรายบุคคล',
                  style: kHeaderTextStyle,
                ),
                const DividerWithSpace(),
                Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: kTableHeaderTextStyle,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFFA0E9FF)),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text('ชื่อนิสิต'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนนรวม'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('ราคาค่าตรวจรวม'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนน Problem List ครั้งที่ 1'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนน Examination ครั้งที่ 1'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนน Problem List ครั้งที่ 2'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนน Examination ครั้งที่ 2'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนน Diagnosis'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('คะแนน Treatment'),
                            ),
                          ),
                        ],
                        rows: List.generate(statList.length, (index) {
                          splitProblems = groupBy(statList[index].problems,
                              (e) => e.round.toString());
                          splitExams = groupBy(statList[index].examinations,
                              (e) => e.round.toString());
                          return DataRow(
                              color: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFE7F9FF)),
                              cells: <DataCell>[
                                DataCell(
                                  Center(child: Text(statList[index].userName)),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(findTotalPoint(statList[index])
                                        .toString()),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(findTotalCost(statList[index])
                                        .toString()),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statList[index]
                                            .problem1Score
                                            .toString(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            probDiagTreatmentModal(
                                                context,
                                                "Problem List ครั้งที่ 1",
                                                splitProblems['1']!);
                                          },
                                          icon: Icon(Icons.search)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statList[index]
                                            .examination1Score
                                            .toString(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            examModal(
                                                context, '1', splitExams['1']!);
                                          },
                                          icon: Icon(Icons.search))
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statList[index]
                                            .problem2Score
                                            .toString(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            probDiagTreatmentModal(
                                                context,
                                                "Problem List ครั้งที่ 2",
                                                splitProblems['2']!);
                                          },
                                          icon: const Icon(Icons.search)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statList[index]
                                            .examination2Score
                                            .toString(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            examModal(
                                                context, '2', splitExams['2']!);
                                          },
                                          icon: Icon(Icons.search))
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statList[index]
                                            .diagnosticScore
                                            .toString(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            probDiagTreatmentModal(
                                                context,
                                                "Diagnosis",
                                                statList[index].diagnostics);
                                          },
                                          icon: Icon(Icons.search)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statList[index]
                                            .treatmentScore
                                            .toString(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            probDiagTreatmentModal(
                                                context,
                                                "Treatment",
                                                statList[index].treatments);
                                          },
                                          icon: Icon(Icons.search))
                                    ],
                                  ),
                                ),
                              ]);
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B72BE),
                  ),
                  child: const Text(
                    'กลับ',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
