import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/my_secure_storage.dart';
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
            //log out
            MySecureStorage().storage.deleteAll();
            context.go('/login');
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
            //log out
            MySecureStorage().storage.deleteAll();
            context.go('/adminLogin');
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
