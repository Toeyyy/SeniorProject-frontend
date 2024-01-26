import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/models/examResultObject.dart';

List<String> examLabList = [
  'แบบส่งตรวจพิเศษ (ห้องปฏิบัติการพยาธิคลินิก)',
  'แบบส่งตรวจเลือดและปัสสาวะ (ห้องปฏิบัติการพยาธิคลินิก)',
  'แบบส่งตรวจเอกซเรย์',
  'แบบส่งตรวจอัลตราซาวด์',
  'แบบส่งตรวจเซลล์วินิจฉัย (Cytology)',
  'แบบส่งตรวจอณูวินิจฉัย',
  'แบบส่งตรวจจุลชีววิทยา',
];

//////all///////

// List<ExamPreDefinedObject> examAll = [
//   ExamPreDefinedObject(
//       id: '1',
//       lab: 'blood',
//       type: 'hematology',
//       name: 'CBC + Diff*',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '2', lab: 'blood', type: 'hematology', name: 'Retics', cost: 100),
//   ExamPreDefinedObject(
//       id: '3', lab: 'blood', type: 'hormone', name: 'cortisol', cost: 100),
//   ExamPreDefinedObject(
//       id: '4', lab: 'blood', type: 'hormone', name: 'uccr', cost: 100),
//   ExamPreDefinedObject(
//       id: '5', lab: 'blood', type: 'urinalysis', name: 'ua', cost: 100),
//   ExamPreDefinedObject(
//       id: '6', lab: 'blood', type: 'urinalysis', name: 'upcr', cost: 100),
//   ExamPreDefinedObject(
//       id: '7', lab: 'blood', type: 'blood chemistry', name: 'bun', cost: 100),
//   ExamPreDefinedObject(
//       id: '8',
//       lab: 'blood',
//       type: 'blood chemistry',
//       name: 'creatinine',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '9', lab: 'blood', type: 'electrolyte', name: 'calcium', cost: 100),
//   ExamPreDefinedObject(
//       id: '10',
//       lab: 'blood',
//       type: 'electrolyte',
//       name: 'phosphorus',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '11',
//       lab: 'parasite',
//       type: 'idexx: cbc procyte',
//       name: 'cbc + Diff + Retics + Bl. Parasite',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '12',
//       lab: 'parasite',
//       type: 'idexx: catalyst',
//       name: 'ammonia',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '13',
//       lab: 'parasite',
//       type: 'idexx: catalyst',
//       name: 'phenobarbital',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '14',
//       lab: 'parasite',
//       type: 'idexx: snap - pro',
//       name: '4dx',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '15',
//       lab: 'parasite',
//       type: 'idexx: snap - pro',
//       name: 'fpl',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '16', lab: 'parasite', type: 'v-check', name: 'cortisol', cost: 100),
//   ExamPreDefinedObject(
//       id: '17',
//       lab: 'parasite',
//       type: 'v-check',
//       name: 'canine tnI',
//       cost: 100),
// ];

//////blood///////

// List<ExamPreDefinedObject> examTypeListBlood = [
//   ExamPreDefinedObject(
//       id: '1',
//       lab: 'blood',
//       type: 'hematology',
//       name: 'CBC + Diff*',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '2', lab: 'blood', type: 'hematology', name: 'Retics', cost: 100),
//   ExamPreDefinedObject(
//       id: '3', lab: 'blood', type: 'hormone', name: 'cortisol', cost: 100),
//   ExamPreDefinedObject(
//       id: '4', lab: 'blood', type: 'hormone', name: 'uccr', cost: 100),
//   ExamPreDefinedObject(
//       id: '5', lab: 'blood', type: 'urinalysis', name: 'ua', cost: 100),
//   ExamPreDefinedObject(
//       id: '6', lab: 'blood', type: 'urinalysis', name: 'upcr', cost: 100),
//   ExamPreDefinedObject(
//       id: '7', lab: 'blood', type: 'blood chemistry', name: 'bun', cost: 100),
//   ExamPreDefinedObject(
//       id: '8',
//       lab: 'blood',
//       type: 'blood chemistry',
//       name: 'creatinine',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '9', lab: 'blood', type: 'electrolyte', name: 'calcium', cost: 100),
//   ExamPreDefinedObject(
//       id: '10',
//       lab: 'blood',
//       type: 'electrolyte',
//       name: 'phosphorus',
//       cost: 100),
// ];

//////parasite//////

// List<ExamPreDefinedObject> examTypeListParasite = [
//   ExamPreDefinedObject(
//       id: '11',
//       lab: 'parasite',
//       type: 'idexx: cbc procyte',
//       name: 'cbc + Diff + Retics + Bl. Parasite',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '12',
//       lab: 'parasite',
//       type: 'idexx: catalyst',
//       name: 'ammonia',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '13',
//       lab: 'parasite',
//       type: 'idexx: catalyst',
//       name: 'phenobarbital',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '14',
//       lab: 'parasite',
//       type: 'idexx: snap - pro',
//       name: '4dx',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '15',
//       lab: 'parasite',
//       type: 'idexx: snap - pro',
//       name: 'fpl',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '16', lab: 'parasite', type: 'v-check', name: 'cortisol', cost: 100),
//   ExamPreDefinedObject(
//       id: '17',
//       lab: 'parasite',
//       type: 'v-check',
//       name: 'canine tnI',
//       cost: 100),
// ];

/////result//////

List<ExamResultObject> examResultList = [
  ExamResultObject(
      id: '036b681a-7244-440f-a0c2-8390a7ea7813',
      textResult: 'result 1',
      imgResult:
          'Uploads\\2\\036B681A-7244-440F-A0C2-8390A7EA7813\\16605662-0634-42e3-9c9c-8fc61a82071c.png'),
  ExamResultObject(
      id: '79FB49EC-70C9-484B-8204-BBC4F94F6031',
      textResult: 'ค่าปกติ',
      imgResult: null),
];
