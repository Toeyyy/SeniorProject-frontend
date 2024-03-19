import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_add.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_detail.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';

class EditExamInit extends StatefulWidget {
  const EditExamInit({super.key});

  @override
  State<EditExamInit> createState() => _EditExamInitState();
}

class _EditExamInitState extends State<EditExamInit> {
  bool _isLoadData = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoadData = true;
    });
    getExams();
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadData
        ? const Center(
            child: SizedBox(width: 30, child: CircularProgressIndicator()))
        : EditPreDefinedExamChoice();
  }
}

class EditPreDefinedExamChoice extends StatelessWidget {
  final List<String> _topicList = [
    'เพิ่ม Examination',
    'แก้ไข/ลบ Examination',
  ];

  EditPreDefinedExamChoice({super.key});

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
                  'Examination List',
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
                          if (_topicList[index] == 'เพิ่ม Examination') {
                            await fetchPreDefinedExam().then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditPreDefinedExamAdd(),
                                ),
                              );
                            });
                          } else if (_topicList[index] ==
                              'แก้ไข/ลบ Examination') {
                            await fetchPreDefinedExam().then((value) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditPredefinedExamLab(),
                                    ),
                                  )
                                });
                          }
                        },
                      );
                    },
                  ),
                ),
                MyCancelButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
