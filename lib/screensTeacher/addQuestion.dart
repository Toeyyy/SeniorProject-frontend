import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/UIModels/examContainer_provider.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/UIModels/treatmentContainer_provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/tagSearchBox.dart';
import 'package:dio/dio.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  String signalmentTypeValue = Signalment_typeList.first;
  String signalmentBreedValue = Signalment_dogBreedList.first;
  bool signalmentSterilizeStat = false;
  TextEditingController signalmentAgeValue = TextEditingController();
  TextEditingController signalmentWeightValue = TextEditingController();
  TextEditingController clientComplainsController = TextEditingController();
  TextEditingController historyTakingController = TextEditingController();
  TextEditingController generalResultsController = TextEditingController();
  List<ProblemObject> selectedProblemList1 = [];
  List<ProblemObject> selectedProblemList2 = [];
  List<DiagnosisObject> selectedDiagnosisList = [];
  List<TagObject> selectedTags = [];

  /////

  @override
  Widget build(BuildContext context) {
    List<ExamContainer> examContainers1 =
        Provider.of<ExamContainerProvider>(context).examContainers1;
    List<ExamContainer> examContainers2 =
        Provider.of<ExamContainerProvider>(context).examContainers2;
    ExamContainerProvider examListProvider =
        Provider.of<ExamContainerProvider>(context);

    /////
    List<TreatmentContainer> treatmentContainer =
        Provider.of<TreatmentContainerProvider>(context).treatmentContainerList;
    TreatmentContainerProvider treatmentProvider =
        Provider.of<TreatmentContainerProvider>(context, listen: false);

    void postQuestion(BuildContext context) async {
      final dio = Dio();

      //prob List
      var probList1 = selectedProblemList1.map((item) {
        return {"id": item.id, "name": item.name, "round": 1};
      }).toList();
      var probList2 = selectedProblemList2.map((item) {
        return {"id": item.id, "name": item.name, "round": 1};
      }).toList();
      probList1.addAll(probList2);

      //treatment
      var treatment = treatmentContainer.map((item) {
        return {
          "id": item.id,
          "type": item.selectedTreatmentTopic,
          "name": item.selectedTreatmentDetail
        };
      }).toList();

      //diagnosis
      var diagnosis = selectedDiagnosisList.map((item) {
        return {"id": item.id, "name": item.name};
      }).toList();

      //exams
      var exam = examContainers1.map((item) {
        return {
          "id": item.id,
          "type": item.selectedDepartment,
          "name": item.selectedExamTopic,
          "textResult": item.examController.text,
          "imgResult": item.imageFile,
          "round": item.round
        };
      }).toList();

      final response = await dio.post(
        'path',
        data: {
          "clientComplains": clientComplainsController.text,
          "historyTakingInfo": historyTakingController.text,
          "generalInfo": generalResultsController.text,
          "problems": json.encode(probList1),
          "treatments": json.encode(treatment),
          "diagnostics": json.encode(diagnosis),
          "examinations": json.encode(exam),
          "tags": json.encode(selectedTags),
          "signalment": {
            "species": signalmentTypeValue,
            "breed": signalmentBreedValue,
            "sterilize": signalmentSterilizeStat,
            "age": signalmentAgeValue,
            "weight": signalmentWeightValue,
          }
        },
      );
    }

    /////
    void _showModal(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFFDFE4E0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ยืนยันการเพิ่มโจทย์หรือไม่?',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF000411),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B72BE),
                            // minimumSize: Size(120, 60),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            postQuestion(context);
                          },
                          child: Text(
                            'ยืนยัน',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
    /////

    return Scaffold(
      appBar: AppbarTeacher(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'กรอกโจทย์โดยตรง',
                      style: kHeaderTextStyle.copyWith(
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const H20Sizedbox(),
                  Text(
                    'โจทย์',
                    style: kSubHeaderTextStyle.copyWith(fontSize: 35),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TagSearchBox(initTags: selectedTags),
                  const H20Sizedbox(),
                  //Signalment
                  Text(
                    'ข้อมูลทั่วไป',
                    style: kSubHeaderTextStyle,
                  ),
                  Row(
                    children: [
                      Text('ประเภท'),
                      SizedBox(width: 2),
                      DropDownButtonInAddQ(
                          selectedValue: signalmentTypeValue,
                          list: Signalment_typeList,
                          onChanged: (value) {
                            setState(() {
                              signalmentTypeValue = value.toString();
                              signalmentBreedValue =
                                  filterBreed(signalmentTypeValue).first;
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      Text('สายพันธุ์'),
                      SizedBox(width: 2),
                      DropDownButtonInAddQ(
                          selectedValue: signalmentBreedValue,
                          list: filterBreed(signalmentTypeValue),
                          onChanged: (value) {
                            setState(() {
                              signalmentBreedValue = value.toString();
                            });
                          }),
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0),
                    title: Text('ทำหมันแล้ว'),
                    leading: Checkbox(
                      value: signalmentSterilizeStat,
                      onChanged: (value) {
                        setState(() {
                          signalmentSterilizeStat = value!;
                        });
                      },
                    ),
                  ),
                  TextAndTextfield(
                      title: "อายุ", myController: signalmentAgeValue),
                  SizedBox(
                    height: 5,
                  ),
                  TextAndTextfield(
                      title: "น้ำหนัก", myController: signalmentWeightValue),
                  const H20Sizedbox(),
                  //Client Complain
                  TextBoxMultiLine(
                    myController: clientComplainsController,
                    hintText: "ข้อมูล Client Complains",
                    titleText: 'Client Complains',
                    maxLine: 4,
                    boxColor: Color(0xFFDFE4E0),
                  ),
                  const H20Sizedbox(),
                  TextBoxMultiLine(
                    myController: historyTakingController,
                    hintText: "ข้อมูล History Taking",
                    titleText: "History Taking",
                    maxLine: 4,
                    boxColor: Color(0xFFDFE4E0),
                  ),
                  const H20Sizedbox(),
                  TextBoxMultiLine(
                    myController: generalResultsController,
                    hintText: "ผลตรวจ 1, ผลตรวจ 2, ผลตรวจ 3",
                    titleText: "ผลตรวจร่างกาย [คั่นด้วยเครื่องหมาย , ]",
                    maxLine: 4,
                    boxColor: Color(0xFFDFE4E0),
                  ),
                  DividerWithSpace(),
                  //Answer
                  Text(
                    'เฉลย',
                    style: kSubHeaderTextStyle.copyWith(fontSize: 35),
                  ),
                  const H20Sizedbox(),
                  ProbListMultiSelectDropDown(
                    selectedList: selectedProblemList1,
                    displayList: probObjectList,
                    hintText: "เลือก Problem List ครั้งที่ 1",
                  ),
                  const H20Sizedbox(),
                  ExamsButtonAndContainer(
                    examContainers: examContainers1,
                    examListProvider: examListProvider,
                    round: '1',
                  ),
                  DividerWithSpace(),
                  ProbListMultiSelectDropDown(
                    selectedList: selectedProblemList2,
                    displayList: probObjectList,
                    hintText: "เลือก Problem List ครั้งที่ 2",
                  ),
                  const H20Sizedbox(),
                  ExamsButtonAndContainer(
                    examContainers: examContainers2,
                    examListProvider: examListProvider,
                    round: '2',
                  ),
                  DividerWithSpace(),
                  Text(
                    'Diagnosis',
                    style: kSubHeaderTextStyle,
                  ),
                  DiagnosisMultiSelectDropDown(
                      selectedList: selectedDiagnosisList,
                      displayList: diagnosisList,
                      hintText: 'เลือก Diagnosis'),
                  DividerWithSpace(),
                  Row(
                    children: [
                      Text(
                        'Treatment',
                        style: kSubHeaderTextStyle,
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          final int currentNub = treatmentProvider.nub;
                          print(currentNub);
                          treatmentProvider.addContainer(
                            TreatmentContainer(
                              id: currentNub,
                              key: ObjectKey(currentNub),
                              selectedTreatmentTopic: treatmentTopicList.first,
                              selectedTreatmentDetail:
                                  medicalTreatmentList.first,
                            ),
                          );
                        },
                        child: Text('เพิ่ม Treatment'),
                      ),
                    ],
                  ),
                  const H20Sizedbox(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: treatmentContainer.length,
                    itemBuilder: (context, index) {
                      return treatmentContainer[index];
                    },
                  ),
                  const H20Sizedbox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B72BE),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _showModal(context);
                          },
                          child: Text('บันทึก')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
