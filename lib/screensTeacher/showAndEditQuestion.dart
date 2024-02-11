import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/signalmentObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/screensTeacher/editQuestion.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:collection/collection.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/components/backButton.dart';

class ShowAndEditQuestion extends StatefulWidget {
  FullQuestionObject questionObj;

  ShowAndEditQuestion({super.key, required this.questionObj});

  @override
  State<ShowAndEditQuestion> createState() => _ShowAndEditQuestionState();
}

class _ShowAndEditQuestionState extends State<ShowAndEditQuestion> {
  bool initialized = false;

  late FullQuestionObject? questionObj = null;
  late Map<String, List<ExaminationObject>> splitExams = {};
  late Map<String, List<ProblemObject>> splitProblems = {};

  List<ShowExamContainer>? accessExamList(String round) {
    List<ExaminationObject>? list = splitExams[round];
    return list?.map((item) {
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
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        questionObj = widget.questionObj;
        if (questionObj != null) {
          splitExams =
              groupBy(questionObj!.examinations, (obj) => obj.round.toString());
          splitProblems =
              groupBy(questionObj!.problems, (e) => e.round.toString());
        }
      });
    });
  }

  // Future<void> initializeData() async {
  //   if (!initialized) {
  //     questionObj = widget.questionObj;
  //     splitExams =
  //         groupBy(questionObj.examinations, (obj) => obj.round.toString());
  //     splitProblems = groupBy(questionObj.problems, (e) => e.round.toString());
  //
  //     setState(() {
  //       initialized = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // questionObj = widget.questionObj;
    // splitExams =
    //     groupBy(questionObj!.examinations, (obj) => obj.round.toString());
    // splitProblems = groupBy(questionObj!.problems, (e) => e.round.toString());
    // void printSTH() {
    //   print(splitExams['1']);
    //   print(splitExams['2']);
    // }
    // ElevatedButton(
    //     onPressed: () {
    //       printSTH();
    //     },
    //     child: Text('กด')),

    return Scaffold(
      appBar: AppbarTeacher(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            width: MediaQuery.of(context).size.width * 0.7,
            child: questionObj != null
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
                                  //TODO stat
                                },
                                child: Text('ดูสถิติ'),
                              ),
                              SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditQuestion(
                                          questionObj: questionObj!),
                                    ),
                                  );
                                },
                                child: Text('แก้ไขโจทย์'),
                              ),
                              SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () {
                                  //delete ques
                                },
                                child: Text('ลบโจทย์'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF8B72BE),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: questionObj != null
                            ? Row(
                                children: questionObj!.tags
                                    .map(
                                      (e) => TagBox(text: e.name),
                                    )
                                    .toList(),
                              )
                            : null,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'ข้อมูลทั่วไป',
                        style: kSubHeaderTextStyle,
                      ),
                      Text(
                          'ชนิดสัตว์: ${questionObj?.signalment.species ?? 'สุนัข'}',
                          style: kNormalTextStyle),
                      Text(
                          'พันธุ์: ${questionObj?.signalment.breed ?? 'Chihuahua'}',
                          style: kNormalTextStyle),
                      Text('เพศ: ${questionObj?.signalment.gender ?? 'ผู้'}',
                          style: kNormalTextStyle),
                      Text(
                          questionObj != null
                              ? questionObj!.signalment.sterilize
                                  ? 'ทำหมันแล้ว'
                                  : 'ยังไม่ได้ทำหมัน'
                              : 'ยังไม่ได้ทำหมัน',
                          style: kNormalTextStyle),
                      Text('อายุ: ${questionObj?.signalment.age ?? '0'}',
                          style: kNormalTextStyle),
                      Text('น้ำหนัก: ${questionObj?.signalment.weight ?? '0'}',
                          style: kNormalTextStyle),
                      SizedBox(height: 20),
                      //Client Complains
                      Text(
                        'Client Complains',
                        style: kSubHeaderTextStyle,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: questionObj != null
                            ? Text(
                                questionObj!.clientComplains,
                                style: kNormalTextStyle,
                              )
                            : Text(''),
                        color: Color(0xFFDFE4E0),
                        width: double.infinity,
                      ),
                      SizedBox(height: 20),
                      //History Taking
                      Text(
                        'History Taking',
                        style: kSubHeaderTextStyle,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: questionObj != null
                            ? Text(
                                questionObj!.historyTakingInfo,
                                style: kNormalTextStyle,
                              )
                            : null,
                        color: Color(0xFFDFE4E0),
                        width: double.infinity,
                      ),
                      //General Results
                      const SizedBox(height: 20),
                      Text('ผลตรวจทั่วไป', style: kSubHeaderTextStyle),
                      DottedListView(
                          showList: questionObj?.generalInfo.split(',') ?? []),
                      const DividerWithSpace(),
                      Text('เฉลย', style: kHeaderTextStyle),
                      const H20Sizedbox(),
                      Text('Problem List ครั้งที่ 1',
                          style: kSubHeaderTextStyle),
                      DottedListView(
                          showList: questionObj != null
                              ? splitProblems['1']!
                                  .map((item) => item.name)
                                  .toList()
                              : []),
                      Text('ผลการส่งตรวจครั้งที่ 1',
                          style: kSubHeaderTextStyle),
                      const H20Sizedbox(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: accessExamList('1')?.length,
                        itemBuilder: (context, index) {
                          return accessExamList('1')?[index];
                        },
                      ),
                      const DividerWithSpace(),
                      //prob&exam2
                      Text('Problem List ครั้งที่ 2',
                          style: kSubHeaderTextStyle),
                      DottedListView(
                          showList: questionObj != null
                              ? splitProblems['2']!
                                  .map((item) => item.name)
                                  .toList()
                              : []),
                      Text('ผลการส่งตรวจครั้งที่ 2',
                          style: kSubHeaderTextStyle),
                      const H20Sizedbox(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: accessExamList('2')?.length,
                        itemBuilder: (context, index) {
                          return accessExamList('2')![index];
                        },
                      ),
                      const DividerWithSpace(),
                      Text('Diagnosis List', style: kSubHeaderTextStyle),
                      DottedListView(
                          showList: questionObj?.diagnostics
                                  .map((item) => item.name)
                                  .toList() ??
                              []),
                      const DividerWithSpace(),
                      Text('Treatment', style: kSubHeaderTextStyle),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: questionObj?.treatments.map((item) {
                            return ShowTreatmentContainer(
                                treatmentTopic: item.type,
                                treatment: item.name);
                          }).length,
                          itemBuilder: (context, index) {
                            return questionObj?.treatments.map((item) {
                              return ShowTreatmentContainer(
                                  treatmentTopic: item.type,
                                  treatment: item.name);
                            }).toList()[index];
                          }),
                      Center(child: MyBackButton(myContext: context)),
                    ],
                  )
                : SizedBox(
                    width: 10,
                    child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }
}
