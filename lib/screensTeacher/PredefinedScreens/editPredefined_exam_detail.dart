import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam_name.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';

class EditPredefinedExamLab extends StatelessWidget {
  const EditPredefinedExamLab({super.key});

  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);
    examProvider.assignItem(examListPreDefined);
    List<ExamPreDefinedObject> examList = examProvider.examList;

    Map<String, List<ExamPreDefinedObject>> groupedByLab =
        examProvider.groupedByLab;

    Map<String, List<ExamPreDefinedObject>> getGroupByLab(String labName) {
      return groupBy(groupedByLab[labName]!, (e) => e.type);
    }

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
                  'เลือกแผนกการตรวจ',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: groupedByLab.length,
                    itemBuilder: (context, index) {
                      String title = groupedByLab.keys.elementAt(index);
                      return ListTile(
                        tileColor: const Color(0xFFA0E9FF),
                        hoverColor: const Color(0xFF42C2FF),
                        title: Text(
                          title,
                          style: const TextStyle(
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
      {super.key, required this.selectedLab, required this.groupedByType});

  @override
  State<EditPreDefinedExamType> createState() => _EditPreDefinedExamTypeState();
}

class _EditPreDefinedExamTypeState extends State<EditPreDefinedExamType> {
  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);

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
                  widget.selectedLab,
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: widget.groupedByType.length,
                    itemBuilder: (context, index) {
                      String title = widget.groupedByType.keys.toList()[index];
                      return ListTile(
                        tileColor: const Color(0xFFA0E9FF),
                        hoverColor: const Color(0xFF42C2FF),
                        title: Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () async {
                          await fetchPreDefinedExam().then((value) {
                            examProvider.updateGroupedList(widget.selectedLab);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPredefinedExamName(
                                  selectedType: title,
                                ),
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B72BE),
                  ),
                  child: const Text(
                    'ยกเลิก',
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
