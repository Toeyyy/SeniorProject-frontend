import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/tagSearchBox.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:frontend/components/back_button.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/AllDataFile.dart';

class EditQuestion extends StatefulWidget {
  FullQuestionObject questionObj;
  VoidCallback refreshCallBack;

  EditQuestion(
      {super.key, required this.questionObj, required this.refreshCallBack});

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  late FullQuestionObject? questionObj = null;
  late String id = '0';
  late String name = 'X';
  late String signalmentTypeValue = 'สุนัข';
  late bool signalmentSterilizeValue = false;
  late String signalmentSexValue = 'ผู้';
  late TextEditingController signalmentBreedValue =
      TextEditingController(text: 'N/A');
  late TextEditingController signalmentAgeValue =
      TextEditingController(text: '0');
  late TextEditingController signalmentWeightValue =
      TextEditingController(text: '0');
  late TextEditingController clientComplainsController =
      TextEditingController(text: 'N/A');
  late TextEditingController historyTakingController =
      TextEditingController(text: 'N/A');
  late TextEditingController generalResultsController =
      TextEditingController(text: 'N/A');
  late Map<String, List<ProblemObject>> splitProblems = {};
  late List<ProblemObject> selectedProblemList1 = [];
  late List<ProblemObject> selectedProblemList2 = [];
  late List<DiagnosisObject> selectedDiagnosisList = [];
  late List<TagObject> selectedTags = [];

  late TreatmentContainerProvider treatmentProvider;
  late List<TreatmentContainer> treatmentContainer = [];

  late ExamContainerProvider examProvider;
  late List<ExamContainer> examContainers1 = [];
  late List<ExamContainer> examContainers2 = [];

  List<String> signalmentTypeList = ["สุนัข", "แมว", "นก"];

  bool _isPosting = false;

