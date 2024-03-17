import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/models/questionObject.dart';

/////predefined/////
List<DiagnosisObject> diagnosisListPreDefined = [];
List<TagObject> tagListPreDefined = [];
List<ProblemObject> problemListPreDefined = [];
List<TreatmentObject> treatmentListPreDefined = [];
List<ExamPreDefinedObject> examListPreDefined = [];

/////question List/////
List<FullQuestionObject> teacherQuestionList = [];
List<QuestionObject> nisitQuestionList = [];

/////role/////
late int userRole;
