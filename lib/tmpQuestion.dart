import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'components/examContainer.dart';
import 'package:frontend/models/signalmentObject.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/questionObject.dart';
import 'models/examResultObject.dart';

////////////for show and edit page/////////////

// int name = 12;
// String quesID = 'tmpID';
// String type = 'สุนัข';
// String breed = 'American Bully';
// String sex = 'เมีย';
// int sterilize = 1;
// String age = '10';
// String weight = '15';

// SignalmentObject showSignalmentList = SignalmentObject(
//     species: 'สุนัข',
//     breed: 'American Bully',
//     sterilize: true,
//     age: '10 ปี',
//     gender: 'เมีย',
//     weight: '15 Kg');

// List<String> tagList = ['สุนัข', 'ปี 3', 'ระบบไหลเวียนเลือด'];
// List<TagObject> showTagList = [
//   TagObject(id: '1', name: 'สุนัข'),
//   TagObject(id: '5', name: 'ปี 3'),
//   TagObject(id: '9', name: 'ระบบไหลเวียนเลือด'),
// ];
// String historyTaking =
//     'history taking result is flkjadglkzfnvlagjdfvkfjvdnvlzdsghs';
// String clientComp = 'vznkjvhesjkdfnnkxfnvhioregtioejdfzk';
//
// String generalResult =
//     'หายใจเร็ว, เยื่อเมือกเป็นสีม่วง,เสียงหัวใจปกติ,คลำสัญญาณชีพจรได้ปกติ, เสียงท่อลมดังเป็นเสียงแหลม';

// List<ProblemObject> showSelectedProb1 = [
//   ProblemObject(id: '7', name: 'problem List 7'),
//   ProblemObject(id: '4', name: 'problem List 4'),
//   ProblemObject(id: '3', name: 'problem List 3'),
//   ProblemObject(id: '9', name: 'problem List 9'),
// ];

// List<ExaminationObject> showSelectedExam = [
//   ExaminationObject(
//       id: '5',
//       lab: 'lab 1',
//       type: 'lab 1 type 2',
//       area: null,
//       name: 'lab 1 type 2 exam 2',
//       textResult: "result 1",
//       imgPath: null,
//       imgResult: null,
//       round: 1),
//   ExaminationObject(
//     id: '6',
//     lab: 'lab 1',
//     type: 'lab 1 type 2',
//     name: 'lab 1 type 2 exam 3',
//     textResult: 'result 2',
//     imgPath: null,
//     imgResult: null,
//     round: 1,
//   ),
//   ExaminationObject(
//     id: '7',
//     lab: 'lab 2',
//     area: 'area 1',
//     type: 'lab 2 type 1',
//     name: 'lab 2 type 1 exam 1',
//     textResult: 'result 3',
//     imgPath: null,
//     imgResult: null,
//     round: 2,
//   ),
//   ExaminationObject(
//     id: '11',
//     lab: 'lab 2',
//     area: 'area 3',
//     type: 'lab 2 type 2',
//     name: 'lab 2 type 2 exam 2',
//     textResult: 'result 4',
//     imgPath: null,
//     imgResult: null,
//     round: 1,
//   ),
//   ExaminationObject(
//     id: '12',
//     lab: 'lab 2',
//     area: 'area 3',
//     type: 'lab 2 type 2',
//     name: 'lab 2 type 2 exam 3',
//     textResult: 'result 5',
//     imgPath: null,
//     imgResult: null,
//     round: 2,
//   ),
//   ExaminationObject(
//     id: '13',
//     lab: 'lab 3',
//     type: 'lab 3 type 1',
//     area: null,
//     name: 'lab 3 type 1 exam 1',
//     textResult: 'result 6',
//     imgPath: null,
//     imgResult: null,
//     round: 2,
//   ),
// ];

// List<ExamResultObject> showExamResult = [
//   ExamResultObject(
//       id: '1',
//       textResult: 'not normal result',
//       imgResult:
//           'data:image/jpeg;base64,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'),
//   ExamResultObject(id: '2', textResult: 'ค่าปกติ', imgResult: null),
//   ExamResultObject(id: '3', textResult: 'ค่าปกติ', imgResult: null),
// ];

// List<ProblemObject> showSelectedProb2 = [
//   ProblemObject(id: '10', name: 'problem List 10'),
//   ProblemObject(id: '8', name: 'problem List 8'),
//   ProblemObject(id: '2', name: 'problem List 2'),
//   ProblemObject(id: '5', name: 'problem List 5'),
// ];

