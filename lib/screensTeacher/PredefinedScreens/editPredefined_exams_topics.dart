import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exams_name.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exams_area.dart';
import 'package:provider/provider.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';

class EditPredefinedExamLab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreDefinedExamProvider examProvider =
        Provider.of<PreDefinedExamProvider>(context);
    examProvider.assignItem(preDefinedExamAll);
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
    // bool areaNull = false;
    //
    // void checkArea(String title) {
    //   List<ExamPreDefinedObject> groupedType = widget.groupedByType[title]!;
    //   setState(() {
    //     areaNull = true;
    //   });
    //   for (ExamPreDefinedObject item in groupedType) {
    //     if (item.area != null) {
    //       setState(() {
    //         areaNull = false;
    //       });
    //       break;
    //     }
    //   }
    // }

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
                          // checkArea(title);
                          // // print('areaNull = $areaNull');
                          // areaNull
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPredefinedExamName(
                                selectedType: title,
                              ),
                              // groupedExam: ,
                            ),
                          );
                          // : Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           EditPreDefinedExamChoice(
                          //               selectedType: title),
                          //     ),
                          //   );
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

class EditPreDefinedExamChoice extends StatelessWidget {
  String selectedType;

  EditPreDefinedExamChoice({required this.selectedType});

  List<String> choiceList = [
    'Area',
    'Name',
  ];

  @override
  Widget build(BuildContext context) {
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
                  selectedType,
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(choiceList[index]),
                        onTap: () {
                          if (choiceList[index] == 'Name') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPredefinedExamName(
                                  selectedType: selectedType,
                                ),
                                // groupedExam: ,
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPredefinedExamArea(
                                    selectedType: selectedType),
                              ),
                            );
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
