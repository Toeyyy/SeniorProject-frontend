import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/statModels/StatQuestionObject.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:collection/collection.dart';

class ShowStatsForNisit extends StatefulWidget {
  const ShowStatsForNisit({super.key});

  @override
  State<ShowStatsForNisit> createState() => _ShowStatsForNisitState();
}

class _ShowStatsForNisitState extends State<ShowStatsForNisit> {
  late List<StatQuestionObject> statList;
  bool _isLoadingData = false;
  late Map<String, List<ProblemObject>> splitProblems = {};
  late Map<String, List<ExamPreDefinedObject>> splitExams = {};

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

    int findTotalPoint(StatQuestionObject stat) {
      int res = 0;
      res = stat.problem1Score +
          stat.problem2Score +
          stat.examination1Score +
          stat.examination1Score +
          stat.diagnosticScore +
          stat.treatmentScore;
      return res;
    }

    void probDiagTreatmentModal(
        BuildContext context, String title, List<dynamic> list) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.5,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4),
                decoration: BoxDecoration(
                  color: Color(0xFFBBF5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: kSubHeaderTextStyleInLeftPart),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(list[index].name),
                                leading: Icon(Icons.circle, size: 15),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    void examModal(BuildContext context, String round,
        List<ExamPreDefinedObject> examList) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Color(0xFFBBF5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Examination ครั้งที่ $round',
                            style: kSubHeaderTextStyleInLeftPart),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: examList.length,
                            itemBuilder: (context, index) {
                              var item = examList[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Row(
                                      children: [
                                        const Text(
                                          'แผนกที่เลือกตรวจ: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(item.lab),
                                      ],
                                    ),
                                    leading: const Icon(
                                      Icons.circle,
                                      size: 15,
                                    ),
                                  ),
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 35),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'หัวข้อการตรวจ: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(item.type)
                                        ],
                                      ),
                                    ),
                                  ),
                                  item.area != null
                                      ? ListTile(
                                          title: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 35),
                                            child: Row(
                                              children: [
                                                const Text(
                                                    'ตัวอย่างการส่งตรวจ: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                Text(item.area!),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 35),
                                      child: Row(
                                        children: [
                                          const Text('ชื่อการส่งตรวจ: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          Text(item.name),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppbarNisit(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: !_isLoadingData
                  ? Column(
                      children: [
                        Text(
                          'ประวัติการเล่น',
                          style: kHeaderTextStyle,
                        ),
                        DividerWithSpace(),
                        statList.isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingTextStyle: kTableHeaderTextStyle,
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Color(0xFFA0E9FF)),
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
                                        child: Text(
                                            'คะแนน Problem List ครั้งที่ 1'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                            'คะแนน Examination ครั้งที่ 1'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                            'คะแนน Problem List ครั้งที่ 2'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                            'คะแนน Examination ครั้งที่ 2'),
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
                                  rows: List.generate(
                                    statList.length,
                                    (index) {
                                      setState(() {
                                        splitProblems = groupBy(
                                            statList[index].problems,
                                            (e) => e.round.toString());
                                        splitExams = groupBy(
                                            statList[index].examinations,
                                            (e) => e.round.toString());
                                      });
                                      return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                            (states) => Color(0xFFE7F9FF)),
                                        cells: <DataCell>[
                                          DataCell(
                                            Center(
                                                child: Text(statList[index]
                                                    .questionName)),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(findTotalPoint(
                                                      statList[index])
                                                  .toString()),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  statList[index]
                                                      .examination1Score
                                                      .toString(),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      examModal(context, '1',
                                                          splitExams['1']!);
                                                    },
                                                    icon: Icon(Icons.search))
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
                                                      .toString(),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      probDiagTreatmentModal(
                                                          context,
                                                          "Problem List ครั้งที่ 2",
                                                          splitProblems['2']!);
                                                    },
                                                    icon: Icon(Icons.search)),
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
                                                      .examination2Score
                                                      .toString(),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      examModal(context, '2',
                                                          splitExams['2']!);
                                                    },
                                                    icon: Icon(Icons.search))
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
                                                      .diagnosticScore
                                                      .toString(),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      probDiagTreatmentModal(
                                                          context,
                                                          "Diagnosis",
                                                          statList[index]
                                                              .diagnostics);
                                                    },
                                                    icon: Icon(Icons.search)),
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
                                                      .toString(),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      probDiagTreatmentModal(
                                                          context,
                                                          "Treatment",
                                                          statList[index]
                                                              .treatments);
                                                    },
                                                    icon: Icon(Icons.search))
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : SizedBox(
                      width: 10,
                      child: Center(child: CircularProgressIndicator())),
            ),
          ),
        ),
      ),
    );
  }
}
