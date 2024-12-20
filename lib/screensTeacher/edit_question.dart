import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/components/tag_search_box.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:frontend/models/tag_object.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/UIModels/teacher/treatment_container_provider.dart';
import 'package:frontend/components/treatment_container.dart';
import 'package:frontend/UIModels/teacher/exam_container_provider.dart';
import 'package:frontend/components/back_button.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:frontend/components/exam_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/models/full_question_object.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/my_secure_storage.dart';

class EditQuestion extends StatefulWidget {
  final String quesId;

  const EditQuestion({super.key, required this.quesId});

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  late FullQuestionObject? questionObj;
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
  late TextEditingController extraQuesController =
      TextEditingController(text: 'N/A');
  late Map<String, List<ProblemObject>> splitProblems = {};
  late List<ProblemObject> selectedProblemList1 = [];
  late List<ProblemObject> selectedProblemList2 = [];
  late Map<String, List<DiagnosisObject>> splitDiagnosis = {};
  late List<DiagnosisObject> selectedDiffDiag = [];
  late List<DiagnosisObject> selectedTentativeDiag = [];
  late List<TagObject> selectedTags = [];

  late TreatmentContainerProvider treatmentProvider;
  late List<TreatmentContainer> treatmentContainer = [];

  late ExamContainerProvider examProvider;
  late List<ExamContainer> examContainers = [];

  List<String> signalmentTypeList = ["สุนัข", "แมว", "นก"];

  bool _isPosting = false;
  bool _isLoadData = true;

  //Update List/////
  void updateProbList(List<ProblemObject> newList, int round) {
    if (round == 1) {
      selectedProblemList1 = newList;
    } else {
      selectedProblemList2 = newList;
    }
  }

  void updateDiagList(List<DiagnosisObject> newList, String type) {
    if (type == 'differential') {
      selectedDiffDiag = newList;
    } else {
      selectedTentativeDiag = newList;
    }
  }

