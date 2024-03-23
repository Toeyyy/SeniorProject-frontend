import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/signalmentObject.dart';
import 'package:frontend/screensTeacher/editQuestion.dart';
import 'package:frontend/components/tag_box.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:collection/collection.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/showStatOverall.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/my_secure_storage.dart';

class ShowAndEditQuestion extends StatefulWidget {
  String quesId;

  ShowAndEditQuestion({super.key, required this.quesId});

  @override
  State<ShowAndEditQuestion> createState() => _ShowAndEditQuestionState();
}

class _ShowAndEditQuestionState extends State<ShowAndEditQuestion> {
  bool initialized = false;

  late FullQuestionObject? questionObj = FullQuestionObject(
      id: 'X',
      name: 'X',
      clientComplains: "",
      historyTakingInfo: "",
      generalInfo: "generalInfo",
      tags: [],
      signalment: SignalmentObject(
          species: "",
          breed: "",
          sterilize: false,
          age: "",
          gender: "",
          weight: ""),
      problems: [],
      treatments: [],
      diagnostics: [],
      examinations: [],
      modified: true,
      status: 0,
      logs: []);
  late Map<String, List<ProblemObject>> splitProblems = {};
  late Map<String, List<DiagnosisObject>> splitDiagnosis = {};
  bool _loadData = true;

