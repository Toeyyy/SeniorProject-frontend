import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_name.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:frontend/AllDataFile.dart';

class EditPredefinedExamLab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);
    // examProvider.assignItem(preDefinedExamAll);
    examProvider.assignItem(examListPreDefined);
    List<ExamPreDefinedObject> examList = examProvider.examList;

    Map<String, List<ExamPreDefinedObject>> groupedByLab =
        examProvider.groupedByLab;

    Map<String, List<ExamPreDefinedObject>> getGroupByLab(String labName) {
      return groupBy(groupedByLab[labName]!, (e) => e.type);
    }

    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  'เลือกแผนกการตรวจ',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: groupedByLab.length,
                    itemBuilder: (context, index) {
                      String title = groupedByLab.keys.elementAt(index);
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          examProvider.assignCurrentLabList(title);
                          Map<String, List<ExamPreDefinedObject>> sendingList =
                              getGroupByLab(title);
                          examProvider.currentLabList = sendingList;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPreDefinedExamType(
                                selectedLab: title,
                                groupedByType: sendingList,
                              ),
                            ),
                          );
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

class EditPreDefinedExamType extends StatefulWidget {
  String selectedLab;
  Map<String, List<ExamPreDefinedObject>> groupedByType;
  EditPreDefinedExamType(
      {required this.selectedLab, required this.groupedByType});

  @override
  State<EditPreDefinedExamType> createState() => _EditPreDefinedExamTypeState();
}

class _EditPreDefinedExamTypeState extends State<EditPreDefinedExamType> {
  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);

    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  widget.selectedLab,
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: widget.groupedByType.length,
                    // itemCount: groupedExam,
                    itemBuilder: (context, index) {
                      String title = widget.groupedByType.keys.toList()[index];
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        // title: Text(groupedByType.keys.elementAt(index)),
                        title: Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPredefinedExamName(
                                selectedType: title,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // MyBackButton(myContext: context),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B72BE),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