// List<DiagnosisObject> showSelectedDiagnosis = [
//   DiagnosisObject(id: '1', name: 'diag 2'),
//   DiagnosisObject(id: '2', name: 'diag 4'),
//   DiagnosisObject(id: '3', name: 'diag 7'),
// ];

// List<ShowTreatmentContainer> showSelectedTreatmentContainer = [
//   ShowTreatmentContainer(treatmentTopic: 'Surgical', treatment: 'surgical 1'),
//   ShowTreatmentContainer(
//       treatmentTopic: 'Nutritional support', treatment: 'nutrition 2'),
//   ShowTreatmentContainer(treatmentTopic: 'Medical', treatment: 'medical 3'),
// ];

// List<TreatmentObject> showTreatmentList = [
//   TreatmentObject(id: '1', type: 'Medical', name: "medical 1", cost: 100),
//   TreatmentObject(id: '4', type: 'Surgical', name: "surgical 2", cost: 100),
//   TreatmentObject(
//       id: '7', type: 'Nutritional support', name: "nutrition 3", cost: 100),
// ];

///////for full list/////////////////

// List<ProblemObject> probObjectList = [
//   ProblemObject(id: '1', name: 'problem List 1'),
//   ProblemObject(id: '2', name: 'problem List 2'),
//   ProblemObject(id: '3', name: 'problem List 3'),
//   ProblemObject(id: '4', name: 'problem List 4'),
//   ProblemObject(id: '5', name: 'problem List 5'),
//   ProblemObject(id: '6', name: 'problem List 6'),
//   ProblemObject(id: '7', name: 'problem List 7'),
//   ProblemObject(id: '8', name: 'problem List 8'),
//   ProblemObject(id: '9', name: 'problem List 9'),
//   ProblemObject(id: '10', name: 'problem List 10'),
//   ProblemObject(id: '11', name: 'abab prob List'),
//   ProblemObject(id: '12', name: 'aabb prob List'),
// ];

List<String> Signalment_typeList = ["สุนัข", "แมว", "นก"];
//
// List<String> Signalment_dogBreedList = [
//   'American Bully',
//   'Golden Retriever',
//   'Chihuahua'
// ];
// List<String> Signalment_catBreedList = [
//   'Ragdoll',
//   'American Shorthair',
//   'Bengal'
// ];
// List<String> Signalment_birdBreedList = ['Lovebird', 'Canary', 'Parrot'];

// List<DiagnosisObject> diagnosisList = [
//   DiagnosisObject(id: '1', name: 'diag 1'),
//   DiagnosisObject(id: '1', name: 'diag 2'),
//   DiagnosisObject(id: '1', name: 'diag 3'),
//   DiagnosisObject(id: '1', name: 'diag 4'),
//   DiagnosisObject(id: '1', name: 'diag 5'),
//   DiagnosisObject(id: '1', name: 'diag 6'),
// ];

//////for predefined page////////////////

// List<String> editPredefinedTopicList = [
//   'Problem List',
//   'Diagnosis List',
//   'Treatment List',
//   'Examination List',
// ];

// List<TagObject> allTagList = [
//   TagObject(id: '1', name: 'สุนัข'),
//   TagObject(id: '2', name: 'แมว'),
//   TagObject(id: '3', name: 'ปี 1'),
//   TagObject(id: '4', name: 'ปี 2'),
//   TagObject(id: '5', name: 'ปี 3'),
//   TagObject(id: '6', name: 'ปี 4'),
//   TagObject(id: '7', name: 'ระบบทางเดินอาหาร'),
//   TagObject(id: '8', name: 'ระบบทางเดินหายใจ'),
//   TagObject(id: '9', name: 'ระบบไหลเวียนเลือด'),
// ];

