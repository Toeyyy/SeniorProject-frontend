import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/UIModels/nisit/selectedTreatment_provider.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:frontend/screensNisit/diagnosis.dart';
import 'package:frontend/screensNisit/probListAns.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';
import 'package:frontend/screensNisit/treatmentTotal.dart';
import 'package:frontend/screensTeacher/addQuesMenu.dart';
import 'package:frontend/screensTeacher/addQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefinedListTopic.dart';
import 'package:frontend/screensTeacher/showAndEditQuestion.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';
import 'package:frontend/screensNisit/problemList.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensTeacher/editQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_detail.dart';
import 'package:frontend/screensNisit/examScreens/exam_topics.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_choice.dart';
import 'package:frontend/UIModels/nisit/selectedProblem_provider.dart';
import 'package:frontend/UIModels/nisit/selectedDiagnosis_provider.dart';
import 'package:frontend/screensNisit/returnPoint.dart';
import 'package:frontend/screensNisit/showStats.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ExamContainerProvider()),
      ChangeNotifierProvider(create: (_) => TreatmentContainerProvider()),
      ChangeNotifierProvider(create: (_) => PreDefinedExamProvider()),
      ChangeNotifierProvider(create: (_) => SelectedTreatment()),
      ChangeNotifierProvider(create: (_) => SelectedExam()),
      ChangeNotifierProvider(create: (_) => SelectedProblem()),
      ChangeNotifierProvider(create: (_) => SelectedDiagnosis()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      // initialRoute: '/Nisit/treatmentTotal',
      // initialRoute: '/mainShowQuestionNisit',
      // initialRoute: '/mainShowQuestionTeacher',
      // initialRoute: '/Nisit/showStats',
      initialRoute: '/Teacher/addQuesMenu',
      // initialRoute: '/Nisit/ExamTopic',
      routes: {
        /////General/////
        '/mainShowQuestionNisit': (context) => MainShowQuestion(
              role: 0,
            ),
        '/mainShowQuestionTeacher': (context) => MainShowQuestion(
              role: 1,
            ),
        /////Nisit/////
        // '/Nisit/probList': (context) => ProbList(round: '1'),
        // '/Nisit/probListAns': (context) => ProbListAns(round: '1'),
        // '/Nisit/ExamTopic': (context) => ExamTopic(round: '1'),
        // '/Nisit/diagnosis': (context) => Diagnosis(),
        // '/Nisit/treatmentTopic': (context) => TreatmentTopic(),
        // '/Nisit/treatmentTotal': (context) =>
        //     TreatmentTotal(questionObj: tmpQues),
        // '/Nisit/returnPoint': (context) => ReturnPoint(),
        '/Nisit/showStats': (context) => ShowStatsForNisit(),
        /////Teacher/////
        '/Teacher/addQuestion': (context) => AddQuestion(),
        '/Teacher/editPredefined': (context) => EditPredefinedListTopic(),
        // '/Teacher/showAndEditQuestion': (context) => ShowAndEditQuestion(),
        // '/Teacher/editQuestion': (context) => EditQuestion(),
        '/Teacher/addQuesMenu': (context) => AddQuesMenu(),
        'Teacher/editPreDefined/exams_topic': (context) =>
            EditPreDefinedExamChoice(),
      },
    );
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  // textTheme: const TextTheme(
  //   displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  //   bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  // ),
  scaffoldBackgroundColor: Color(0xFFF2F5F7),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF3DABF5),
    foregroundColor: Color(0xFFF2F5F7),
  ),
  // colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF2F5F7)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Color(0xFF42C2FF),
      ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.hovered)
            ? Color(0xFF000411)
            : Color(0xFFF2F5F7),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  ),
);