  void updateTagList(List<TagObject> newList) {
    selectedTags = newList;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      _isLoadData = true;
    });
    var loadedData = await fetchFullQuestionFromId(widget.quesId);
    await fetchPreDefined();
    setState(() {
      questionObj = loadedData;
      if (questionObj != null) {
        id = questionObj!.id;
        name = questionObj!.name;
        signalmentTypeValue = questionObj!.signalment?.species == ''
            ? 'สุนัข'
            : questionObj!.signalment!.species;
        signalmentBreedValue.text = questionObj!.signalment?.breed ?? '';
        signalmentSterilizeValue = questionObj!.signalment?.sterilize ?? false;
        signalmentSexValue = questionObj!.signalment?.gender == ''
            ? 'ผู้'
            : questionObj!.signalment!.gender;
        signalmentAgeValue.text = questionObj!.signalment?.age ?? '';
        signalmentWeightValue.text = questionObj!.signalment?.weight ?? '';
        clientComplainsController.text = questionObj!.clientComplains;
        historyTakingController.text = questionObj!.historyTakingInfo;
        generalResultsController.text = questionObj!.generalInfo;
        selectedTags = questionObj!.tags ?? [];
        extraQuesController.text = questionObj!.extraQues ?? "";
        /////
        splitProblems = questionObj!.problems != []
            ? groupBy(questionObj!.problems!, (e) => e.round.toString())
            : {};
        selectedProblemList1 = splitProblems.containsKey('1')
            ? splitProblems['1']!
                .map(
                  (e) => ProblemObject(id: e.id, name: e.name),
                )
                .toList()
            : [];
        selectedProblemList2 = splitProblems.containsKey('2')
            ? splitProblems['2']!
                .map(
                  (e) => ProblemObject(id: e.id, name: e.name),
                )
                .toList()
            : [];
        /////
        splitDiagnosis = questionObj!.diagnostics != []
            ? groupBy(questionObj!.diagnostics!, (e) => e.type)
            : {};
        selectedDiffDiag = splitDiagnosis.containsKey('differential')
            ? splitDiagnosis['differential']!
            : [];
        selectedTentativeDiag = splitDiagnosis.containsKey('tentative')
            ? splitDiagnosis['tentative']!
            : [];
        /////
        treatmentProvider =
            Provider.of<TreatmentContainerProvider>(context, listen: false);
        examProvider =
            Provider.of<ExamContainerProvider>(context, listen: false);
        Provider.of<TreatmentContainerProvider>(context, listen: false)
            .getInfo(questionObj!.treatments ?? []);
        Provider.of<ExamContainerProvider>(context, listen: false)
            .getInfo(questionObj!.examinations ?? []);

        treatmentContainer = treatmentProvider.treatmentContainerList;
        examContainers = examProvider.examContainers;

        _isLoadData = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    treatmentProvider = Provider.of<TreatmentContainerProvider>(context);
    treatmentContainer =
        Provider.of<TreatmentContainerProvider>(context).treatmentContainerList;
    examProvider = Provider.of<ExamContainerProvider>(context);
    examContainers = examProvider.examContainers;

    //modal
    void successModal() {
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
                        treatmentProvider.clearList();
                        examProvider.clearList();
                        context.go('/mainShowQuestion');
                      },
                      child: const Text('กลับ'),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    void popFunction() {
      Navigator.pop(context);
    }

    void failModal() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFDFE4E0),
                ),
                child: _isPosting
                    ? const CircularProgressIndicator(
                        color: Color(0xFF42C2FF),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'แก้ไขโจทย์ไม่สำเร็จ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoadData = true;
                              });
                              await fetchPreDefined();
                              setState(() {
                                _isLoadData = false;
                              });
                              popFunction();
                            },
                            child: const Text('ยืนยัน'),
                          ),
                        ],
                      ),
              ),
            );
          });
    }

    //post function
    Future<void> postQuestion(
        BuildContext context, int status, bool newVer) async {
      try {
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
        var diagnosis = selectedDiffDiag.map((item) {
          return {"id": item.id};
        }).toList();
        var tentative = selectedTentativeDiag.map((item) {
          return {"id": item.id};
        }).toList();
        diagnosis.addAll(tentative);

        //exams
        var exam = examContainers.map((item) {
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
          };
        }).toList();

        //tags
        var tag = selectedTags.map((item) {
          return {"id": item.id, "name": item.name};
        }).toList();

        FormData formData = FormData.fromMap({
          "clientComplains": clientComplainsController.text,
          "historyTakingInfo": historyTakingController.text,
          "generalInfo": generalResultsController.text,
          "problems": probList1,
          "examinations": exam,
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
          },
          "status": status,
          "extraQues": extraQuesController.text.isEmpty
              ? null
              : extraQuesController.text,
          "newVersion": newVer,
        }, ListFormat.multiCompatible);
        var index = 0;
        for (var item in examContainers) {
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

        await MySecureStorage().refreshToken();
        final response = await dio.put(
          '${dotenv.env['API_PATH']}/question/$id',
          data: formData,
          options: Options(
            headers: {
              "Authorization":
                  "Bearer ${await MySecureStorage().readSecureData('accessToken')}",
            },
          ),
        );
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          if (kDebugMode) {
            print("Success");
          }
          successModal();
        } else {
          if (kDebugMode) {
            print('Error - ${response.statusCode}');
          }
          failModal();
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error');
        }
        failModal();
      }
    }

    bool checkNotEmpty() {
      bool tmp = clientComplainsController.text.isNotEmpty &&
          historyTakingController.text.isNotEmpty &&
          generalResultsController.text.isNotEmpty &&
          selectedProblemList1.isNotEmpty &&
          selectedProblemList2.isNotEmpty &&
          selectedDiffDiag.isNotEmpty &&
          selectedTentativeDiag.isNotEmpty &&
          selectedTags.isNotEmpty &&
          signalmentAgeValue.text.isNotEmpty &&
          signalmentWeightValue.text.isNotEmpty &&
          examContainers.isNotEmpty &&
          signalmentBreedValue != null &&
          signalmentSexValue != null &&
          treatmentContainer.isNotEmpty;

      for (TreatmentContainer item in treatmentContainer) {
        if (item.selectedTreatmentDetail == '') {
          tmp = false;
          break;
        }
      }
      return tmp;
    }

    return Scaffold(
      appBar: const AppbarTeacher(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: !_isLoadData
              ? Center(
                  child: !_isPosting
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
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
                                    const H20SizedBox(),
                                    TagMultiSelectDropDown(
                                        selectedList: selectedTags,
                                        displayList: tagListPreDefined,
                                        hintText: 'Select tags',
                                        updateListCallback: updateTagList),
                                    const H20SizedBox(),
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
                                    TextAndTextField(
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
                                      contentPadding:
                                          const EdgeInsets.only(left: 0),
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
                                    TextAndTextField(
                                        title: "อายุ",
                                        myController: signalmentAgeValue),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextAndTextField(
                                        title: "น้ำหนัก",
                                        myController: signalmentWeightValue),
                                    const H20SizedBox(),
                                    //Client Complain
                                    TextBoxMultiLine(
                                      myController: clientComplainsController,
                                      hintText: "ข้อมูล Client Complains",
                                      titleText: 'Client Complains',
                                      maxLine: 4,
                                      boxColor: const Color(0xFFDFE4E0),
                                    ),
                                    const H20SizedBox(),
                                    //History Taking
                                    TextBoxMultiLine(
                                      myController: historyTakingController,
                                      hintText: "ข้อมูล History Taking",
                                      titleText: "History Taking",
                                      maxLine: 4,
                                      boxColor: const Color(0xFFDFE4E0),
                                    ),
                                    const H20SizedBox(),
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
                                      style: kSubHeaderTextStyle.copyWith(
                                          fontSize: 35),
                                    ),
                                    const H20SizedBox(),
                                    const Text('Problem List ครั้งที่ 1',
                                        style: kSubHeaderTextStyle),
                                    ProbListMultiSelectDropDown(
                                      selectedList: selectedProblemList1,
                                      displayList: problemListPreDefined,
                                      hintText: "เลือก Problem List ครั้งที่ 1",
                                      round: 1,
                                      updateListCallback: updateProbList,
                                    ),
                                    const H20SizedBox(),
                                    //diff diag
                                    const Text('Differential Diagnosis',
                                        style: kSubHeaderTextStyle),
                                    DiagnosisMultiSelectDropDown(
                                        selectedList: selectedDiffDiag,
                                        displayList: diagnosisListPreDefined,
                                        type: 'differential',
                                        hintText:
                                            "เลือก Differential Diagnosis",
                                        updateListCallback: updateDiagList),
                                    const H20SizedBox(),
                                    //exam
                                    ExamsButtonAndContainer(
                                        examContainers:
                                            examProvider.examContainers,
                                        examListProvider: examProvider),
                                    const H20SizedBox(),
                                    //prob2
                                    const Text('Problem List ครั้งที่ 2',
                                        style: kSubHeaderTextStyle),
                                    ProbListMultiSelectDropDown(
                                        selectedList: selectedProblemList2,
                                        displayList: problemListPreDefined,
                                        hintText:
                                            "เลือก Problem List ครั้งที่ 2",
                                        round: 2,
                                        updateListCallback: updateProbList),
                                    const H20SizedBox(),
                                    //tentative diag
                                    const Text('Definitive/Tentative Diagnosis',
                                        style: kSubHeaderTextStyle),
                                    DiagnosisMultiSelectDropDown(
                                        selectedList: selectedTentativeDiag,
                                        displayList: diagnosisListPreDefined,
                                        type: 'tentative',
                                        hintText:
                                            "เลือก Definitive/Tentative Diagnosis",
                                        updateListCallback: updateDiagList),
                                    const H20SizedBox(),
                                    //treatment
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
                                                id: filterTreatment('firstID')
                                                    .first,
                                                key: ObjectKey(currentNub),
                                                selectedTreatmentTopic:
                                                    getTreatmentTopic().first,
                                                selectedTreatmentDetail:
                                                    filterTreatment('first')
                                                        .first,
                                              ),
                                            );
                                          },
                                          child: const Text('เพิ่ม Treatment'),
                                        ),
                                      ],
                                    ),
                                    const H20SizedBox(),
                                    treatmentContainer.isEmpty
                                        ? const SizedBox()
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                treatmentContainer.length,
                                            itemBuilder: (context, index) {
                                              return treatmentContainer[index];
                                            },
                                          ),
                                    const H20SizedBox(),
                                    //extra question
                                    TextBoxMultiLine(
                                      myController: extraQuesController,
                                      hintText: "คำถามเพิ่มเติม",
                                      titleText: "คำถามเพิ่มเติม [Optional]",
                                      maxLine: 3,
                                      boxColor: const Color(0xFFDFE4E0),
                                    ),
                                    const H20SizedBox(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyCancelButton(myContext: context),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                //draft
                                                setState(() {
                                                  _isPosting = true;
                                                });
                                                await postQuestion(
                                                        context, 0, false)
                                                    .then((value) {
                                                  setState(() {
                                                    _isPosting = false;
                                                  });
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFA0E9FF),
                                              ),
                                              child: const Text(
                                                'Save as draft',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () async {
                                                //send data
                                                if (!checkNotEmpty()) {
                                                  alertModal(context);
                                                } else {
                                                  setState(() {
                                                    _isPosting = true;
                                                  });
                                                  await postQuestion(
                                                          context, 1, false)
                                                      .then((value) {
                                                    setState(() {
                                                      _isPosting = false;
                                                    });
                                                  });
                                                }
                                              },
                                              child: const Text(
                                                  'Overwrite current version'),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () async {
                                                //send data
                                                if (!checkNotEmpty()) {
                                                  alertModal(context);
                                                } else {
                                                  setState(() {
                                                    _isPosting = true;
                                                  });
                                                  await postQuestion(
                                                          context, 1, true)
                                                      .then((value) {
                                                    setState(() {
                                                      _isPosting = false;
                                                    });
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF3DABF5),
                                              ),
                                              child: const Text(
                                                  'Save as new version'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                        )
                      : const SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(child: CircularProgressIndicator())),
                )
              : const Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}
