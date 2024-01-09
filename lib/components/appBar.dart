import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class AppbarNisit extends StatelessWidget implements PreferredSizeWidget {
  const AppbarNisit({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'App Name',
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('สถิติ', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: null,
          child: Text(
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
      title: Text(
        'App Name',
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('โจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {},
          child: Text('เพิ่มโจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: null,
          child: Text(
            'Log Out',
            style: KAppBarTextStyle,
          ),
        ),
      ],
    );
  }
}
