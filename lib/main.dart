import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/UIModels/nisit/selectedTreatment_provider.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:frontend/screensNisit/diagnosis.dart';
import 'package:frontend/screensNisit/probListAns1.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';
import 'package:frontend/screensNisit/treatmentTotal.dart';
import 'package:frontend/screensTeacher/addQuesMenu.dart';
import 'package:frontend/screensTeacher/addQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefinedListTopic.dart';
import 'package:frontend/screensTeacher/showAndEditQuestion.dart';
import 'screensNisit/showQuestionNisit.dart';
import 'screensNisit/problemList1.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensTeacher/editQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exams_topics.dart';
import 'package:frontend/screensNisit/examScreens/exam_topics.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam2_topic.dart';

import 'package:frontend/screensTeacher/todScreen.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ExamContainerProvider()),
      ChangeNotifierProvider(create: (_) => TreatmentContainerProvider()),
      ChangeNotifierProvider(create: (_) => PreDefinedExamProvider()),
      ChangeNotifierProvider(create: (_) => SelectedTreatment()),
      ChangeNotifierProvider(create: (_) => SelectedExam()),
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
      // initialRoute: '/Nisit/showQuestionNisit',
      // initialRoute: '/Teacher/editPredefined',
      initialRoute: '/Teacher/addQuesMenu',
      ///////
      // initialRoute: 'TOD',
      routes: {
        'TOD': (context) => Tod(),
        '/Nisit/showQuestionNisit': (context) => NisitShowQuestion(),
        '/Nisit/probList1': (context) => ProbList(round: '1'),
        '/Nisit/probListAns1': (context) => ProbListAns1(),
        // '/Nisit/ExamTopic': (context) => ExamTopic(round: '1'),
        '/Nisit/diagnosis': (context) => Diagnosis(),
        '/Nisit/treatment': (context) => TreatmentTopic(),
        '/Nisit/treatmentTotal': (context) => TreatmentTotal(),
        '/Teacher/addQuestion': (context) => AddQuestion(),
        '/Teacher/editPredefined': (context) => EditPredefinedListTopic(),
        '/Teacher/showAndEditQuestion': (context) => ShowAndEditQuestion(),
        '/Teacher/editQuestion': (context) => EditQuestion(),
        '/Teacher/addQuesMenu': (context) => AddQuesMenu(),
        'Teacher/editPreDefined/exams_topic': (context) =>
            EditPreDefinedExam2Topic(),
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
