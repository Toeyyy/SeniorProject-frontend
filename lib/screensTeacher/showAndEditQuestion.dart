import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/screensTeacher/editQuestion.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:collection/collection.dart';

class ShowAndEditQuestion extends StatefulWidget {
  const ShowAndEditQuestion({super.key});

  @override
  State<ShowAndEditQuestion> createState() => _ShowAndEditQuestionState();
}

class _ShowAndEditQuestionState extends State<ShowAndEditQuestion> {
  Map<String, List<ExaminationObject>> splitExams =
      groupBy(showSelectedExam, (obj) => obj.round);

  List<ShowExamContainer>? accessExamList(String round) {
    List<ExaminationObject>? list = splitExams[round];
    return list?.map((item) {
      return ShowExamContainer(
          department: item.type,
          exam: item.name,
          results: item.textResult,
          imagePath: item.imgResult);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'โจทย์ $quesNum',
                      style: kHeaderTextStyle.copyWith(
                          fontWeight: FontWeight.w900),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('ดูสถิติ'),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => EditQuestion(quesNum: quesNum)))
                          },
                          child: Text('แก้ไขโจทย์'),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {},
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
                  child: Row(
                    children: showTagList
                        .map(
                          (e) => TagBox(text: e.name),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'ข้อมูลทั่วไป',
                  style: kSubHeaderTextStyle,
                ),
                Text('ชนิดสัตว์: ${showSignalmentList.species}',
                    style: kNormalTextStyle),
                Text('พันธุ์: ${showSignalmentList.breed}',
                    style: kNormalTextStyle),
                Text('เพศ: ${showSignalmentList.sex}', style: kNormalTextStyle),
                Text(
                    showSignalmentList.sterilize
                        ? 'ทำหมันแล้ว'
                        : 'ยังไม่ได้ทำหมัน',
                    style: kNormalTextStyle),
                Text('อายุ: ${showSignalmentList.age}',
                    style: kNormalTextStyle),
                Text('น้ำหนัก: ${showSignalmentList.weight}',
                    style: kNormalTextStyle),
                SizedBox(height: 20),
                //Client Complains
                Text(
                  'Client Complains',
                  style: kSubHeaderTextStyle,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '$clientComp',
                    style: kNormalTextStyle,
                  ),
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
                  child: Text(
                    '$historyTaking',
                    style: kNormalTextStyle,
                  ),
                  color: Color(0xFFDFE4E0),
                  width: double.infinity,
                ),
                //General Results
                const SizedBox(height: 20),
                Text('ผลตรวจทั่วไป', style: kSubHeaderTextStyle),
                DottedListView(showList: generalResult.split(',')),
                const DividerWithSpace(),
                Text('เฉลย', style: kHeaderTextStyle),
                const H20Sizedbox(),
                Text('Problem List ครั้งที่ 1', style: kSubHeaderTextStyle),
                DottedListView(
                    showList:
                        showSelectedProb1.map((item) => item.name).toList()),
                Text('ผลการส่งตรวจครั้งที่ 1', style: kSubHeaderTextStyle),
                const H20Sizedbox(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: accessExamList('1')!.length,
                  itemBuilder: (context, index) {
                    return accessExamList('1')![index];
                  },
                ),
                const DividerWithSpace(),
                // prob&exam2
                Text('Problem List ครั้งที่ 2', style: kSubHeaderTextStyle),
                DottedListView(
                    showList:
                        showSelectedProb2.map((item) => item.name).toList()),
                Text('ผลการส่งตรวจครั้งที่ 2', style: kSubHeaderTextStyle),
                const H20Sizedbox(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: accessExamList('2')!.length,
                  itemBuilder: (context, index) {
                    return accessExamList('2')![index];
                  },
                ),
                const DividerWithSpace(),
                Text('Diagnosis List', style: kSubHeaderTextStyle),
                DottedListView(
                    showList: showSelectedDiagnosis
                        .map((item) => item.name)
                        .toList()),
                const DividerWithSpace(),
                Text('Treatment', style: kSubHeaderTextStyle),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: showTreatmentList.map((item) {
                      return ShowTreatmentContainer(
                          treatmentTopic: item.type, treatment: item.name);
                    }).length,
                    itemBuilder: (context, index) {
                      return showTreatmentList.map((item) {
                        return ShowTreatmentContainer(
                            treatmentTopic: item.type, treatment: item.name);
                      }).toList()[index];
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
