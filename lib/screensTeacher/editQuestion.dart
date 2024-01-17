import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/tagSearchBox.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/UIModels/treatmentContainer_provider.dart';
import 'package:frontend/components/treatmentContainer.dart';

class EditQuestion extends StatefulWidget {
  // String quesNum;

  // EditQuestion({required this.quesNum});

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  String signalmentTypeValue = showSignalmentList.species;
  String signalmentBreedValue = showSignalmentList.breed;
  bool signalmentSterilizeStat = showSignalmentList.sterilize;
  String signalmentSexValue = showSignalmentList.sex;
  TextEditingController signalmentAgeValue =
      TextEditingController(text: showSignalmentList.age);
  TextEditingController signalmentWeightValue =
      TextEditingController(text: showSignalmentList.weight);
  TextEditingController clientComplainsController =
      TextEditingController(text: clientComp);
  TextEditingController historyTakingController =
      TextEditingController(text: historyTaking);
  TextEditingController generalResultsController =
      TextEditingController(text: generalResult);
  List<ProblemObject> selectedProblemList1 = showSelectedProb1;
  List<ProblemObject> selectedProblemList2 = showSelectedProb2;
  List<DiagnosisObject> selectedDiagnosisList = [];
  List<TagObject> selectedTags = showTagList;

  late TreatmentContainerProvider treatmentProvider;
  late List<TreatmentContainer> treatmentContainer;

  //Update List/////
  void updateProbList(List<ProblemObject> newList, String round) {
    if (round == '1') {
      selectedProblemList1 = newList;
    } else {
      selectedProblemList2 = newList;
    }
  }

  void updateDiagList(List<DiagnosisObject> newList) {
    selectedDiagnosisList = newList;
  }

  void updateTagList(List<TagObject> newList) {
    selectedTags = newList;
  }

  /////get init Exams//////

  Map<String, List<ExaminationObject>> splitExams =
      groupBy(showSelectedExam, (obj) => obj.round);

  // List<ExaminationObject>? accessExamList(String round) {
  //   List<ExaminationObject>? list = splitExams[round];
  //   return list?.map((item) {
  //     return ShowExamContainer(
  //         department: item.type,
  //         exam: item.name,
  //         results: item.textResult,
  //         imagePath: item.imgResult);
  //   }).toList();
  // }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<TreatmentContainerProvider>(context, listen: false)
          .getInfo(showTreatmentList);
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // treatmentProvider =
    //   //     Provider.of<TreatmentContainerProvider>(context, listen: false);
    //   Provider.of<TreatmentContainerProvider>(context, listen: false)
    //       .getInfo(showTreatmentList);
    //   // treatmentContainer =
    //   //     Provider.of<TreatmentContainerProvider>(context, listen: false)
    //   //         .treatmentContainerList;
    // });
  }

  void printtreatment() {
    print(Provider.of<TreatmentContainerProvider>(context, listen: false)
        .treatmentContainerList
        .map(
          (item) => Text(
              '${item.selectedTreatmentTopic} and ${item.selectedTreatmentDetail}'),
        )
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    treatmentProvider =
        Provider.of<TreatmentContainerProvider>(context, listen: false);
    treatmentContainer =
        Provider.of<TreatmentContainerProvider>(context).treatmentContainerList;

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
                      'แก้ไขโจทย์ $quesNum',
                      style: kHeaderTextStyle.copyWith(
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const H20Sizedbox(),
                  TagMultiSelectDropDown(
                      selectedList: selectedTags,
                      displayList: allTagList,
                      hintText: 'Select tags',
                      updateListCallback: updateTagList),
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
                          hintText: "เลือกประเภทสัตว์",
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
                          hintText: "เลือกสายพันธุ์",
                          onChanged: (value) {
                            setState(() {
                              signalmentBreedValue = value.toString();
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      Text('เพศ'),
                      SizedBox(width: 2),
                      DropDownButtonInAddQ(
                          selectedValue: signalmentSexValue,
                          list: ['ผู้', 'เมีย'],
                          hintText: "เลือกเพศสัตว์",
                          onChanged: (value) {
                            setState(() {
                              signalmentSexValue = value!;
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
                  //History Taking
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
                  Text('Problem List ครั้งที่ 1', style: kSubHeaderTextStyle),
                  ProbListMultiSelectDropDown(
                    selectedList: showSelectedProb1,
                    displayList: probObjectList,
                    hintText: "เลือก Problem List ครั้งที่ 1",
                    round: "1",
                    updateListCallback: updateProbList,
                  ),
                  const H20Sizedbox(),
                  //TODO exam1
                  DividerWithSpace(),
                  Text('Problem List ครั้งที่ 2', style: kSubHeaderTextStyle),
                  ProbListMultiSelectDropDown(
                      selectedList: showSelectedProb2,
                      displayList: probObjectList,
                      hintText: "เลือก Problem List ครั้งที่ 2",
                      round: "2",
                      updateListCallback: updateProbList),
                  const H20Sizedbox(),
                  //TODO exam2
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
                          treatmentProvider.addContainer(
                            TreatmentContainer(
                              id: currentNub.toString(),
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
                  treatmentContainer.isEmpty
                      ? SizedBox()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: treatmentContainer.length,
                          itemBuilder: (context, index) {
                            return treatmentContainer[index];
                          },
                        ),
                  const H20Sizedbox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
