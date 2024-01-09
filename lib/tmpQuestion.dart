import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'models/problemListObject.dart';
import 'components/examContainer.dart';
// import 'models/problemObject.dart';

////////////for show and edit page/////////////

int quesNum = 12;
String type = 'สุนัข';
String breed = 'American Bully';
String sex = 'เมีย';
int sterilize = 1;
String age = '10';
String weight = '15';
List<String> tagList = ['สุนัข', 'ปี 3', 'ระบบไหลเวียนเลือด'];
String historyTaking =
    'history taking result is flkjadglkzfnvlagjdfvkfjvdnvlzdsghs';
String clientComp = 'vznkjvhesjkdfnnkxfnvhioregtioejdfzk';
List<String> generalResult = [
  'หายใจเร็ว',
  'เยื่อเมือกเป็นสีม่วง',
  'เสียงหัวใจปกติ',
  'คลำสัญญาณชีพจรได้ปกติ',
  'เสียงท่อลมดังเป็นเสียงแหลม'
];
List<String> showSelectedProb1 = [
  'problem List 7',
  'problem List 4',
  'problem List 3',
  'problem List 9',
];

List<ShowExamContainer> showSelectedExamContainer1 = [
  ShowExamContainer(
      department: 'department 1',
      exam: 'exam 1',
      results: 'result 1',
      imagePath:
          'https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg'),
  ShowExamContainer(
      department: 'department 2',
      exam: 'exam 2',
      results: 'result 2',
      imagePath:
          'https://www.nylabone.com/-/media/project/oneweb/nylabone/images/dog101/activities-fun/10-great-small-dog-breeds/maltese-portrait.jpg'),
];

List<String> showSelectedProb2 = [
  'problem List 10',
  'problem List 8',
  'problem List 2',
  'problem List 5',
];

List<ShowExamContainer> showSelectedExamContainer2 = [
  ShowExamContainer(
      department: 'department 3',
      exam: 'exam 3',
      results: 'result 3',
      imagePath:
          'https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg'),
  ShowExamContainer(
      department: 'department 4',
      exam: 'exam 4',
      results: 'result 4',
      imagePath:
          'https://www.nylabone.com/-/media/project/oneweb/nylabone/images/dog101/activities-fun/10-great-small-dog-breeds/maltese-portrait.jpg'),
];

List<String> showSelectedDiagnosis = [
  'diag 2',
  'diag 4',
  'diag 7',
];

List<ShowTreatmentContainer> showSelectedTreatmentContainer = [
  ShowTreatmentContainer(treatmentTopic: 'topic 1', treatment: 'treatment 1'),
  ShowTreatmentContainer(treatmentTopic: 'topic 2', treatment: 'treatment 2'),
  ShowTreatmentContainer(treatmentTopic: 'topic 3', treatment: 'treatment 3'),
];

///////for full list/////////////////

List<String> probListSet = [
  'problem List 1',
  'problem List 2',
  'problem List 3',
  'problem List 4',
  'problem List 5',
  'problem List 6',
  'problem List 7',
  'problem List 8',
  'problem List 9',
  'problem List 10',
  'abab prob List',
  'aabb prob List',
];

List<ProblemObject> probObjectList = [
  ProblemObject(id: '1', name: 'problem List 1'),
  ProblemObject(id: '1', name: 'problem List 2'),
  ProblemObject(id: '1', name: 'problem List 3'),
  ProblemObject(id: '1', name: 'problem List 4'),
  ProblemObject(id: '1', name: 'problem List 5'),
  ProblemObject(id: '1', name: 'problem List 6'),
  ProblemObject(id: '1', name: 'problem List 7'),
  ProblemObject(id: '1', name: 'problem List 8'),
  ProblemObject(id: '1', name: 'problem List 9'),
  ProblemObject(id: '1', name: 'problem List 10'),
  ProblemObject(id: '1', name: 'abab prob List'),
  ProblemObject(id: '1', name: 'aabb prob List'),
];

List<String> M_treatmentList = [
  'M1',
  'M2',
  'M3',
  'M4',
  'M5',
  'M6',
  'M7',
  'M8',
  'M9',
  'M10',
];

List<String> S_treatmentList = [
  'S1',
  'S2',
  'S3',
  'S4',
  'S5',
  'S6',
  'S7',
  'S8',
  'S9',
  'S10',
];

List<String> N_treatmentList = [
  'N1',
  'N2',
  'N3',
  'N4',
  'N5',
  'N6',
  'N7',
  'N8',
  'N9',
  'N10',
];

List<String> O_treatmentList = [
  'O1',
  'O2',
  'O3',
  'O4',
  'O5',
  'O6',
  'O7',
  'O8',
  'O9',
  'O10',
];

