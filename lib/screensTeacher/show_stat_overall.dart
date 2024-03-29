import 'package:flutter/material.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/full_question_object.dart';
import 'package:frontend/models/statModels/stat_nisit_object.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/show_stat_detail.dart';
import 'package:frontend/screensTeacher/show_edit_history.dart';

class ShowStatOverall extends StatefulWidget {
  final String quesId;
  const ShowStatOverall({super.key, required this.quesId});

  @override
  State<ShowStatOverall> createState() => _ShowStatOverallState();
}

class _ShowStatOverallState extends State<ShowStatOverall> {
  late double averageCostExam = 0;
  late double averageCostTreatment = 0;
  late FullQuestionObject? questionObj;
  late List<StatNisitObject> statList = [];
  late Map<String, int> diffDiagList = {};
  late Map<String, int> tenDiagList = {};
  late Map<String, int> treatmentList = {};
  late Map<String, int> prob1List = {};
  late Map<String, int> prob2List = {};
  late Map<String, int> examList = {};
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
        examList[exam.name] = (examList[exam.name] ?? 0) + 1;
      }
      for (var diag in item.diagnostics) {
        if (diag.type == 'differential') {
          diffDiagList[diag.name] = (diffDiagList[diag.name] ?? 0) + 1;
        } else {
          tenDiagList[diag.name] = (tenDiagList[diag.name] ?? 0) + 1;
        }
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
    examList = Map.fromEntries(
        examList.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    examList = Map.fromEntries(examList.entries.take(20));
    /////diag/////
    diffDiagList = Map.fromEntries(diffDiagList.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    diffDiagList = Map.fromEntries(diffDiagList.entries.take(10));
    tenDiagList = Map.fromEntries(tenDiagList.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    tenDiagList = Map.fromEntries(tenDiagList.entries.take(10));
    /////treatment/////
    treatmentList = Map.fromEntries(treatmentList.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    treatmentList = Map.fromEntries(treatmentList.entries.take(20));
  }

  void findAvgCost() {
    int totalCostExam = 0;
    int totalCostTreatment = 0;
    for (var item in statList) {
      int costE = 0;
      int costT = 0;
      for (var exam in item.examinations) {
        costE += exam.cost;
      }
      for (var treatment in item.treatments) {
        costT += treatment.cost;
      }
      totalCostExam += costE;
      totalCostTreatment += costT;
    }
    averageCostExam = totalCostExam / statList.length;
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
    });
    var loadedQues = await fetchFullQuestionFromId(widget.quesId);
    setState(() {
      questionObj = loadedQues;
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          width: MediaQuery.of(context).size.width * 0.9,
          child: (!_loadData)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        logList: questionObj!.logs!),
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
                    statList.isNotEmpty
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const DividerWithSpace(),
                                  /////prob1/////
                                  StatBarGraph(
                                      statList: prob1List,
                                      title:
                                          'กราฟแสดงการเลือก Problem List ครั้งที่ 1 ของนิสิตทั้งหมด'),
                                  /////diff diag/////
                                  StatBarGraph(
                                      statList: diffDiagList,
                                      title:
                                          'กราฟแสดงการเลือก Differential Diagnosis ของนิสิตทั้งหมด'),
                                  /////exam/////
                                  StatBarGraph(
                                      statList: examList,
                                      title:
                                          'กราฟแสดงการเลือก Examination ของนิสิตทั้งหมด'),
                                  /////prob2/////
                                  StatBarGraph(
                                      statList: prob2List,
                                      title:
                                          'กราฟแสดงการเลือก Problem List ครั้งที่ 2 ของนิสิตทั้งหมด'),
                                  /////ten diag/////
                                  StatBarGraph(
                                      statList: tenDiagList,
                                      title:
                                          'กราฟแสดงการเลือก Definitive/Tentative Diagnosis ของนิสิตทั้งหมด'),
                                  /////treatment/////
                                  StatBarGraph(
                                      statList: treatmentList,
                                      title:
                                          'กราฟแสดงการเลือก Treatment ของนิสิตทั้งหมด'),
                                  ListTile(
                                    title: Text(
                                        'ราคาที่ใช้ในส่วน Examination โดยเฉลี่ยของนิสิตทั้งหมด: ${averageCostExam.toInt()} บาท',
                                        style: kNormalTextStyle),
                                    leading: const Icon(Icons.circle, size: 15),
                                  ),
                                  ListTile(
                                    title: Text(
                                        'ราคาที่ใช้ในส่วน Treatment โดยเฉลี่ยของนิสิตทั้งหมด: ${averageCostTreatment.toInt()} บาท',
                                        style: kNormalTextStyle),
                                    leading: const Icon(Icons.circle, size: 15),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(child: MyBackButton(myContext: context)),
                      ],
                    ),
                  ],
                )
              : const SizedBox(
                  width: 10, child: Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}
