import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensTeacher/addQuesMenu.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';
import 'package:frontend/screensNisit/showStats.dart';

class AppbarNisit extends StatelessWidget implements PreferredSizeWidget {
  const AppbarNisit({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainShowQuestion(role: 0),
                ),
              );
            },
            child: Text('โจทย์')),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            //statistic page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowStatsForNisit(),
              ),
            );
          },
          child: Text('สถิติ', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            //TODO log out
          },
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainShowQuestion(role: 1),
              ),
            );
          },
          child: Text('โจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuesMenu(),
              ),
            );
          },
          child: Text('เพิ่มโจทย์', style: KAppBarTextStyle),
        ),
        kVerticalDividerInAppBar,
        TextButton(
          onPressed: () {
            //TODO log out
          },
          child: Text(
            'Log Out',
            style: KAppBarTextStyle,
          ),
        ),
      ],
    );
  }
}
