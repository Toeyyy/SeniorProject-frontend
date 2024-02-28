import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/tagSearchBox.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  String signalmentTypeValue = 'สุนัข';
  String? signalmentSexValue = 'ผู้';
  bool signalmentSterilizeStat = false;
  TextEditingController signalmentBreedValue = TextEditingController();
  TextEditingController signalmentAgeValue = TextEditingController();
  TextEditingController signalmentWeightValue = TextEditingController();
  TextEditingController clientComplainsController = TextEditingController();
  TextEditingController historyTakingController = TextEditingController();
  TextEditingController generalResultsController = TextEditingController();
  List<ProblemObject> selectedProblemList1 = [];
  List<ProblemObject> selectedProblemList2 = [];
  List<DiagnosisObject> selectedDiagnosisList = [];
  List<TagObject> selectedTags = [];

  bool _isPosting = false;

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

    /////modal//////

    void showModal(BuildContext context) {
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
                child: _isPosting
                    ? const CircularProgressIndicator(
                        color: Color(0xFF42C2FF),
                      )
                    : Column(
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

    void alertModal(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.height * 0.5,
                height: MediaQuery.of(context).size.height * 0.2,
                child: const Center(
                  child: Text(
                    'กรุณากรอกข้อมูลให้ครบ',
                    style: kSubHeaderTextStyle,
                  ),
                ),
              ),
            );
          });
    }

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
        return {"id": item.id};
      }).toList();

      try {
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

        final response = await dio.post('${dotenv.env['API_PATH']}/question',
            data: formData);
      } catch (error) {
        print('Error: $error');
      }
    }

    /////check if null///////

    bool checkNotEmpty() {
      bool tmp = clientComplainsController.text.isNotEmpty &&
          historyTakingController.text.isNotEmpty &&
          generalResultsController.text.isNotEmpty &&
          selectedProblemList1.isNotEmpty &&
          selectedProblemList2.isNotEmpty &&
          selectedDiagnosisList.isNotEmpty &&
          selectedTags.isNotEmpty &&
          signalmentAgeValue.text.isNotEmpty &&
          signalmentWeightValue.text.isNotEmpty &&
          examContainers1.isNotEmpty &&
          examContainers2.isNotEmpty &&
          (signalmentBreedValue != null) &&
          (signalmentSexValue != null);

      for (ExamContainer item in examContainers1) {
        if (item.examController.text.isEmpty) {
          tmp = false;
          break;
        }
      }
      // print('state2 = $tmp');
      for (ExamContainer item in examContainers2) {
        if (item.examController.text.isEmpty) {
          tmp = false;
          break;
        }
      }
      // print('state3 = $tmp');
      for (TreatmentContainer item in treatmentContainer) {
        if (item.selectedTreatmentDetail == '') {
          tmp = false;
          break;
        }
      }
      return tmp;
    }

    ////Update functions/////
    void updateProbList(List<ProblemObject> newList, int round) {
      // print('round = $round');
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

    //////////////////

    List<String> signalmentTypelist = ["สุนัข", "แมว", "นก"];

    return Scaffold(
      appBar: const AppbarTeacher(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: !_isPosting
                  ? Column(
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
                        const SizedBox(
                          height: 20,
                        ),
                        TagSearchBox(
                            initTags: selectedTags,
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
                                list: signalmentTypelist,
                                hintText: "เลือกประเภทสัตว์",
                                onChanged: (value) {
                                  setState(() {
                                    signalmentTypeValue = value.toString();
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
                          titleText: "ผลตรวจร่างกาย [คั่นด้วยเครื่องหมาย , ]",
                          maxLine: 4,
                          boxColor: const Color(0xFFDFE4E0),
                        ),
                        const DividerWithSpace(),
                        //Answer
                        Text(
                          'เฉลย',
                          style: kSubHeaderTextStyle.copyWith(fontSize: 35),
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
                        ExamsButtonAndContainer(
                          examContainers: examContainers1,
                          examListProvider: examListProvider,
                          round: 1,
                        ),
                        const DividerWithSpace(),
                        const Text('Problem List ครั้งที่ 2',
                            style: kSubHeaderTextStyle),
                        ProbListMultiSelectDropDown(
                          selectedList: selectedProblemList2,
                          displayList: problemListPreDefined,
                          hintText: "เลือก Problem List ครั้งที่ 2",
                          round: 2,
                          updateListCallback: updateProbList,
                        ),
                        const H20Sizedbox(),
                        ExamsButtonAndContainer(
                          examContainers: examContainers2,
                          examListProvider: examListProvider,
                          round: 2,
                        ),
                        const DividerWithSpace(),
                        const Text(
                          'Diagnosis',
                          style: kSubHeaderTextStyle,
                        ),
                        DiagnosisMultiSelectDropDown(
                            selectedList: selectedDiagnosisList,
                            displayList: diagnosisListPreDefined,
                            hintText: 'เลือก Diagnosis',
                            updateListCallback: updateDiagList),
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
                                final int currentNub = treatmentProvider.nub;
                                treatmentProvider.addContainer(
                                  TreatmentContainer(
                                    id: treatmentListPreDefined.first.id,
                                    key: ObjectKey(currentNub),
                                    selectedTreatmentTopic:
                                        getTreatmentTopic().first,
                                    selectedTreatmentDetail:
                                        filterTreatment('first').first,
                                  ),
                                );
                              },
                              child: const Text('เพิ่ม Treatment'),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B72BE),
                              ),
                              child: const Text(
                                'ยกเลิก',
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (!checkNotEmpty()) {
                                    alertModal(context);
                                  } else {
                                    setState(() {
                                      _isPosting = true;
                                    });
                                    await postQuestion(context).then((value) {
                                      setState(() {
                                        _isPosting = false;
                                      });
                                      examListProvider.clearList();
                                      showModal(context);
                                    });
                                  }
                                },
                                child: const Text('บันทึก')),
                          ],
                        )
                      ],
                    )
                  : const SizedBox(
                      width: 10,
                      child: Center(child: CircularProgressIndicator())),
            ),
          ),
        ),
      ),
    );
  }
}
