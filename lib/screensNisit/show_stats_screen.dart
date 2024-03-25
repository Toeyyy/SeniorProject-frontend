import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/statModels/stat_question_object.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class ShowStatsForNisit extends StatefulWidget {
  const ShowStatsForNisit({super.key});

  @override
  State<ShowStatsForNisit> createState() => _ShowStatsForNisitState();
}

class _ShowStatsForNisitState extends State<ShowStatsForNisit> {
  late List<StatQuestionObject> statList;
  bool _isLoadingData = false;
  late Map<String, List<ProblemObject>> splitProblems = {};
  late Map<String, List<DiagnosisObject>> splitDiag = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      _isLoadingData = true;
    });
    List<StatQuestionObject> loadedData = await fetchStatForNisit();
    setState(() {
      statList = loadedData;
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int findTotalCost(StatQuestionObject stat) {
      int res = 0;
      for (var item in stat.examinations) {
        res += item.cost;
      }
      for (var item in stat.treatments) {
        res += item.cost;
      }
      return res;
    }

    double findTotalPoint(StatQuestionObject stat) {
      double res = 0;
      res = stat.problem1Score +
          stat.problem2Score +
          stat.examinationScore +
          stat.diffDiagScore +
          stat.tenDiagScore +
          stat.treatmentScore;
      return res;
    }

    Widget showIcon(double score) {
      if (80 <= score && score <= 100) {
        // [80,100]
        return const Icon(Icons.sentiment_very_satisfied_outlined);
      } else if (60 <= score && score < 80) {
        //[60,80)
        return const Icon(Icons.sentiment_satisfied_alt_outlined);
      } else if (40 <= score && score < 60) {
        //[40,60)
        return const Icon(Icons.sentiment_satisfied);
      } else if (20 <= score && score < 40) {
        //[20,40)
        return const Icon(Icons.sentiment_neutral_rounded);
      } else {
        //[0,20)
        return const Icon(Icons.sentiment_dissatisfied);
      }
    }

    return Scaffold(
      appBar: const AppbarNisit(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: !_isLoadingData
                ? Column(
                    children: [
                      const Text(
                        'ประวัติการเล่น',
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
                                    child: Text('รหัสโจทย์'),
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
                                    child:
                                        Text('คะแนน Problem List ครั้งที่ 1'),
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
                                    child:
                                        Text('คะแนน Problem List ครั้งที่ 2'),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                        'คะแนน Definitive/Tentative Diagnosis'),
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
                              ],
                              rows: List.generate(
                                statList.length,
                                (index) {
                                  setState(() {
                                    splitProblems = groupBy(
                                        statList[index].problems,
                                        (e) => e.round.toString());
                                    splitDiag = groupBy(
                                        statList[index].diagnostics,
                                        (e) => e.type);
                                  });
                                  String date =
                                      statList[index].dateTime.substring(0, 10);
                                  String time = statList[index]
                                      .dateTime
                                      .substring(11, 16);
                                  String hour =
                                      (int.parse(time.substring(0, 2)) + 7)
                                          .toString();
                                  if (int.parse(hour) > 24) {
                                    hour = (int.parse(hour) - 24).toString();
                                  }
                                  time =
                                      "${hour.length == 2 ? hour : "0$hour"}:${time.substring(3, 5)}";
                                  DateTime dateInType = DateTime.parse(date);
                                  return DataRow(
                                    color: MaterialStateColor.resolveWith(
                                        (states) => const Color(0xFFE7F9FF)),
                                    cells: <DataCell>[
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            showIcon(findTotalPoint(
                                                statList[index])),
                                            const SizedBox(width: 5),
                                            Text(statList[index].questionName),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                              findTotalPoint(statList[index])
                                                  .toStringAsFixed(2)),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                              findTotalCost(statList[index])
                                                  .toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              statList[index]
                                                  .problem1Score
                                                  .toStringAsFixed(2),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  probDiagTreatmentModal(
                                                      context,
                                                      "Problem List ครั้งที่ 1",
                                                      splitProblems['1'] ?? []);
                                                },
                                                icon: const Icon(Icons.search)),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              statList[index]
                                                  .diffDiagScore
                                                  .toStringAsFixed(2),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  probDiagTreatmentModal(
                                                      context,
                                                      "Differential Diagnosis",
                                                      splitDiag[
                                                              'differential'] ??
                                                          []);
                                                },
                                                icon: const Icon(Icons.search)),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              statList[index]
                                                  .examinationScore
                                                  .toStringAsFixed(2),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  examModal(
                                                      context,
                                                      statList[index]
                                                              .examinations ??
                                                          []);
                                                },
                                                icon: const Icon(Icons.search))
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              statList[index]
                                                  .problem2Score
                                                  .toStringAsFixed(2),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  probDiagTreatmentModal(
                                                      context,
                                                      "Problem List ครั้งที่ 2",
                                                      splitProblems['2'] ?? []);
                                                },
                                                icon: const Icon(Icons.search)),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              statList[index]
                                                  .tenDiagScore
                                                  .toStringAsFixed(2),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  probDiagTreatmentModal(
                                                      context,
                                                      "Definitive/Tentative Diagnosis",
                                                      splitDiag['tentative'] ??
                                                          []);
                                                },
                                                icon: const Icon(Icons.search)),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              statList[index]
                                                  .treatmentScore
                                                  .toStringAsFixed(2),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  probDiagTreatmentModal(
                                                      context,
                                                      "Treatment",
                                                      statList[index]
                                                              .treatments ??
                                                          []);
                                                },
                                                icon: const Icon(Icons.search))
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(dateInType),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(child: Text(time)),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    width: 10,
                    child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }
}
