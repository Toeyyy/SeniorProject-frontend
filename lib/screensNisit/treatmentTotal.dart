import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/UIModels/nisit/selected_treatment_provider.dart';
import 'package:frontend/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/my_secure_storage.dart';

class TreatmentTotal extends StatelessWidget {
  QuestionObject questionObj;

  TreatmentTotal({super.key, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);
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
            ],
          ),
        ),
        rightPart: RightPart_TreatmentTotal(
          quesId: questionObj.id,
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPart_TreatmentTotal extends StatefulWidget {
  String quesId;
  QuestionObject questionObj;
  RightPart_TreatmentTotal(
      {super.key, required this.quesId, required this.questionObj});

  @override
  State<RightPart_TreatmentTotal> createState() =>
      _RightPart_TreatmentTotalState();
}

class _RightPart_TreatmentTotalState extends State<RightPart_TreatmentTotal> {
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
          print("Success: ${response.body}");
        } else {
          print("Error: ${response.statusCode} - ${response.body}");
        }
      } catch (error) {
        print("Error: $error");
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: !_isSendingData
          ? Column(
              children: [
                const Text(
                  "Treatment ที่เลือก",
                  style: kHeaderTextStyle,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: treatmentProvider.treatmentList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.circle, size: 15),
                        title:
                            Text(treatmentProvider.treatmentList[index].name),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TreatmentTopic(
                              questionObj: widget.questionObj,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B72BE),
                      ),
                      child: const Text('เลือก Treatment'),
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
