import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/screensNisit/examScreens/exam_result.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/UIModels/nisit/selectedProblem_provider.dart';

class ExamDetail_Type extends StatelessWidget {
  List<ExamPreDefinedObject> list;
  String title;
  int round;
  QuestionObject questionObj;

  ExamDetail_Type(
      {required this.list,
      required this.title,
      required this.round,
      required this.questionObj});

  late Map<String, List<ExamPreDefinedObject>> groupedByType =
      groupBy(list, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);

    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: round == 1
            ? LeftPartContent(
                questionObj: questionObj,
                addedContent: TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 1',
                  showList: problemProvider.problemAnsList1
                      .map((e) => e.name)
                      .toList(),
                ),
              )
            : LeftPartContent(
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
                  ],
                ),
              ),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Text(title, style: kSubHeaderTextStyle),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: groupedByType.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Color(0xFFA0E9FF),
                      hoverColor: Color(0xFF42C2FF),
                      title: Text(groupedByType.keys.toList()[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamDetail_Name(
                              list: groupedByType.values.toList()[index],
                              title: groupedByType.keys.toList()[index],
                              round: round,
                              questionObj: questionObj,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              MyBackButton(myContext: context),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamDetail_Name extends StatefulWidget {
  List<ExamPreDefinedObject> list;
  String title;
  int round;
  QuestionObject questionObj;

  ExamDetail_Name(
      {required this.list,
      required this.title,
      required this.round,
      required this.questionObj});

  @override
  State<ExamDetail_Name> createState() => _ExamDetail_NameState();
}

class _ExamDetail_NameState extends State<ExamDetail_Name> {
  late Map<String, List<ExamPreDefinedObject>> groupedByName =
      groupBy(widget.list, (e) => e.name);
  late String selectedName = groupedByName.keys.first;

  late List<ExamPreDefinedObject> areaList = groupedByName[selectedName]!;
  late ExamPreDefinedObject? selectedItem =
      areaList.isEmpty ? null : areaList.first;

  late ExamResultObject result;

  bool _isAreaVisible = false;

  Future getData(String examID) async {
    List<ExamResultObject> loadedData = await fetchResult(examID);

    setState(() {
      result = loadedData.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);

    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(questionObj: widget.questionObj),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(widget.title, style: kSubHeaderTextStyle)),
                  DividerWithSpace(),
                  /////name/////
                  Text('ชื่อการส่งตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  DropdownButton(
                      value: selectedName,
                      icon: Icon(Icons.arrow_drop_down),
                      padding: EdgeInsets.all(5),
                      isDense: true,
                      alignment: Alignment.center,
                      focusColor: Color(0xFFF2F5F7),
                      items: groupedByName.keys
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          // print('value = $value');
                          selectedName = value!;
                          areaList = groupedByName[selectedName]!;
                          selectedItem =
                              areaList.isEmpty ? null : areaList.first;
                          if (areaList.length == 1) {
                            _isAreaVisible = false;
                          } else {
                            _isAreaVisible = true;
                          }
                          // print('areaList = $areaList');
                          // print('selectedItem = $selectedItem');
                        });
                      }),
                  /////area/////
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DividerWithSpace(),
                      Text(
                          areaList.length != 1
                              ? 'ตัวอย่างและราคาที่ใช้ในการส่งตรวจ'
                              : 'ราคาที่ใช้ในการส่งตรวจ',
                          style: kSubHeaderTextStyle),
                      const SizedBox(height: 20),
                      areaList.length == 1
                          ? Text('ราคาค่าตรวจ ${areaList.first.cost} บาท')
                          : DropdownButton(
                              value: selectedItem,
                              icon: Icon(Icons.arrow_drop_down),
                              padding: EdgeInsets.all(5),
                              isDense: true,
                              alignment: Alignment.center,
                              focusColor: Color(0xFFF2F5F7),
                              items: areaList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                      '${e.area}, ราคาค่าตรวจ ${e.cost} บาท'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  // print('value = $value');
                                  selectedItem = value;
                                });
                              }),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  DividerWithSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(myContext: context),
                      ElevatedButton(
                        onPressed: () async {
                          examProvider.addNewExam(selectedItem!, widget.round);
                          await getData(selectedItem!.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamResult(
                                selectedExam: selectedItem!,
                                round: widget.round,
                                questionObj: widget.questionObj,
                                result: result,
                              ),
                            ),
                          );
                        },
                        child: Text('ยืนยัน'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}