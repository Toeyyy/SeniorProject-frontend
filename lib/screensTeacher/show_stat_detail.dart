import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:frontend/models/statModels/stat_nisit_object.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class ShowStatDetail extends StatelessWidget {
  final List<StatNisitObject> statList;
  final String? extraQues;
  const ShowStatDetail(
      {super.key, required this.statList, required this.extraQues});

  @override
  Widget build(BuildContext context) {
    Map<String, List<ProblemObject>> splitProblems;
    Map<String, List<DiagnosisObject>> splitDiag;

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

    double findTotalPoint(StatNisitObject stat) {
      double res = 0;
      res = stat.problem1Score +
          stat.problem2Score +
          stat.examinationScore +
          stat.diffDiagScore +
          stat.tenDiagScore +
          stat.treatmentScore;
      return res;
    }

    const List<DataColumn> tableNameList = [
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
          child: Text('ราคาที่ใช้โดยรวม'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Problem List ครั้งที่ 1'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Differential Diagnosis'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Examination'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Problem List ครั้งที่ 2'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Definitive/Tentative Diagnosis'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Treatment'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คำถามเพิ่มเติม'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('วันที่ทำโจทย์'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('เวลา'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('เวอร์ชันโจทย์'),
        ),
      ),
    ];

    const List<DataColumn> tableNameNoQuesList = [
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
          child: Text('ราคาที่ใช้โดยรวม'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Problem List ครั้งที่ 1'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Differential Diagnosis'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Examination'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Problem List ครั้งที่ 2'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Definitive/Tentative Diagnosis'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('คะแนน Treatment'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('วันที่ทำโจทย์'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('เวลา'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('เวอร์ชันโจทย์'),
        ),
      ),
    ];

    List<DataCell> tableContent(
        int index,
        Map<String, List<ProblemObject>> splitProblems,
        Map<String, List<DiagnosisObject>> splitDiag,
        String time,
        DateTime dateInType) {
      return [
        DataCell(
          Center(child: Text(statList[index].userName)),
        ),
        DataCell(
          Center(
            child: Text(findTotalPoint(statList[index]).toStringAsFixed(2)),
          ),
        ),
        DataCell(
          Center(
            child: Text(findTotalCost(statList[index]).toString()),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statList[index].problem1Score.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(context, "Problem List ครั้งที่ 1",
                        splitProblems['1'] ?? []);
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
                statList[index].diffDiagScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(context, "Differential Diagnosis",
                        splitDiag['differential'] ?? []);
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
                statList[index].examinationScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    examModal(context, statList[index].examinations ?? []);
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statList[index].problem2Score.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(context, "Problem List ครั้งที่ 2",
                        splitProblems['2'] ?? []);
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
                statList[index].tenDiagScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(
                        context,
                        "Definitive/Tentative Diagnosis",
                        splitDiag['tentative'] ?? []);
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
                statList[index].treatmentScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(
                        context, "Treatment", statList[index].treatments ?? []);
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
        DataCell(
          Center(
            child: IconButton(
                onPressed: () {
                  extraQuesModal(context, extraQues!, statList[index].extraAns);
                },
                icon: const Icon(Icons.search)),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              DateFormat('dd/MM/yyyy').format(dateInType),
            ),
          ),
        ),
        DataCell(
          Center(child: Text(time)),
        ),
        DataCell(
          Center(child: Text('V. ${statList[index].quesVersion}')),
        ),
      ];
    }

    List<DataCell> tableContentNoQues(
        int index,
        Map<String, List<ProblemObject>> splitProblems,
        Map<String, List<DiagnosisObject>> splitDiag,
        String time,
        DateTime dateInType) {
      return [
        DataCell(
          Center(child: Text(statList[index].userName)),
        ),
        DataCell(
          Center(
            child: Text(findTotalPoint(statList[index]).toStringAsFixed(2)),
          ),
        ),
        DataCell(
          Center(
            child: Text(findTotalCost(statList[index]).toString()),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statList[index].problem1Score.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(context, "Problem List ครั้งที่ 1",
                        splitProblems['1'] ?? []);
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
                statList[index].diffDiagScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(context, "Differential Diagnosis",
                        splitDiag['differential'] ?? []);
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
                statList[index].examinationScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    examModal(context, statList[index].examinations ?? []);
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statList[index].problem2Score.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(context, "Problem List ครั้งที่ 2",
                        splitProblems['2'] ?? []);
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
                statList[index].tenDiagScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(
                        context,
                        "Definitive/Tentative Diagnosis",
                        splitDiag['tentative'] ?? []);
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
                statList[index].treatmentScore.toStringAsFixed(2),
              ),
              IconButton(
                  onPressed: () {
                    probDiagTreatmentModal(
                        context, "Treatment", statList[index].treatments ?? []);
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
        DataCell(
          Center(
            child: Text(
              DateFormat('dd/MM/yyyy').format(dateInType),
            ),
          ),
        ),
        DataCell(
          Center(child: Text(time)),
        ),
        DataCell(
          Center(child: Text('V. ${statList[index].quesVersion}')),
        ),
      ];
    }

    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
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
                        columns: (extraQues != null && extraQues != "")
                            ? tableNameList
                            : tableNameNoQuesList,
                        rows: List.generate(statList.length, (index) {
                          splitProblems = groupBy(statList[index].problems,
                              (e) => e.round.toString());
                          splitDiag = groupBy(
                              statList[index].diagnostics, (e) => e.type);
                          String date =
                              statList[index].dateTime.substring(0, 10);
                          String time =
                              statList[index].dateTime.substring(11, 16);
                          String hour =
                              (int.parse(time.substring(0, 2)) + 7).toString();
                          time =
                              "${hour.length == 2 ? hour : "0$hour"}:${time.substring(3, 5)}";
                          DateTime dateInType = DateTime.parse(date);
                          return DataRow(
                              color: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFE7F9FF)),
                              cells: (extraQues != null && extraQues != "")
                                  ? tableContent(index, splitProblems,
                                      splitDiag, time, dateInType)
                                  : tableContentNoQues(index, splitProblems,
                                      splitDiag, time, dateInType)
                              // <DataCell>[
                              //   DataCell(
                              //     Center(child: Text(statList[index].userName)),
                              //   ),
                              //   DataCell(
                              //     Center(
                              //       child: Text(findTotalPoint(statList[index])
                              //           .toStringAsFixed(2)),
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Center(
                              //       child: Text(findTotalCost(statList[index])
                              //           .toString()),
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           statList[index]
                              //               .problem1Score
                              //               .toStringAsFixed(2),
                              //         ),
                              //         IconButton(
                              //             onPressed: () {
                              //               probDiagTreatmentModal(
                              //                   context,
                              //                   "Problem List ครั้งที่ 1",
                              //                   splitProblems['1'] ?? []);
                              //             },
                              //             icon: const Icon(Icons.search)),
                              //       ],
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           statList[index]
                              //               .diffDiagScore
                              //               .toStringAsFixed(2),
                              //         ),
                              //         IconButton(
                              //             onPressed: () {
                              //               probDiagTreatmentModal(
                              //                   context,
                              //                   "Differential Diagnosis",
                              //                   splitDiag['differential'] ?? []);
                              //             },
                              //             icon: const Icon(Icons.search)),
                              //       ],
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           statList[index]
                              //               .examinationScore
                              //               .toStringAsFixed(2),
                              //         ),
                              //         IconButton(
                              //             onPressed: () {
                              //               examModal(
                              //                   context,
                              //                   statList[index].examinations ??
                              //                       []);
                              //             },
                              //             icon: const Icon(Icons.search))
                              //       ],
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           statList[index]
                              //               .problem2Score
                              //               .toStringAsFixed(2),
                              //         ),
                              //         IconButton(
                              //             onPressed: () {
                              //               probDiagTreatmentModal(
                              //                   context,
                              //                   "Problem List ครั้งที่ 2",
                              //                   splitProblems['2'] ?? []);
                              //             },
                              //             icon: const Icon(Icons.search)),
                              //       ],
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           statList[index]
                              //               .tenDiagScore
                              //               .toStringAsFixed(2),
                              //         ),
                              //         IconButton(
                              //             onPressed: () {
                              //               probDiagTreatmentModal(
                              //                   context,
                              //                   "Definitive/Tentative Diagnosis",
                              //                   splitDiag['tentative'] ?? []);
                              //             },
                              //             icon: const Icon(Icons.search)),
                              //       ],
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           statList[index]
                              //               .treatmentScore
                              //               .toStringAsFixed(2),
                              //         ),
                              //         IconButton(
                              //             onPressed: () {
                              //               probDiagTreatmentModal(
                              //                   context,
                              //                   "Treatment",
                              //                   statList[index].treatments ?? []);
                              //             },
                              //             icon: const Icon(Icons.search))
                              //       ],
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Center(
                              //       child: Text(
                              //         DateFormat('dd/MM/yyyy').format(dateInType),
                              //       ),
                              //     ),
                              //   ),
                              //   DataCell(
                              //     Center(child: Text(time)),
                              //   ),
                              //   DataCell(
                              //     Center(
                              //         child: Text(
                              //             'V. ${statList[index].quesVersion}')),
                              //   ),
                              // ],
                              );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyBackButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
