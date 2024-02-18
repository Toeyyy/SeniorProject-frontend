import 'package:flutter/material.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/screensNisit/problemList.dart';
import 'package:frontend/screensTeacher/showAndEditQuestion.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/UIModels/nisit/selected_treatment_provider.dart';

class QuestionCard extends StatelessWidget {
  final QuestionObject questionObj;
  int role;

  QuestionCard({required this.questionObj, required this.role});

  void _showModal(BuildContext context) {
    SelectedProblem problemProvider = Provider.of(context, listen: false);
    SelectedDiagnosis diagProvider = Provider.of(context, listen: false);
    SelectedExam examProvider = Provider.of(context, listen: false);
    SelectedTreatment treatmentProvider = Provider.of(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Color(0xFFBBF5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            color: Color(0xFFE7F9FF),
                            child: Text(
                              'โจทย์ ${questionObj.name}',
                              style: kSubHeaderTextStyle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: questionObj.tags
                                  .map(
                                    (e) => TagBox(text: e.name, textSize: 20),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'สายพันธุ์: ${questionObj.signalment.breed}, อายุ: ${questionObj.signalment.age}, น้ำหนัก: ${questionObj.signalment.weight}',
                    style: kNormalTextStyle,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Client Complains',
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 50,
                    color: Color(0xFFE7F9FF),
                    child: Text(questionObj.clientComplains, maxLines: 2),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'History Taking',
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 50,
                    color: Color(0xFFE7F9FF),
                    child: Text(questionObj.historyTakingInfo, maxLines: 2),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          problemProvider.clearList();
                          examProvider.clearList();
                          treatmentProvider.clearList();
                          diagProvider.clearList();
                          //go to prob list page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProbList(
                                round: 1,
                                questionObj: questionObj,
                              ),
                            ),
                          );
                        },
                        child: Text('ยืนยัน'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModal(context);
      },
      child: Column(
        children: [
          Card(
            elevation: 5,
            color: Color(0xFFA0E9FF),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'รหัสโจทย์: ${questionObj.name}',
                    style: kSubHeaderTextStyle,
                  ),
                  Text(
                      'ชนิดสัตว์: ${questionObj.signalment.species}, พันธุ์: ${questionObj.signalment.breed}',
                      style: kNormalTextStyle),
                  SizedBox(height: 5),
                  Container(
                    child: Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      children: questionObj.tags
                          .map(
                            (e) => TagBox(text: e.name),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ElevatedButton(
// onPressed: () {
// //go to showQues
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => ShowAndEditQuestion(
// questionObj: questionObj),
// ),
// );
// },
// child: Text('ดูโจทย์'),
// ),
