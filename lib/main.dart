import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/UIModels/nisit/selected_treatment_provider.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:frontend/screensNisit/tenDiag.dart';
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
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_choice.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:frontend/screensNisit/returnPoint.dart';
import 'package:frontend/screensNisit/showStats.dart';
import 'package:frontend/screensGeneral/loginScreen.dart';
import 'package:frontend/screensGeneral/registerScreen.dart';
import 'package:frontend/go_router.dart';

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
    // return MaterialApp.router(
    //   theme: lightTheme,
    //   routerConfig: myRouterConfig,
    // );
    //role 0 = nisit, role 1 = teacher
    //เค้าเปลี่ยนเป็นเซ็ต role ใส่ใน userRole ตรงนี้นะ ถ้าอยากเปิดหน้านรก็เปลี่ยนเป็น 0
    userRole = 1;
    return MaterialApp(
      theme: lightTheme,
      // initialRoute: '/Nisit/treatmentTotal',
      // initialRoute: '/mainShowQuestion',
      initialRoute: '/mainShowQuestion',
      // initialRoute: '/register',
      // initialRoute: '/Teacher/addQuesMenu',
      // onGenerateRoute: RouteGenerator.generateRoute,
      routes: {
        /////General/////
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/mainShowQuestion': (context) => const MainShowQuestion(),
        '/Nisit/showStats': (context) => ShowStatsForNisit(),
        /////Teacher/////
        '/Teacher/addQuestion': (context) => AddQuestion(),
        '/Teacher/editPredefined': (context) => EditPredefinedListTopic(),
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
  scaffoldBackgroundColor: const Color(0xFFF2F5F7),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF3DABF5),
    foregroundColor: Color(0xFFF2F5F7),
  ),
  // colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF2F5F7)),
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
