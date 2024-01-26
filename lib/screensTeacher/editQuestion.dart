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
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:frontend/components/backButton.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditQuestion extends StatefulWidget {
  // String quesNum;

  // EditQuestion({required this.quesNum});

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  String id = quesID;
  String signalmentTypeValue = showSignalmentList.species;
  String signalmentBreedValue = showSignalmentList.breed;
  bool signalmentSterilizeStat = showSignalmentList.sterilize;
  String signalmentSexValue = showSignalmentList.gender;
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

  late ExamContainerProvider examProvider;
  late List<ExamContainer> examContainers1;
  late List<ExamContainer> examContainers2;

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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<TreatmentContainerProvider>(context, listen: false)
          .getInfo(showTreatmentList);
    });

    Future.delayed(Duration.zero, () {
      Provider.of<ExamContainerProvider>(context, listen: false)
          .getInfo(showSelectedExam);
      // examProvider = Provider.of<ExamContainerProvider>(context, listen: false);
    });
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
    treatmentProvider = Provider.of<TreatmentContainerProvider>(context);
    treatmentContainer =
        Provider.of<TreatmentContainerProvider>(context).treatmentContainerList;
    examProvider = Provider.of<ExamContainerProvider>(context);
    examContainers1 = examProvider.examContainers1;
    examContainers2 = examProvider.examContainers2;

    Future<void> _postQuestion(BuildContext context) async {
      final dio = Dio();

      //prob List
      var probList1 = selectedProblemList1.map((item) {
        return {"id": item.id, "round": 1};
      }).toList();
      var probList2 = selectedProblemList2.map((item) {
        return {"id": item.id, "round": 2};
      }).toList();
      probList1.addAll(probList2);

      //treatment
      var treatment = treatmentContainer.map((item) {
        return {"id": item.id};
      }).toList();

      //diagnosis
      var diagnosis = selectedDiagnosisList.map((item) {
        return {"id": item.id};
      }).toList();

      //exams
      var exam1 = examContainers1.map((item) {
        return {
          "id": item.id,
          "textResult": item.examController.text,
          "imgPath": (item.imagePath != null && item.imageResult == null)
              ? item.imagePath
              : null,
          "imgResult": item.imageResult == null
              ? null
              : MultipartFile.fromBytes(item.imageResult!.bytes!,
                  filename: "image", contentType: MediaType("image", "png")),
          "round": item.round
        };
      }).toList();

      var exam2 = examContainers2.map((item) {
        return {
          "id": item.id,
          "textResult": item.examController.text,
          "imgPath": (item.imagePath != null && item.imageResult == null)
              ? item.imagePath
              : null,
          "imgResult": item.imageResult == null
              ? null
              : MultipartFile.fromBytes(item.imageResult!.bytes!,
                  filename: "image", contentType: MediaType("image", "png")),
          "round": item.round
        };
      }).toList();
      exam1.addAll(exam2);

      //tags
      var tag = selectedTags.map((item) {
        return {"id": item.id, "name": item.name};
      }).toList();

      FormData formData = FormData.fromMap({
        "clientComplains": clientComplainsController.text,
        "historyTakingInfo": historyTakingController.text,
        "generalInfo": generalResultsController.text,
        "problems": probList1,
        "examinations": exam1,
        "treatments": treatment,
        "diagnostics": diagnosis,
        "tags": tag,
        "signalment": {
          "species": signalmentTypeValue,
          "breed": signalmentBreedValue,
          "gender": signalmentSexValue,
          "sterilize": signalmentSterilizeStat,
          "age": signalmentAgeValue.text,
          "weight": signalmentWeightValue.text,
        }
      }, ListFormat.multiCompatible);
      var index = 0;
      for (var item in examContainers1) {
        if (item.imageResult != null) {
          formData.files.add(
            MapEntry(
              "examinations[$index].imgResult",
              MultipartFile.fromBytes(
                item.imageResult!.bytes!,
                filename: "image1.png",
                contentType: MediaType("image", "png"),
              ),
            ),
          );
        }
        index++;
      }
      index = 0;
      for (var item in examContainers2) {
        if (item.imageResult != null) {
          formData.files.add(
            MapEntry(
              "examinations[$index].imgResult",
              MultipartFile.fromBytes(
                item.imageResult!.bytes!,
                filename: "image1.png",
                contentType: MediaType("image", "png"),
              ),
            ),
          );
        }
        index++;
      }

      final response = await dio.post(
          '${dotenv.env['API_PATH']}/question/update/$quesID',
          data: formData);
    }

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
                      'แก้ไขโจทย์ $name',
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
                  ExamsButtonAndContainer(
                      examContainers: examProvider.examContainers1,
                      examListProvider: examProvider,
                      round: '1'),
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
                  ExamsButtonAndContainer(
                      examContainers: examProvider.examContainers2,
                      examListProvider: examProvider,
                      round: '2'),
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
                              selectedTreatmentTopic: getTreatmentTopic().first,
                              selectedTreatmentDetail:
                                  filterTreatment('Medical').first,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(myContext: context),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('บันทึก'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
