import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/UIModels/nisit/selected_treatment_provider.dart';
import 'package:frontend/UIModels/teacher/exam_container_provider.dart';
import 'package:frontend/UIModels/teacher/treatment_container_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/my_go_router.dart';

Future main() async {
  await dotenv.load(fileName: "assets/env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ExamContainerProvider()),
      ChangeNotifierProvider(create: (_) => TreatmentContainerProvider()),
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
    return MaterialApp.router(
      theme: lightTheme,
      routerConfig: myRouterConfig,
    );
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF2F5F7),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF3DABF5),
    foregroundColor: Color(0xFFF2F5F7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        const Color(0xFF42C2FF),
      ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.hovered)
            ? const Color(0xFF000411)
            : const Color(0xFFF2F5F7),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  ),
);
