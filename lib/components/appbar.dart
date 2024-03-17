import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensTeacher/addQuesMenu.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';
import 'package:frontend/screensNisit/showStats.dart';
import 'package:go_router/go_router.dart';

class AppbarNisit extends StatelessWidget implements PreferredSizeWidget {
  const AppbarNisit({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'App Name',
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.go('/mainShowQuestion');
          },
          child: const Text('โจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            context.go('/showStats');
          },
          child: const Text('สถิติ', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            //TODO log out
          },
          child: const Text(
            'Log Out',
            style: KAppBarTextStyle,
          ),
        ),
      ],
    );
  }
}

class AppbarTeacher extends StatelessWidget implements PreferredSizeWidget {
  const AppbarTeacher({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'App Name',
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.go('/mainShowQuestion');
          },
          child: const Text('โจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            context.go('/questionMenu');
          },
          child: const Text('เพิ่มโจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            //TODO log out
          },
          child: const Text(
            'Log Out',
            style: KAppBarTextStyle,
          ),
        ),
      ],
    );
  }
}
