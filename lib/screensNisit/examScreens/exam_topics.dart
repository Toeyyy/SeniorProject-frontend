import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/examConstants.dart';
import 'package:collection/collection.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/screensNisit/examScreens/exam_bloodAndParasite.dart';

// class ExamTopic extends StatelessWidget {
//   String round;
//
//   ExamTopic({required this.round});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppbarNisit(),
//       body: SplitScreenNisit(
//         leftPart: LeftPartContent(),
//         rightPart: RightPart_ExamTopic(round: round),
//       ),
//     );
//   }
// }
//
// class RightPart_ExamTopic extends StatelessWidget {
//   String round;
//
//   RightPart_ExamTopic({required this.round});
//
//   Map<String, List<ExamPreDefinedObject>> groupedByMap =
//       groupBy(examAll, (e) => e.lab);
//
//   String getLabName(String title) {
//     if (title == 'แบบส่งตรวจเลือดและปัสสาวะ (ห้องปฏิบัติการพยาธิคลินิก)') {
//       return 'blood';
//     } else if (title == 'แบบส่งตรวจพิเศษ (ห้องปฏิบัติการพยาธิคลินิก)') {
//       return 'parasite';
//     } else {
//       return '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//       child: Column(
//         children: [
//           Text('เลือกแผนกการตรวจ', style: kSubHeaderTextStyle),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.separated(
//               separatorBuilder: (context, index) => SizedBox(height: 8),
//               itemCount: examLabList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   tileColor: Color(0xFFA0E9FF),
//                   hoverColor: Color(0xFF42C2FF),
//                   title: Text(examLabList[index]),
//                   onTap: () {
//                     String labName = getLabName(examLabList[index]);
//                     if (labName == 'blood' || labName == 'parasite') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ExamBloodAndParasiteType(
//                             list: groupedByMap[labName]!,
//                             title: examLabList[index],
//                             round: round,
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
