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
      title: SizedBox(
        height: 50,
        child: IconButton(
          onPressed: () {
            context.go('/mainShowQuestion');
          },
          icon: Image.asset('assets/images/project_logo_lined.png'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.go('/mainShowQuestion');
          },
          child: const Text('โจทย์', style: kAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            context.go('/showStats');
          },
          child: const Text('สถิติ', style: kAppBarTextStyle),
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
            style: kAppBarTextStyle,
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
      title: SizedBox(
        height: 50,
        child: IconButton(
          onPressed: () {
            context.go('/mainShowQuestion');
          },
          icon: Image.asset('assets/images/project_logo_lined.png'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.go('/mainShowQuestion');
          },
          child: const Text('โจทย์', style: kAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            context.go('/questionMenu');
          },
          child: const Text('เพิ่มโจทย์', style: kAppBarTextStyle),
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
            style: kAppBarTextStyle,
          ),
        ),
      ],
    );
  }
}
