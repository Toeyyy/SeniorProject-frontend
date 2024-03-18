import 'package:frontend/screensTeacher/PredefinedScreens/editPredefinedListTopic.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screensGeneral/loginTeacherScreen.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';
import 'package:frontend/screensGeneral/errorScreen.dart';
import 'package:frontend/screensGeneral/registerScreen.dart';
import 'package:frontend/screensNisit/showStats.dart';
import 'package:frontend/screensNisit/problemList.dart';
import 'package:frontend/screensNisit/returnPoint.dart';
import 'package:frontend/screensTeacher/addQuesMenu.dart';
import 'package:frontend/screensTeacher/addQuestion.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_choice.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_choice.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_choice.dart';
import 'package:frontend/screensTeacher/showAndEditQuestion.dart';
import 'package:frontend/screensTeacher/editQuestion.dart';
import 'package:frontend/screensTeacher/showStatOverall.dart';
import 'package:frontend/screensNisit/answerScreen.dart';
import 'package:frontend/screensGeneral/loginStudentScreen.dart';

final GoRouter myRouterConfig = GoRouter(
  initialLocation: "/register",
  // initialLocation: '/question/returnPoint',
  routes: [
    //general
    GoRoute(
      path: '/login',
      builder: (context, state) => const GoogleSignInScreen(),
    ),
    GoRoute(
      path: '/adminLogin',
      builder: (context, state) => LoginTeacherScreen(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      name: 'mainShowQuestion',
      path: '/mainShowQuestion',
      builder: (context, state) => const MainShowQuestion(),
    ),
    //nisit
    GoRoute(
      name: 'questionStart',
      path: '/question',
      builder: (context, state) {
        return ProbList(
          quesId: state.uri.queryParameters['id']!,
          round: 1,
        );
      },
      routes: [
        GoRoute(
          name: 'returnPoint',
          path: 'returnPoint',
          builder: (context, state) =>
              ReturnPointInit(quesId: state.uri.queryParameters['id']!),
          // builder: (context, state) => ReturnPointInit(quesId: 'tmpID'),
        ),
        GoRoute(
          name: 'questionAnswer',
          path: 'answer',
          builder: (context, state) =>
              AnswerInit(quesId: state.uri.queryParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      name: 'showStats',
      path: '/showStats',
      builder: (context, state) => const ShowStatsForNisit(),
    ),
    //teacher
    GoRoute(
      path: '/questionMenu',
      builder: (context, state) => AddQuesMenu(),
      routes: [
        GoRoute(
          path: 'addQuestion',
          builder: (context, state) => const AddQuestion(),
        ),
        GoRoute(
          path: 'editPredefined',
          builder: (context, state) => const EditPredefinedInit(),
          routes: [
            GoRoute(
              path: 'treatment',
              builder: (context, state) => const EditTreatmentInit(),
            ),
            GoRoute(
              path: 'exam',
              builder: (context, state) => const EditExamInit(),
            ),
            GoRoute(
              name: 'editPredefinedOther',
              path: ':title',
              builder: (context, state) {
                String myTitle = '';
                if (state.pathParameters['title'] == 'Differential') {
                  myTitle = 'Differential Diagnosis';
                } else if (state.pathParameters['title'] ==
                    'TentativeAndDefinitive') {
                  myTitle = 'Tentative/Definitive Diagnosis';
                } else {
                  myTitle = state.pathParameters['title']!;
                }
                return EditOtherInit(title: myTitle);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'showQuestion',
      path: '/showQuestion',
      builder: (context, state) => ShowAndEditQuestion(
        quesId: state.uri.queryParameters['id']!,
      ),
      routes: [
        GoRoute(
          name: 'editQuestion',
          path: 'edit',
          builder: (context, state) =>
              EditQuestion(quesId: state.uri.queryParameters['id']!),
        ),
        GoRoute(
          name: 'statOverall',
          path: 'stat',
          builder: (context, state) =>
              ShowStatOverall(quesId: state.uri.queryParameters['id']!),
        ),
      ],
    ),
  ],
  // redirect: (context, state) {
  //   if (state.matchedLocation == '/question') {
  //     print('hello from redirect');
  //     return '/question';
  //   }
  //   return null;
  // },
  errorBuilder: (context, state) => const ErrorScreen(),
);
