import 'package:flutter/material.dart';
import 'package:frontend/UIModels/examContainer_provider.dart';
import 'package:frontend/UIModels/treatmentContainer_provider.dart';
import 'package:frontend/screensNisit/diagnosis.dart';
import 'package:frontend/screensNisit/probListAns1.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';
import 'package:frontend/screensTeacher/addQuesMenu.dart';
import 'package:frontend/screensTeacher/addQuestion.dart';
import 'package:frontend/screensTeacher/editPredefinedListTopic.dart';
import 'package:frontend/screensTeacher/showAndEditQuestion.dart';
import 'screensNisit/showQuestionNisit.dart';
import 'screensNisit/problemList1.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ExamContainerProvider()),
      ChangeNotifierProvider(create: (_) => TreatmentContainerProvider()),
    ],
    child: const MyApp(),
  )
      // ChangeNotifierProvider(
      //   create: (context) => ExamContainerProvider(),
      //   child: const MyApp(),
      // ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      initialRoute: '/Teacher/addQuestion',
      // initialRoute: '/Teacher/editQuestion',
      routes: {
        '/Nisit/showQuestion': (context) => NisitShowQuestion(),
        '/Nisit/probList1': (context) => ProbList1(),
        '/Nisit/probListAns1': (context) => ProbListAns1(),
        '/Nisit/diagnosis': (context) => Diagnosis(),
        '/Nisit/treatment': (context) => TreatmentTopic(),
        '/Teacher/addQuestion': (context) => AddQuestion(),
        '/Teacher/editPredefined': (context) => EditPredefinedListTopic(),
        '/Teacher/editQuestion': (context) => ShowAndEditQuestion(),
        '/Teacher/addQuesMenu': (context) => AddQuesMenu(),
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
