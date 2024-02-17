import 'package:flutter/material.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/questionObject.dart';

class SplitScreenNisit extends StatelessWidget {
  Widget leftPart;
  Widget rightPart;

  SplitScreenNisit({required this.leftPart, required this.rightPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: leftPart,
          ),
        ),
        VerticalDivider(
          indent: 50,
          endIndent: 50,
        ),
        Expanded(
          child: Container(
            child: rightPart,
          ),
        ),
      ],
    );
  }
}

class LeftPartContent extends StatelessWidget {
  QuestionObject questionObj;
  Widget? addedContent;

  LeftPartContent({required this.questionObj, this.addedContent});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // General Information
                Text(
                  'รหัสโจทย์: ${questionObj.name}',
                  style: kSubHeaderTextStyle,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: questionObj.tags
                        .map(
                          (e) => TagBox(text: e.name),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'ข้อมูลทั่วไป',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            Text('ชนิดสัตว์: ${questionObj.signalment.species}'),
            Text('พันธุ์: ${questionObj.signalment.breed}'),
            Text('เพศ: ${questionObj.signalment.gender}'),
            Text(questionObj.signalment.sterilize == true
                ? 'ทำหมันแล้ว'
                : 'ยังไม่ได้ทำหมัน'),
            Text('อายุ: ${questionObj.signalment.age}'),
            Text('น้ำหนัก: ${questionObj.signalment.weight}'),
            SizedBox(
              height: 20,
            ),
            // Client Complains
            Text(
              'Client Complains',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20),
              color: Color(0xFFDFE4E0),
              child: Text(questionObj.clientComplains),
            ),
            // History Taking
            Text(
              'History Taking',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20),
              color: Color(0xFFDFE4E0),
              child: Text(questionObj.historyTakingInfo),
            ),
            // General Test
            Text(
              'ผลตรวจร่างกาย',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: questionObj.generalInfo.split(',').length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 15,
                  ),
                  title: Text(questionObj.generalInfo.split(',')[index].trim()),
                );
              },
            ),
            addedContent != null ? addedContent! : Column(),
          ],
        ),
      ),
    );
  }
}

// class StateLessPart extends StatelessWidget {
//   QuestionObject questionObj;
//   Column? addedContent;
//
//   StateLessPart({required this.questionObj,this.addedContent});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//            // General Information
//           Text(
//             'รหัสโจทย์: ${questionObj.name}',
//             style: kSubHeaderTextStyle,
//           ),
//           Container(
//             padding: EdgeInsets.only(left: 10),
//             child: Row(
//               children: questionObj.tags
//                   .map(
//                     (e) => TagBox(text: e.name),
//               )
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//       SizedBox(height: 20),
//       Text(
//         'ข้อมูลทั่วไป',
//         style: kSubHeaderTextStyleInLeftPart,
//       ),
//       Text('ชนิดสัตว์: ${questionObj.signalment.species}'),
//       Text('พันธุ์: ${questionObj.signalment.breed}'),
//       Text('เพศ: ${questionObj.signalment.gender}'),
//       Text(questionObj.signalment.sterilize == true
//           ? 'ทำหมันแล้ว'
//           : 'ยังไม่ได้ทำหมัน'),
//       Text('อายุ: ${questionObj.signalment.age}'),
//       Text('น้ำหนัก: ${questionObj.signalment.weight}'),
//       SizedBox(
//         height: 20,
//       ),
//       // Client Complains
//       Text(
//         'Client Complains',
//         style: kSubHeaderTextStyleInLeftPart,
//       ),
//       Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.only(bottom: 20),
//         color: Color(0xFFDFE4E0),
//         child: Text(questionObj.clientComplains),
//       ),
//       // History Taking
//       Text(
//         'History Taking',
//         style: kSubHeaderTextStyleInLeftPart,
//       ),
//       Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.only(bottom: 20),
//         color: Color(0xFFDFE4E0),
//         child: Text(questionObj.historyTakingInfo),
//       ),
//       // General Test
//       Text(
//         'ผลตรวจร่างกาย',
//         style: kSubHeaderTextStyleInLeftPart,
//       ),
//       ListView.builder(
//         shrinkWrap: true,
//         itemCount: questionObj.generalInfo.split(',').length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Icon(
//               Icons.circle,
//               size: 15,
//             ),
//             title: Text(questionObj.generalInfo.split(',')[index].trim()),
//           );
//         },
//       ),
//       ],
//     );
//   }
// }
