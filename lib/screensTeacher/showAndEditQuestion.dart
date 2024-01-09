import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/tagSearchBox.dart';

class ShowAndEditQuestion extends StatefulWidget {
  const ShowAndEditQuestion({super.key});

  @override
  State<ShowAndEditQuestion> createState() => _ShowAndEditQuestionState();
}

class _ShowAndEditQuestionState extends State<ShowAndEditQuestion> {
  // bool _isEditing = false;

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
                          onPressed: () {},
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
                    children: tagList
                        .map(
                          (e) => TagBox(e),
                        )
                        .toList(),
                  ),
                ),
                // TagSearchBox(
                //   initTags:
                //       tagList.map((item) => TagObject('1', item)).toList(),
                // ),
                SizedBox(height: 20),
                Text(
                  'ข้อมูลทั่วไป',
                  style: kSubHeaderTextStyle,
                ),
                Text('ชนิดสัตว์: $type', style: kNormalTextStyle),
                Text('พันธุ์: $breed', style: kNormalTextStyle),
                Text('เพศ: $sex', style: kNormalTextStyle),
                Text(sterilize == 1 ? 'ทำหมันแล้ว' : 'ยังไม่ได้ทำหมัน',
                    style: kNormalTextStyle),
                Text('อายุ: $age ปี', style: kNormalTextStyle),
                Text('น้ำหนัก: $weight Kg', style: kNormalTextStyle),
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
                DottedListView(showList: generalResult),
                const DividerWithSpace(),
                Text('เฉลย', style: kHeaderTextStyle),
                const H20Sizedbox(),
                Text('Problem List ครั้งที่ 1', style: kSubHeaderTextStyle),
                DottedListView(showList: showSelectedProb1),
                Text('ผลการส่งตรวจครั้งที่ 1', style: kSubHeaderTextStyle),
                const H20Sizedbox(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: showSelectedExamContainer1.length,
                  itemBuilder: (context, index) {
                    return showSelectedExamContainer1[index];
                  },
                ),
                const DividerWithSpace(),
                // prob&exam2
                Text('Problem List ครั้งที่ 2', style: kSubHeaderTextStyle),
                DottedListView(showList: showSelectedProb2),
                Text('ผลการส่งตรวจครั้งที่ 2', style: kSubHeaderTextStyle),
                const H20Sizedbox(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: showSelectedExamContainer2.length,
                  itemBuilder: (context, index) {
                    return showSelectedExamContainer2[index];
                  },
                ),
                const DividerWithSpace(),
                Text('Diagnosis List', style: kSubHeaderTextStyle),
                DottedListView(showList: showSelectedDiagnosis),
                const DividerWithSpace(),
                Text('Treatment', style: kSubHeaderTextStyle),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: showSelectedTreatmentContainer.length,
                    itemBuilder: (context, index) {
                      return showSelectedTreatmentContainer[index];
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
