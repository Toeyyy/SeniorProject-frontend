import 'package:go_router/go_router.dart';
import 'package:frontend/screensGeneral/loginScreen.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';
import 'package:frontend/screensGeneral/errorScreen.dart';

final GoRouter myRouterConfig = GoRouter(initialLocation: "/login", routes: [
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
      name: 'mainShowQuestion',
      path: '/mainShowQuestion',
      builder: (context, state) => const MainShowQuestion()),
  GoRoute(
    path: '/error',
    builder: (context, state) => const ErrorScreen(),
  ),
]);