  List<ShowExamContainer>? accessExamList() {
    return questionObj!.examinations?.map((item) {
      return ShowExamContainer(
          lab: item.type,
          type: item.type,
          area: item.area,
          name: item.name,
          results: item.textResult,
          imagePath: item.imgPath);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      _loadData = true;
    });
    var loadedData = await fetchFullQuestionFromId(widget.quesId);
    setState(() {
      questionObj = loadedData;
      if (questionObj != null) {
        splitProblems = questionObj!.problems != []
            ? groupBy(questionObj!.problems!, (e) => e.round.toString())
            : {};
        splitDiagnosis = questionObj!.diagnostics != []
            ? groupBy(questionObj!.diagnostics!, (e) => e.type)
            : {};
      }
      _loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> deleteQuestion() async {
      await MySecureStorage().refreshToken();
      try {
        final http.Response response = await http.delete(
          Uri.parse("${dotenv.env['API_PATH']}/question/${questionObj!.id}"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
          },
        );
      } catch (error) {
        print('Error: $error');
      }
    }

    void deleteModal(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFBBF5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('ยืนยันการลบโจทย์',
                        style: kTableHeaderTextStyle),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyCancelButton(myContext: context),
                        const SizedBox(width: 30),
                        ElevatedButton(
                            onPressed: () {
                              deleteQuestion().then((value) {
                                context.go('/mainShowQuestion');
                              });
                            },
                            child: const Text('ยืนยัน')),
                      ],
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
        child: Center(
          child: !_loadData
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: (questionObj != null)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'โจทย์ ${questionObj?.name ?? '0'}',
                                  style: kHeaderTextStyle.copyWith(
                                      fontWeight: FontWeight.w900),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        //go to stat
                                        context.goNamed(
                                          'statOverall',
                                          queryParameters: {
                                            "id": questionObj!.id
                                          },
                                        );
                                      },
                                      child: const Text('ดูสถิติ'),
                                    ),
                                    const SizedBox(width: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.goNamed(
                                          'editQuestion',
                                          queryParameters: {
                                            "id": questionObj!.id
                                          },
                                        );
                                      },
                                      child: const Text('แก้ไขโจทย์'),
                                    ),
                                    const SizedBox(width: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                        //delete ques
                                        deleteModal(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF8B72BE),
                                      ),
                                      child: const Text('ลบโจทย์'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: (questionObj!.tags != [])
                                  ? Row(
                                      children: questionObj!.tags!
                                          .map(
                                            (e) => TagBox(text: e.name),
                                          )
                                          .toList(),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'ข้อมูลทั่วไป',
                              style: kSubHeaderTextStyle,
                            ),
                            Text(
                                'ชนิดสัตว์: ${questionObj?.signalment?.species ?? 'สุนัข'}',
                                style: kNormalTextStyle),
                            Text(
                                'พันธุ์: ${questionObj?.signalment?.breed ?? 'Chihuahua'}',
                                style: kNormalTextStyle),
                            Text(
                                'เพศ: ${questionObj?.signalment?.gender ?? 'ผู้'}',
                                style: kNormalTextStyle),
                            Text(
                                questionObj!.signalment!.sterilize
                                    ? 'ทำหมันแล้ว'
                                    : 'ยังไม่ได้ทำหมัน',
                                style: kNormalTextStyle),
                            Text('อายุ: ${questionObj?.signalment?.age ?? '0'}',
                                style: kNormalTextStyle),
                            Text(
                                'น้ำหนัก: ${questionObj?.signalment?.weight ?? '0'}',
                                style: kNormalTextStyle),
                            const SizedBox(height: 20),
                            //Client Complains
                            const Text(
                              'Client Complains',
                              style: kSubHeaderTextStyle,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xFFDFE4E0),
                              width: double.infinity,
                              child: Text(
                                questionObj?.clientComplains ?? "",
                                style: kNormalTextStyle,
                              ),
                            ),
                            const SizedBox(height: 20),
                            //History Taking
                            const Text(
                              'History Taking',
                              style: kSubHeaderTextStyle,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xFFDFE4E0),
                              width: double.infinity,
                              child: Text(
                                questionObj?.historyTakingInfo ?? "",
                                style: kNormalTextStyle,
                              ),
                            ),
                            //General Results
                            const SizedBox(height: 20),
                            const Text('ผลตรวจทั่วไป',
                                style: kSubHeaderTextStyle),
                            DottedListView(
                                showList: questionObj?.generalInfo
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList() ??
                                    []),
                            const DividerWithSpace(),
                            const Text('เฉลย', style: kHeaderTextStyle),
                            const H20Sizedbox(),
                            const Text('Problem List ครั้งที่ 1',
                                style: kSubHeaderTextStyle),
                            DottedListView(showList: const []),
                            (splitProblems != {} && questionObj?.problems != [])
                                ? DottedListView(
                                    showList: splitProblems.containsKey('1')
                                        ? splitProblems['1']!
                                            .map((item) => item.name)
                                            .toList()
                                        : [])
                                : const SizedBox(),
                            const H20Sizedbox(),
                            const Text('Differential Diagnosis',
                                style: kSubHeaderTextStyle),
                            DottedListView(
                                showList:
                                    splitDiagnosis.containsKey('differential')
                                        ? splitDiagnosis['differential']!
                                            .map((item) => item.name)
                                            .toList()
                                        : []),
                            const H20Sizedbox(),
                            const Text('ผลการส่งตรวจ',
                                style: kSubHeaderTextStyle),
                            const H20Sizedbox(),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: accessExamList()?.length,
                              itemBuilder: (context, index) {
                                return accessExamList()?[index];
                              },
                            ),
                            const H20Sizedbox(),
                            //prob2
                            const Text('Problem List ครั้งที่ 2',
                                style: kSubHeaderTextStyle),
                            DottedListView(
                                showList: splitProblems.containsKey('2')
                                    ? splitProblems['2']!
                                        .map((item) => item.name)
                                        .toList()
                                    : []),
                            const H20Sizedbox(),
                            const Text('Definitive/Tentative Diagnosis',
                                style: kSubHeaderTextStyle),
                            DottedListView(
                                showList:
                                    splitDiagnosis.containsKey('tentative')
                                        ? splitDiagnosis['tentative']!
                                            .map((item) => item.name)
                                            .toList()
                                        : []),
                            const H20Sizedbox(),
                            const Text('Treatment', style: kSubHeaderTextStyle),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: questionObj?.treatments!.map((item) {
                                  return ShowTreatmentContainer(
                                      treatmentTopic: item.type,
                                      treatment: item.name);
                                }).length,
                                itemBuilder: (context, index) {
                                  return questionObj?.treatments!.map((item) {
                                    return ShowTreatmentContainer(
                                        treatmentTopic: item.type,
                                        treatment: item.name);
                                  }).toList()[index];
                                }),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.go('/mainShowQuestion');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B72BE),
                                ),
                                child: const Text(
                                  'กลับ',
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(
                          width: 10,
                          child: Center(child: CircularProgressIndicator())),
                )
              : const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator()),
                ),
        ),
      ),
    );
  }
}
