import 'package:frontend/my_secure_storage.dart';
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
import 'package:frontend/screensGeneral/emailConfirmationScreen.dart';
import 'package:frontend/screensGeneral/emailConfirmSuccessScreen.dart';

final GoRouter myRouterConfig = GoRouter(
  // initialLocation: "/adminLogin",
  initialLocation: '/login',
  routes: [
    //general
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginStudentScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    // GoRoute(
    //   path: '/confirmEmail',
    //   builder: (context, state) => EmailConfirmSuccess(
    //       code: state.uri.queryParameters['id2']!,
    //       id: state.uri.queryParameters['id1']!),
    // ),
    GoRoute(
      path: '/adminLogin',
      builder: (context, state) => const LoginTeacherScreen(),
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
        if (state.uri.queryParameters.isEmpty) {
          return const ErrorScreen();
        }
        return ProbList(
          quesId: state.uri.queryParameters['id']!,
          round: 1,
        );
      },
      routes: [
        GoRoute(
            name: 'returnPoint',
            path: 'returnPoint',
            builder: (context, state) {
              if (state.uri.queryParameters.isEmpty) {
                return const ErrorScreen();
              }
              return ReturnPointInit(quesId: state.uri.queryParameters['id']!);
            }),
        GoRoute(
            name: 'questionAnswer',
            path: 'answer',
            builder: (context, state) {
              if (state.uri.queryParameters.isEmpty) {
                return const ErrorScreen();
              }
              return AnswerInit(quesId: state.uri.queryParameters['id']!);
            }),
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
      builder: (context, state) {
        if (state.uri.queryParameters.isEmpty) {
          return const ErrorScreen();
        }
        return ShowAndEditQuestion(
          quesId: state.uri.queryParameters['id']!,
        );
      },
      routes: [
        GoRoute(
            name: 'editQuestion',
            path: 'edit',
            builder: (context, state) {
              if (state.uri.queryParameters.isEmpty) {
                return const ErrorScreen();
              }
              return EditQuestion(quesId: state.uri.queryParameters['id']!);
            }),
        GoRoute(
            name: 'statOverall',
            path: 'stat',
            builder: (context, state) {
              if (state.uri.queryParameters.isEmpty) {
                return const ErrorScreen();
              }
              return ShowStatOverall(quesId: state.uri.queryParameters['id']!);
            }),
      ],
    ),
  ],
  redirect: (context, state) async {
    String currentLocation = state.matchedLocation.toLowerCase();
    bool isOnLogIn = currentLocation == '/login';
    bool isOnAdminLogin = currentLocation == '/adminlogin';
    bool isOnRegister = currentLocation == '/register';
    // bool isOnEmailConfirm = currentLocation == '/confirmemail';
    String? status = await MySecureStorage().storage.read(key: 'accessToken');
    String? role = await MySecureStorage().storage.read(key: 'userRole');
    bool isLogin = status != null && status.isNotEmpty;

    bool isOnNisitPage = currentLocation == '/question' ||
        currentLocation == '/question/returnpoint' ||
        currentLocation == '/question/answer' ||
        currentLocation == '/showstats';

    bool isOnAdminPage = currentLocation == '/questionmenu' ||
        currentLocation == '/questionmenu/addquestion' ||
        currentLocation == '/questionmenu/editpredefined' ||
        currentLocation == '/questionmenu/editpredefined/exam' ||
        currentLocation == '/questionmenu/editpredefined/treatment' ||
        currentLocation == '/questionmenu/editpredefined/problem' ||
        currentLocation == '/questionmenu/editpredefined/differential' ||
        currentLocation ==
            '/questionmenu/editpredefined/tentativeanddefinitive' ||
        currentLocation == '/questionmenu/editpredefined/tag' ||
        currentLocation == '/showquestion' ||
        currentLocation == '/showquestion/edit' ||
        currentLocation == '/showquestion/stat';

    print('isLogin = $isLogin');

    if (isOnAdminLogin && !isLogin) {
      return '/adminLogin';
    } else if (!isLogin && !isOnLogIn && !isOnAdminLogin && !isOnRegister) {
      return '/login';
    } else if (isLogin && role == '0' && isOnAdminPage) {
      return '/mainShowQuestion';
    } else if (isLogin && role == '1' && isOnNisitPage) {
      return '/mainShowQuestion';
    }
    return null;
  },
  errorBuilder: (context, state) => const ErrorScreen(),
);