// List<ExamPreDefinedObject> preDefinedExamAll = [
//   ExamPreDefinedObject(
//       id: '1',
//       lab: 'lab 1',
//       type: 'lab 1 type 1',
//       // area: null,
//       name: 'lab 1 type 1 exam 1',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '2',
//       lab: 'lab 1',
//       type: 'lab 1 type 1',
//       area: null,
//       name: 'lab 1 type 1 exam 2',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '3',
//       lab: 'lab 1',
//       type: 'lab 1 type 1',
//       area: null,
//       name: 'lab 1 type 1 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '4',
//       lab: 'lab 1',
//       type: 'lab 1 type 2',
//       area: null,
//       name: 'lab 1 type 2 exam 1',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '5',
//       lab: 'lab 1',
//       type: 'lab 1 type 2',
//       area: null,
//       name: 'lab 1 type 2 exam 2',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '6',
//       lab: 'lab 1',
//       type: 'lab 1 type 2',
//       area: null,
//       name: 'lab 1 type 2 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '7',
//       lab: 'lab 2',
//       area: 'area 1',
//       type: 'lab 2 type 1',
//       name: 'lab 2 type 1 exam 1',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '8',
//       lab: 'lab 2',
//       area: 'area 2',
//       type: 'lab 2 type 1',
//       name: 'lab 2 type 1 exam 2',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '9',
//       lab: 'lab 2',
//       area: 'area 1',
//       type: 'lab 2 type 1',
//       name: 'lab 2 type 1 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '10',
//       lab: 'lab 2',
//       area: 'area 2',
//       type: 'lab 2 type 2',
//       name: 'lab 2 type 2 exam 1',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '11',
//       lab: 'lab 2',
//       area: 'area 3',
//       type: 'lab 2 type 2',
//       name: 'lab 2 type 2 exam 2',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '12',
//       lab: 'lab 2',
//       area: 'area 3',
//       type: 'lab 2 type 2',
//       name: 'lab 2 type 2 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '13',
//       lab: 'lab 3',
//       type: 'lab 3 type 1',
//       area: null,
//       name: 'lab 3 type 1 exam 1',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '14',
//       lab: 'lab 3',
//       type: 'lab 3 type 1',
//       area: null,
//       name: 'lab 3 type 1 exam 2',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '15',
//       lab: 'lab 3',
//       type: 'lab 3 type 1',
//       area: null,
//       name: 'lab 3 type 1 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '16',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: null,
//       name: 'lab 3 type 2 exam 1',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '17',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: null,
//       name: 'lab 3 type 2 exam 2',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '18',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: 'area 4',
//       name: 'lab 3 type 2 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '19',
//       lab: 'Ultrasound',
//       type: 'Ultrasound',
//       area: null,
//       name: 'Liver',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '20',
//       lab: 'Ultrasound',
//       type: 'Ultrasound',
//       area: null,
//       name: 'Eyes',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '21',
//       lab: 'Ultrasound',
//       type: 'Ultrasound',
//       area: null,
//       name: 'Head',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '22',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: 'area 1',
//       name: 'lab 3 type 2 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '23',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: 'area 2',
//       name: 'lab 3 type 2 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '24',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: 'area 3',
//       name: 'lab 3 type 2 exam 3',
//       cost: 100),
//   ExamPreDefinedObject(
//       id: '25',
//       lab: 'lab 3',
//       type: 'lab 3 type 2',
//       area: 'area 3',
//       name: 'lab 3 type 2 exam 2',
//       cost: 100),
// ];

// List<TreatmentObject> preDefinedTreatmentAll = [
//   TreatmentObject(id: '1', type: 'Medical', name: "medical 1", cost: 100),
//   TreatmentObject(id: '2', type: 'Medical', name: "medical 2", cost: 100),
//   TreatmentObject(id: '3', type: 'Surgical', name: "surgical 1", cost: 100),
//   TreatmentObject(id: '4', type: 'Surgical', name: "surgical 2", cost: 100),
//   TreatmentObject(
//       id: '5', type: 'Nutritional support', name: "nutrition 1", cost: 100),
//   TreatmentObject(
//       id: '6', type: 'Nutritional support', name: "nutrition 2", cost: 100),
//   TreatmentObject(
//       id: '7', type: 'Nutritional support', name: "nutrition 3", cost: 100),
//   TreatmentObject(
//       id: '8', type: 'Nutritional support', name: "nutrition 4", cost: 100),
//   TreatmentObject(
//       id: '9', type: 'Nutritional support', name: "nutrition 5", cost: 100),
//   TreatmentObject(
//       id: '10', type: 'Other', name: "other treatment 1", cost: 100),
//   TreatmentObject(
//       id: '11', type: 'Other', name: "other treatment 2", cost: 100),
//   TreatmentObject(
//       id: '12', type: 'Other', name: "other treatment 3", cost: 100),
//   TreatmentObject(
//       id: '13', type: 'Other', name: "other treatment 4", cost: 100),
//   TreatmentObject(
//       id: '14', type: 'Other', name: "other treatment 5", cost: 100),
//   TreatmentObject(id: '15', type: 'Medical', name: "medical 3", cost: 100),
//   TreatmentObject(id: '16', type: 'Medical', name: "medical 4", cost: 100),
//   TreatmentObject(id: '17', type: 'Medical', name: "medical 5", cost: 100),
//   TreatmentObject(id: '18', type: 'Surgical', name: "surgical 3", cost: 100),
//   TreatmentObject(id: '19', type: 'Surgical', name: "surgical 4", cost: 100),
//   TreatmentObject(id: '20', type: 'Surgical', name: "surgical 5", cost: 100),
// ];

