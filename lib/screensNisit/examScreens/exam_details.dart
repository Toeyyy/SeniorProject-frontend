import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/split_screen_nisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/screensNisit/examScreens/exam_result.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/models/exam_result_object.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';

class ExamDetailType extends StatelessWidget {
  List<ExamPreDefinedObject> list;
  final String title;
  final QuestionObject questionObj;

  ExamDetailType(
      {super.key,
      required this.list,
      required this.title,
      required this.questionObj});

  late Map<String, List<ExamPreDefinedObject>> groupedByType =
      groupBy(list, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(
          questionObj: questionObj,
          addedContent: Column(
            children: [
              TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 1',
                  showList: problemProvider.problemAnsList1
                      .map((e) => e.name)
                      .toList()),
              TitleAndDottedListView(
                  title: 'Differential Diagnosis',
                  showList:
                      diagProvider.diffDiagList.map((e) => e.name).toList()),
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: groupedByType.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: const Color(0xFFA0E9FF),
                      hoverColor: const Color(0xFF42C2FF),
                      title: Text(groupedByType.keys.toList()[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamDetailName(
                              list: groupedByType.values.toList()[index],
                              title: groupedByType.keys.toList()[index],
                              quesId: questionObj.id,
                              questionObj: questionObj,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              MyCancelButton(myContext: context),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamDetailName extends StatefulWidget {
  final List<ExamPreDefinedObject> list;
  final String title;
  final String quesId;
  final QuestionObject questionObj;

  const ExamDetailName(
      {super.key,
      required this.list,
      required this.title,
      required this.quesId,
      required this.questionObj});

  @override
  State<ExamDetailName> createState() => _ExamDetailNameState();
}

class _ExamDetailNameState extends State<ExamDetailName> {
  late Map<String, List<ExamPreDefinedObject>> groupedByName =
      groupBy(widget.list, (e) => e.name);
  late String selectedName = groupedByName.keys.first;

  late List<ExamPreDefinedObject> areaList = groupedByName[selectedName]!;
  late ExamPreDefinedObject? selectedItem =
      areaList.isEmpty ? null : areaList.first;

  late ExamResultObject? result;

  bool isLoadingData = false;

  Future getData(String examID) async {
    setState(() {
      isLoadingData = true;
    });
    List<ExamResultObject> loadedData =
        await fetchResult(examID, widget.quesId);
    setState(() {
      result = loadedData.first;
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(
          questionObj: widget.questionObj,
          addedContent: Column(
            children: [
              TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 1',
                  showList: problemProvider.problemAnsList1
                      .map((e) => e.name)
                      .toList()),
              TitleAndDottedListView(
                  title: 'Differential Diagnosis',
                  showList:
                      diagProvider.diffDiagList.map((e) => e.name).toList()),
            ],
          ),
        ),
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
                  const DividerWithSpace(),
                  /////name/////
                  const Text('ชื่อการส่งตรวจ', style: kSubHeaderTextStyle),
                  const SizedBox(height: 20),
                  DropdownButton(
                      value: selectedName,
                      icon: const Icon(Icons.arrow_drop_down),
                      padding: const EdgeInsets.all(5),
                      isDense: true,
                      alignment: Alignment.center,
                      focusColor: const Color(0xFFF2F5F7),
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
                          selectedName = value!;
                          areaList = groupedByName[selectedName]!;
                          selectedItem =
                              areaList.isEmpty ? null : areaList.first;
                        });
                      }),
                  /////area/////
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DividerWithSpace(),
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
                              icon: const Icon(Icons.arrow_drop_down),
                              padding: const EdgeInsets.all(5),
                              isDense: true,
                              alignment: Alignment.center,
                              focusColor: const Color(0xFFF2F5F7),
                              items: areaList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                      '${e.area}, ราคาค่าตรวจ ${e.cost} บาท'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedItem = value;
                                });
                              }),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const DividerWithSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyCancelButton(myContext: context),
                      ElevatedButton(
                        onPressed: () async {
                          examProvider.addNewExam(selectedItem!);
                          await getData(selectedItem!.id).then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamResult(
                                  selectedExam: selectedItem!,
                                  result: result!,
                                  questionObj: widget.questionObj,
                                ),
                              ),
                            );
                          });
                        },
                        child: const Text('ยืนยัน'),
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