  //Update List/////
  void updateProbList(List<ProblemObject> newList, int round) {
    if (round == 1) {
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
      setState(() {
        questionObj = widget.questionObj;
        if (questionObj != null) {
          id = questionObj!.id;
          name = questionObj!.name;
          signalmentTypeValue = questionObj!.signalment.species;
          signalmentBreedValue.text = questionObj!.signalment.breed;
          signalmentSterilizeValue = questionObj!.signalment.sterilize;
          signalmentSexValue = questionObj!.signalment.gender;
          signalmentAgeValue.text = questionObj!.signalment.age;
          signalmentWeightValue.text = questionObj!.signalment.weight;
          clientComplainsController.text = questionObj!.clientComplains;
          historyTakingController.text = questionObj!.historyTakingInfo;
          generalResultsController.text = questionObj!.generalInfo;
          selectedTags = questionObj!.tags;
          /////
          splitProblems =
              groupBy(questionObj!.problems, (e) => e.round.toString());
          selectedProblemList1 = splitProblems['1']!
              .map(
                (e) => ProblemObject(id: e.id, name: e.name),
              )
              .toList();
          selectedProblemList2 = splitProblems['2']!
              .map(
                (e) => ProblemObject(id: e.id, name: e.name),
              )
              .toList();
          /////
          treatmentProvider =
              Provider.of<TreatmentContainerProvider>(context, listen: false);
          examProvider =
              Provider.of<ExamContainerProvider>(context, listen: false);
          Provider.of<TreatmentContainerProvider>(context, listen: false)
              .getInfo(questionObj!.treatments);
          Provider.of<ExamContainerProvider>(context, listen: false)
              .getInfo(questionObj!.examinations);

          treatmentContainer = treatmentProvider.treatmentContainerList;

          examContainers1 = examProvider.examContainers1;
          examContainers2 = examProvider.examContainers2;
          /////
          selectedDiagnosisList = questionObj!.diagnostics;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    treatmentProvider = Provider.of<TreatmentContainerProvider>(context);
    treatmentContainer =
        Provider.of<TreatmentContainerProvider>(context).treatmentContainerList;
    examProvider = Provider.of<ExamContainerProvider>(context);
    examContainers1 = examProvider.examContainers1;
    examContainers2 = examProvider.examContainers2;

    //post function
    Future<void> postQuestion(BuildContext context) async {
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
          "breed": signalmentBreedValue.text,
          "gender": signalmentSexValue,
          "sterilize": signalmentSterilizeValue,
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

      final response = await dio.put('${dotenv.env['API_PATH']}/question/$id',
          data: formData);
    }

    void showModal(BuildContext context, VoidCallback callbackFunction) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.height * 0.3,
                height: MediaQuery.of(context).size.height * 0.35,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFDFE4E0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Color(0xFF42C2FF),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        callbackFunction();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('กลับ'),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: const AppbarTeacher(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: !_isPosting
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: questionObj != null
                        ? Column(
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
                                  displayList: tagListPreDefined,
                                  hintText: 'Select tags',
                                  updateListCallback: updateTagList),
                              const H20Sizedbox(),
                              //Signalment
                              const Text(
                                'ข้อมูลทั่วไป',
                                style: kSubHeaderTextStyle,
                              ),
                              Row(
                                children: [
                                  const Text('ประเภท'),
                                  const SizedBox(width: 2),
                                  DropDownButtonInAddQ(
                                      selectedValue: signalmentTypeValue,
                                      list: signalmentTypeList,
                                      hintText: "เลือกประเภทสัตว์",
                                      onChanged: (value) {
                                        setState(() {
                                          signalmentTypeValue =
                                              value.toString();
                                        });
                                      }),
                                ],
                              ),
                              TextAndTextfield(
                                  title: "สายพันธุ์",
                                  myController: signalmentBreedValue),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text('เพศ'),
                                  const SizedBox(width: 2),
                                  DropDownButtonInAddQ(
                                      selectedValue: signalmentSexValue,
                                      list: const ['ผู้', 'เมีย'],
                                      hintText: "เลือกเพศสัตว์",
                                      onChanged: (value) {
                                        setState(() {
                                          signalmentSexValue = value!;
                                        });
                                      }),
                                ],
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 0),
                                title: const Text('ทำหมันแล้ว'),
                                leading: Checkbox(
                                  value: signalmentSterilizeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      signalmentSterilizeValue = value!;
                                    });
                                  },
                                ),
                              ),
                              TextAndTextfield(
                                  title: "อายุ",
                                  myController: signalmentAgeValue),
                              const SizedBox(
                                height: 5,
                              ),
                              TextAndTextfield(
                                  title: "น้ำหนัก",
                                  myController: signalmentWeightValue),
                              const H20Sizedbox(),
                              //Client Complain
                              TextBoxMultiLine(
                                myController: clientComplainsController,
                                hintText: "ข้อมูล Client Complains",
                                titleText: 'Client Complains',
                                maxLine: 4,
                                boxColor: const Color(0xFFDFE4E0),
                              ),
                              const H20Sizedbox(),
                              //History Taking
                              TextBoxMultiLine(
                                myController: historyTakingController,
                                hintText: "ข้อมูล History Taking",
                                titleText: "History Taking",
                                maxLine: 4,
                                boxColor: const Color(0xFFDFE4E0),
                              ),
                              const H20Sizedbox(),
                              TextBoxMultiLine(
                                myController: generalResultsController,
                                hintText: "ผลตรวจ 1, ผลตรวจ 2, ผลตรวจ 3",
                                titleText:
                                    "ผลตรวจร่างกาย [คั่นด้วยเครื่องหมาย , ]",
                                maxLine: 4,
                                boxColor: const Color(0xFFDFE4E0),
                              ),
                              const DividerWithSpace(),
                              //Answer
                              Text(
                                'เฉลย',
                                style:
                                    kSubHeaderTextStyle.copyWith(fontSize: 35),
                              ),
                              const H20Sizedbox(),
                              const Text('Problem List ครั้งที่ 1',
                                  style: kSubHeaderTextStyle),
                              ProbListMultiSelectDropDown(
                                selectedList: selectedProblemList1,
                                displayList: problemListPreDefined,
                                hintText: "เลือก Problem List ครั้งที่ 1",
                                round: 1,
                                updateListCallback: updateProbList,
                              ),
                              const H20Sizedbox(),
                              //exam1
                              ExamsButtonAndContainer(
                                  examContainers: examProvider.examContainers1,
                                  examListProvider: examProvider,
                                  round: 1),
                              const DividerWithSpace(),
                              const Text('Problem List ครั้งที่ 2',
                                  style: kSubHeaderTextStyle),
                              ProbListMultiSelectDropDown(
                                  selectedList: selectedProblemList2,
                                  displayList: problemListPreDefined,
                                  hintText: "เลือก Problem List ครั้งที่ 2",
                                  round: 2,
                                  updateListCallback: updateProbList),
                              const H20Sizedbox(),
                              //exam2
                              ExamsButtonAndContainer(
                                  examContainers: examProvider.examContainers2,
                                  examListProvider: examProvider,
                                  round: 2),
                              const DividerWithSpace(),
                              Row(
                                children: [
                                  const Text(
                                    'Treatment',
                                    style: kSubHeaderTextStyle,
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      final int currentNub =
                                          treatmentProvider.nub;
                                      treatmentProvider.addContainer(
                                        TreatmentContainer(
                                          id: currentNub.toString(),
                                          key: ObjectKey(currentNub),
                                          selectedTreatmentTopic:
                                              getTreatmentTopic().first,
                                          selectedTreatmentDetail:
                                              filterTreatment('Medical').first,
                                        ),
                                      );
                                    },
                                    child: const Text('เพิ่ม Treatment'),
                                  ),
                                ],
                              ),
                              const H20Sizedbox(),
                              treatmentContainer.isEmpty
                                  ? const SizedBox()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: treatmentContainer.length,
                                      itemBuilder: (context, index) {
                                        return treatmentContainer[index];
                                      },
                                    ),
                              const H20Sizedbox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyBackButton(myContext: context),
                                  ElevatedButton(
                                    onPressed: () {
                                      //send data
                                      postQuestion(context).then((value) {
                                        showModal(
                                            context, widget.refreshCallBack);
                                      });
                                    },
                                    child: const Text('บันทึก'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(
                            width: 10,
                            child: Center(child: CircularProgressIndicator()),
                          ),
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