// List<ProblemObject> preDefinedProblem = [
//   ProblemObject(id: '1', name: 'problem List 1'),
//   ProblemObject(id: '2', name: 'problem List 2'),
//   ProblemObject(id: '3', name: 'problem List 3'),
//   ProblemObject(id: '4', name: 'problem List 4'),
//   ProblemObject(id: '5', name: 'problem List 5'),
//   ProblemObject(id: '6', name: 'problem List 6'),
//   ProblemObject(id: '7', name: 'problem List 7'),
//   ProblemObject(id: '8', name: 'problem List 8'),
//   ProblemObject(id: '9', name: 'problem List 9'),
//   ProblemObject(id: '10', name: 'problem List 10'),
//   ProblemObject(id: '11', name: 'abab prob List'),
//   ProblemObject(id: '12', name: 'aabb prob List'),
// ];

// List<DiagnosisObject> preDefinedDiagnosis = [
//   DiagnosisObject(id: '1', name: 'Diag 1'),
//   DiagnosisObject(id: '2', name: 'Diag 2'),
//   DiagnosisObject(id: '3', name: 'Diag 3'),
//   DiagnosisObject(id: '4', name: 'Diag 4'),
//   DiagnosisObject(id: '5', name: 'Diag 5'),
//   DiagnosisObject(id: '6', name: 'Diag 6'),
// ];

/////////////////////for nisit page//////////////////////

// QuestionObject listForSplitScreen = QuestionObject(
//   id: '1',
//   name: '12',
//   clientComplains: 'Client Complain asjlfjdjfask',
//   historyTakingInfo: "history Taking result lajfljkladslflksjfjf",
//   generalInfo:
//       'หายใจเร็ว, เยื่อเมือกเป็นสีม่วง,เสียงหัวใจปกติ,คลำสัญญาณชีพจรได้ปกติ, เสียงท่อลมดังเป็นเสียงแหลม',
//   tags: showTagList,
//   signalment: showSignalmentList,
// );

// List<ProblemObject> correctProb1 = [
//   ProblemObject(id: '1', name: 'problem List 1'),
//   ProblemObject(id: '3', name: 'problem List 3'),
//   ProblemObject(id: '5', name: 'problem List 5'),
// ];
//
// List<ProblemObject> correctProb2 = [
//   ProblemObject(id: '2', name: 'problem List 2'),
//   ProblemObject(id: '4', name: 'problem List 4'),
//   ProblemObject(id: '6', name: 'problem List 6'),
// ];

/////delete later
// QuestionObject tmpQues = QuestionObject(
//   id: 'ID_1',
//   name: '12',
//   clientComplains: "client complain 1 vznkjvhesjkdfnnkxfnvhioregtioejdfzk",
//   historyTakingInfo:
//       "history taking result is flkjadglkzfnvlagjdfvkfjvdnvlzdsgh",
//   generalInfo:
//       "หายใจเร็ว, เยื่อเมือกเป็นสีม่วง, เสียงหัวใจปกติ, คลำสัญญาณชีพจรได้ปกติ, เสียงท่อลมดังเป็นเสียงแหลม",
//   tags: [
//     TagObject(id: '1', name: 'สุนัข'),
//     TagObject(id: '5', name: 'ปี 3'),
//     TagObject(id: '9', name: 'ระบบไหลเวียนเลือด'),
//   ],
//   signalment: SignalmentObject(
//       species: 'สุนัข',
//       breed: 'American Bully',
//       sterilize: true,
//       age: '8 เดือน',
//       gender: 'เมีย',
//       weight: '15 Kg'),
//   problems: [
//     ProblemObject(id: '1', name: 'problem List 1', round: 1),
//     ProblemObject(id: '5', name: 'problem List 5', round: 1),
//     ProblemObject(id: '2', name: 'problem List 2', round: 2),
//     ProblemObject(id: '4', name: 'problem List 4', round: 2),
//   ],
// );