List<TagObject> allTagList = [
  TagObject(id: '1', name: 'สุนัข'),
  TagObject(id: '1', name: 'แมว'),
  TagObject(id: '1', name: 'ปี 1'),
  TagObject(id: '1', name: 'ปี 2'),
  TagObject(id: '1', name: 'ปี 3'),
  TagObject(id: '1', name: 'ปี 4'),
  TagObject(id: '1', name: 'ระบบทางเดินอาหาร'),
  TagObject(id: '1', name: 'ระบบทางเดินหายใจ'),
  TagObject(id: '1', name: 'ระบบไหลเวียนเลือด'),
];

List<String> Signalment_typeList = ["สุนัข", "แมว", "นก"];

List<String> Signalment_dogBreedList = [
  'American Bully',
  'Golden Retriever',
  'Chihuahua'
];
List<String> Signalment_catBreedList = [
  'Ragdoll',
  'American Shorthair',
  'Bengal'
];
List<String> Signalment_birdBreedList = ['Lovebird', 'Canary', 'Parrot'];

List<String> examTopicList = [
  'ความดันโลหิต',
  'ผลการตรวจทางโลหิตวิทยา',
  'การถ่ายภาพรังสีวิทยาช่องอก',
  'การตรวจคลื่นไฟฟ้าหัวใจ',
  'คลื่นเสียงสะท้อนความถี่สูงของหัวใจ'
];

List<String> departmentList = [
  'เลือดและปัสสาวะ',
  'จุลชีววิทยา',
  'อณูวินิจฉัย',
  'เซลล์วินิจฉัย',
  'อัลตราซาวด์',
];

List<String> topicExamList1 = [
  'ผลตรวจเลือดและปัสสาวะ1',
  'ผลตรวจเลือดและปัสสาวะ2',
  'ผลตรวจเลือดและปัสสาวะ3',
  'ผลตรวจเลือดและปัสสาวะ4',
  'ผลตรวจเลือดและปัสสาวะ5',
];

List<String> topicExamList2 = [
  'ผลตรวจจุลชีววิทยา1',
  'ผลตรวจจุลชีววิทยา2',
  'ผลตรวจจุลชีววิทยา3',
  'ผลตรวจจุลชีววิทยา4',
  'ผลตรวจจุลชีววิทยา5',
];

List<String> topicExamList3 = [
  'ผลตรวจอณูวินิจฉัย1',
  'ผลตรวจอณูวินิจฉัย2',
  'ผลตรวจอณูวินิจฉัย3',
  'ผลตรวจอณูวินิจฉัย4',
  'ผลตรวจอณูวินิจฉัย5',
];

List<String> topicExamList4 = [
  'ผลตรวจเซลล์วินิจฉัย1',
  'ผลตรวจเซลล์วินิจฉัย2',
  'ผลตรวจเซลล์วินิจฉัย3',
  'ผลตรวจเซลล์วินิจฉัย4',
  'ผลตรวจเซลล์วินิจฉัย5',
];

List<String> topicExamList5 = [
  'ผลตรวจอัลตราซาวด์1',
  'ผลตรวจอัลตราซาวด์2',
  'ผลตรวจอัลตราซาวด์3',
  'ผลตรวจอัลตราซาวด์4',
  'ผลตรวจอัลตราซาวด์5',
];

// List<String> dianosisList = [
//   'diag 1',
//   'diag 2',
//   'diag 3',
//   'diag 4',
//   'diag 5',
//   'diag 6',
// ];

List<DiagnosisObject> diagnosisList = [
  DiagnosisObject(id: '1', name: 'diag 1'),
  DiagnosisObject(id: '1', name: 'diag 2'),
  DiagnosisObject(id: '1', name: 'diag 3'),
  DiagnosisObject(id: '1', name: 'diag 4'),
  DiagnosisObject(id: '1', name: 'diag 5'),
  DiagnosisObject(id: '1', name: 'diag 6'),
];

List<String> treatmentTopicList = [
  'Medical Treatment',
  'Surgical Treatment',
  'Nutrition Support',
  'Other Treatment',
];

List<String> medicalTreatmentList = [
  'medical 1',
  'medical 2',
  'medical 3',
  'medical 4',
  'medical 5',
];

List<String> surgicalTreatmentList = [
  'surgical 1',
  'surgical 2',
  'surgical 3',
  'surgical 4',
];

List<String> nutritionSupportList = [
  'nutrition 1',
  'nutrition 2',
  'nutrition 3',
  'nutrition 4',
  'nutrition 5',
];

List<String> otherTreatmentList = [
  'other treatment 1',
  'other treatment 2',
  'other treatment 3',
  'other treatment 4',
  'other treatment 5',
];

List<String> editPredefinedList = [
  'Problem List',
  'Diagnosis List',
  'Medical Treatment List',
  'Surgical Treatment List',
  'Nutrition Support List',
  'Other Treatment List',
];
