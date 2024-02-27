import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/models/statModels/StatNisitObject.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/showStatDetail.dart';
import 'package:frontend/screensTeacher/showEditHistory.dart';

class ShowStatOverall extends StatefulWidget {
  FullQuestionObject? questionObj;
  ShowStatOverall({super.key, required this.questionObj});

  @override
  State<ShowStatOverall> createState() => _ShowStatOverallState();
}

class _ShowStatOverallState extends State<ShowStatOverall> {
  late double averageCostExam1 = 0;
  late double averageCostExam2 = 0;
  late double averageCostTreatment = 0;
  late FullQuestionObject? questionObj;
  late List<StatNisitObject> statList;
  late Map<String, int> diagList = {};
  late Map<String, int> treatmentList = {};
  late Map<String, int> prob1List = {};
  late Map<String, int> prob2List = {};
  late Map<String, int> exam1List = {};
  late Map<String, int> exam2List = {};
  bool _loadData = true;

  ////for bar chart////
  void assignStatList() {
    for (var item in statList) {
      for (var prob in item.problems) {
        if (prob.round == 1) {
          prob1List[prob.name] = (prob1List[prob.name] ?? 0) + 1;
        } else {
          prob2List[prob.name] = (prob2List[prob.name] ?? 0) + 1;
        }
      }
      for (var exam in item.examinations) {
        if (exam.round == 1) {
          exam1List[exam.name] = (exam1List[exam.name] ?? 0) + 1;
        } else {
          exam2List[exam.name] = (exam2List[exam.name] ?? 0) + 1;
        }
      }
      for (var diag in item.diagnostics) {
        diagList[diag.name] = (diagList[diag.name] ?? 0) + 1;
      }
      for (var treatment in item.treatments) {
        treatmentList[treatment.name] =
            (treatmentList[treatment.name] ?? 0) + 1;
      }
    }
    /////problem/////
    prob1List = Map.fromEntries(
        prob1List.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    prob1List = Map.fromEntries(prob1List.entries.take(20));
    prob2List = Map.fromEntries(
        prob2List.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    prob2List = Map.fromEntries(prob2List.entries.take(20));
    /////exam/////
    exam1List = Map.fromEntries(
        exam1List.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    exam1List = Map.fromEntries(exam1List.entries.take(20));
    exam2List = Map.fromEntries(
        exam2List.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    exam2List = Map.fromEntries(exam2List.entries.take(20));
    /////diag/////
    diagList = Map.fromEntries(
        diagList.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    diagList = Map.fromEntries(diagList.entries.take(10));
    /////treatment/////
    treatmentList = Map.fromEntries(treatmentList.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    treatmentList = Map.fromEntries(treatmentList.entries.take(20));
  }

  void findAvgCost() {
    int totalCostExam1 = 0;
    int totalCostExam2 = 0;
    int totalCostTreatment = 0;
    for (var item in statList) {
      int costE1 = 0;
      int costE2 = 0;
      int costT = 0;
      for (var exam in item.examinations) {
        if (exam.round == 1) {
          costE1 += exam.cost;
        } else {
          costE2 += exam.cost;
        }
      }
      for (var treatment in item.treatments) {
        costT += treatment.cost;
      }
      totalCostExam1 += costE1;
      totalCostExam2 += costE2;
      totalCostTreatment += costT;
    }
    averageCostExam1 = totalCostExam1 / statList.length;
    averageCostExam2 = totalCostExam2 / statList.length;
    averageCostTreatment = totalCostTreatment / statList.length;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  Future<void> getData() async {
    setState(() {
      _loadData = true;
      questionObj = widget.questionObj;
    });
    List<StatNisitObject> loadedData =
        await fetchStatForTeacher(questionObj!.id);
    setState(() {
      statList = loadedData;
    });
    assignStatList();
    findAvgCost();
    setState(() {
      _loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarTeacher(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            width: MediaQuery.of(context).size.width * 0.7,
            child: (!_loadData)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('สถิตินิสิต', style: kSubHeaderTextStyle),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShowStatDetail(statList: statList),
                                    ),
                                  );
                                },
                                child: const Text('สถิตินิสิตรายบุคคล'),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowEditHistory(
                                          logList: questionObj!.logs),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3DABF5),
                                ),
                                child: const Text('ประวัติการแก้ไขโจทย์'),
                              )
                            ],
                          ),
                        ],
                      ),
                      const DividerWithSpace(),
                      /////prob/////
                      StatBarGraph(
                          statList: prob1List,
                          title:
                              'กราฟแสดงการเลือก Problem List ครั้งที่ 1 ของนิสิตทั้งหมด'),
                      StatBarGraph(
                          statList: prob2List,
                          title:
                              'กราฟแสดงการเลือก Problem List ครั้งที่ 2 ของนิสิตทั้งหมด'),
                      /////exam/////
                      StatBarGraph(
                          statList: exam1List,
                          title:
                              'กราฟแสดงการเลือก Examination ครั้งที่ 1 ของนิสิตทั้งหมด'),
                      StatBarGraph(
                          statList: exam2List,
                          title:
                              'กราฟแสดงการเลือก Examination ครั้งที่ 2 ของนิสิตทั้งหมด'),
                      /////diag/////
                      StatBarGraph(
                          statList: diagList,
                          title: 'กราฟแสดงการเลือก Diagnosis ของนิสิตทั้งหมด'),
                      /////treatment/////
                      StatBarGraph(
                          statList: treatmentList,
                          title: 'กราฟแสดงการเลือก Treatment ของนิสิตทั้งหมด'),
                      ListTile(
                        title: Text(
                            'ราคาที่ใช้ในส่วน Examination ครั้งที่ 1 โดยเฉลี่ยของนิสิตทั้งหมด: ${averageCostExam1.toInt()} บาท',
                            style: kNormalTextStyle),
                        leading: const Icon(Icons.circle, size: 15),
                      ),
                      ListTile(
                        title: Text(
                            'ราคาที่ใช้ในส่วน Examination ครั้งที่ 2 โดยเฉลี่ยของนิสิตทั้งหมด: ${averageCostExam2.toInt()} บาท',
                            style: kNormalTextStyle),
                        leading: const Icon(Icons.circle, size: 15),
                      ),
                      ListTile(
                        title: Text(
                            'ราคาที่ใช้ในส่วน Treatment โดยเฉลี่ยของนิสิตทั้งหมด: ${averageCostTreatment.toInt()} บาท',
                            style: kNormalTextStyle),
                        leading: const Icon(Icons.circle, size: 15),
                      ),
                      Center(child: MyBackButton(myContext: context)),
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
