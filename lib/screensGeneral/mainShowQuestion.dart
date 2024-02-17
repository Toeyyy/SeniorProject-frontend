import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/screensGeneral/fullQuestionCard.dart';
import 'package:frontend/screensGeneral/questionCard.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/components/tagSearchBox.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/AllDataFile.dart';

class MainShowQuestion extends StatefulWidget {
  int role;
  //0 = nisit, 1 = teacher
  MainShowQuestion({super.key, required this.role});

  @override
  State<MainShowQuestion> createState() => _MainShowQuestionState();
}

class _MainShowQuestionState extends State<MainShowQuestion> {
  List<QuestionObject> questionObjList = [];
  List<QuestionObject> displayList = [];
  List<FullQuestionObject> teacherQuestionObjList = [];
  List<FullQuestionObject> teacherDisplayList = [];

  bool _isLoadData = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    super.initState();
    setState(() {
      _isLoadData = true;
    });
    if (widget.role == 0) {
      List<QuestionObject> loadedData = await fetchQuestionList();
      await fetchPreDefinedProb();
      await fetchPreDefinedDiag();
      await fetchPreDefinedExam();
      await fetchPreDefinedTag();
      await fetchPreDefinedTreatment();
      // print('loaded data = ${loadedData[0].type}');
      setState(() {
        questionObjList = loadedData;
        displayList = loadedData;
      });
    } else {
      List<FullQuestionObject> loadedData = await fetchFullQuestionList();
      await fetchPreDefinedProb();
      await fetchPreDefinedDiag();
      await fetchPreDefinedExam();
      await fetchPreDefinedTag();
      await fetchPreDefinedTreatment();
      // print('loaded data = ${loadedData[0].type}');
      setState(() {
        teacherQuestionObjList = loadedData;
        teacherDisplayList = loadedData;
      });
    }
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TagObject> selectedTags = [];

    void updateTagList(List<TagObject> newList) {
      selectedTags = newList;
      setState(() {
        if (widget.role == 0) {
          displayList = filterFromTagsNisit(questionObjList, selectedTags);
        } else {
          teacherDisplayList =
              filterFromTagsTeacher(teacherQuestionObjList, selectedTags);
        }
      });
    }

    return Scaffold(
      appBar: widget.role == 0
          ? AppbarNisit() as PreferredSizeWidget
          : AppbarTeacher() as PreferredSizeWidget,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'เลือกโจทย์',
                              style: kHeaderTextStyle,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'ค้นหารหัสโจทย์',
                                  labelStyle: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: Text('โจทย์ยอดนิยม'),
                        // ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  TagSearchBox(
                      initTags: selectedTags,
                      updateListCallback: updateTagList),
                  SizedBox(
                    height: 20,
                  ),
                  _isLoadData == false
                      ? widget.role == 0
                          ? displayList.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8),
                                  itemCount: displayList.length,
                                  itemBuilder: (context, index) {
                                    return QuestionCard(
                                      questionObj: displayList[index],
                                      role: widget.role,
                                    );
                                  },
                                )
                              : SizedBox()
                          : teacherDisplayList.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8),
                                  itemCount: teacherDisplayList.length,
                                  itemBuilder: (context, index) {
                                    return FullQuestionCard(
                                      questionObj: teacherDisplayList[index],
                                      role: widget.role,
                                    );
                                  },
                                )
                              : SizedBox()
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
