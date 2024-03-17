import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_add.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_other_edit.dart';
import 'package:go_router/go_router.dart';

class EditOtherInit extends StatefulWidget {
  String title;
  EditOtherInit({super.key, required this.title});

  @override
  State<EditOtherInit> createState() => _EditOtherInitState();
}

class _EditOtherInitState extends State<EditOtherInit> {
  bool _isLoadData = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoadData = true;
    });
    getProbDiagTag(widget.title);
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadData
        ? const Center(
            child: SizedBox(width: 30, child: CircularProgressIndicator()))
        : EditPreDefinedOtherChoice(title: widget.title);
  }
}

class EditPreDefinedOtherChoice extends StatelessWidget {
  final String title;
  EditPreDefinedOtherChoice({super.key, required this.title});

  final List<String> _topicList = [
    'เพิ่ม',
    'แก้ไข/ลบ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  title,
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: const Color(0xFFA0E9FF),
                        hoverColor: const Color(0xFF42C2FF),
                        title: Text(
                          _topicList[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () async {
                          if (_topicList[index] == 'เพิ่ม') {
                            await getProbDiagTag(title).then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPreDefinedOtherAdd(title: title),
                                ),
                              );
                            });
                            // context.goNamed(
                            //   'addOther',
                            //   pathParameters: {'title': title},
                            // );
                          } else if (_topicList[index] == 'แก้ไข/ลบ') {
                            await getProbDiagTag(title).then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPredefinedOtherEdit(title: title),
                                ),
                              );
                            });
                            // context.goNamed(
                            //   'editOther',
                            //   pathParameters: {'title': title},
                            // );
                          }
                        },
                      );
                    },
                  ),
                ),
                MyBackButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
