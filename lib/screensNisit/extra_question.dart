import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/components/split_screen_nisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/UIModels/nisit/selected_treatment_provider.dart';
import 'package:frontend/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensNisit/treatment_topic.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:frontend/my_secure_storage.dart';

class ExtraQuestion extends StatelessWidget {
  final QuestionObject questionObj;

  const ExtraQuestion({super.key, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);
    SelectedTreatment treatmentProvider =
        Provider.of<SelectedTreatment>(context, listen: false);

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
              TitleAndExams(
                title: 'Examination',
                showList: examProvider.examList,
                resultList: examProvider.resultList,
              ),
              TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 2',
                  showList: problemProvider.problemAnsList2
                      .map((e) => e.name)
                      .toList()),
              TitleAndDottedListView(
                  title: 'Definitive/Tentative Diagnosis',
                  showList:
                      diagProvider.tenDiagList.map((e) => e.name).toList()),
              TitleAndDottedListView(
                  title: 'Treatment',
                  showList: treatmentProvider.treatmentList
                      .map((e) => e.name)
                      .toList()),
            ],
          ),
        ),
        rightPart: RightPartExtraQues(
            quesId: questionObj.id, questionObj: questionObj),
      ),
    );
  }
}

class RightPartExtraQues extends StatefulWidget {
  final String quesId;
  QuestionObject questionObj;

  RightPartExtraQues(
      {super.key, required this.quesId, required this.questionObj});

  @override
  State<RightPartExtraQues> createState() => _RightPartExtraQuesState();
}

class _RightPartExtraQuesState extends State<RightPartExtraQues> {
  TextEditingController answerController = TextEditingController();
  bool _isSendingData = false;

  @override
  Widget build(BuildContext context) {
    SelectedTreatment treatmentProvider =
        Provider.of<SelectedTreatment>(context);
    SelectedDiagnosis diagProvider =
        Provider.of<SelectedDiagnosis>(context, listen: false);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);

    Future<void> postStat(BuildContext context) async {
      //prob List
      var probList1 = problemProvider.problemList1.map((item) {
        return {"id": item.id, "round": item.round};
      }).toList();
      var probList2 = problemProvider.problemList2.map((item) {
        return {"id": item.id, "round": item.round};
      }).toList();
      probList1.addAll(probList2);

      //exams
      var exam = examProvider.examList.map((item) {
        return {"id": item.id};
      }).toList();

      //treatment
      var treatment = treatmentProvider.treatmentList.map((item) {
        return {"id": item.id};
      }).toList();

      //diag
      var diag = diagProvider.diffDiagList.map((item) {
        return {"id": item.id};
      }).toList();
      var tenDiag = diagProvider.tenDiagList.map((item) {
        return {"id": item.id};
      }).toList();
      diag.addAll(tenDiag);

      Map<String, dynamic> data = {
        "problems": probList1,
        "examinations": exam,
        "treatments": treatment,
        "diagnostics": diag,
        "extraAns": answerController.text,
        "heartProblem1": problemProvider.heart1,
        "heartProblem2": problemProvider.heart2,
      };

      final String apiUrl =
          "${dotenv.env['API_PATH']}/student/${widget.quesId}/stats";
      await MySecureStorage().refreshToken();
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer ${await MySecureStorage().readSecureData('accessToken')}",
          },
          body: jsonEncode(data),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (kDebugMode) {
            print("Success");
          }
        } else {
          if (kDebugMode) {
            print("Error: ${response.statusCode}");
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print("Error: $error");
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: !_isSendingData
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      widget.questionObj.extraQues!,
                      style: kSubHeaderTextStyleInLeftPart,
                    ),
                    const H20SizedBox(),
                    Container(
                      color: const Color(0xFFDFE4E0),
                      child: TextField(
                        controller: answerController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSendingData = true;
                    });
                    //post answer//
                    await postStat(context).then((value) {
                      setState(() {
                        _isSendingData = false;
                      });
                      //clear data//
                      treatmentProvider.clearList();
                      problemProvider.clearList();
                      examProvider.clearList();
                      diagProvider.clearList();
                      context.goNamed('returnPoint',
                          queryParameters: {"id": widget.quesId});
                    });
                  },
                  child: const Text('ส่งคำตอบ'),
                ),
              ],
            )
          : const SizedBox(
              width: 10,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF42C2FF),
                ),
              ),
            ),
    );
  }
}
