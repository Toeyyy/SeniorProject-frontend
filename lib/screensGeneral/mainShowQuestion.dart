import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/screensGeneral/fullQuestionCard.dart';
import 'package:frontend/screensGeneral/questionCard.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/components/tagSearchBox.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frontend/my_secure_storage.dart';

class MainShowQuestion extends StatefulWidget {
  // int role;
  //0 = nisit, 1 = teacher
  const MainShowQuestion({super.key});

  @override
  State<MainShowQuestion> createState() => _MainShowQuestionState();
}

class _MainShowQuestionState extends State<MainShowQuestion> {
  List<QuestionObject> questionObjList = [];
  List<QuestionObject> displayList = [];
  List<FullQuestionObject> teacherQuestionObjList = [];
  List<FullQuestionObject> teacherDisplayList = [];
  List<TagObject> selectedTags = [];
  bool _draftCheckBoxStatus = false;
  bool _isLoadData = true;
  late String userRole;

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
    userRole = await MySecureStorage().readSecureData('userRole');
    await fetchPreDefinedProb();
    await fetchPreDefinedDiag();
    await fetchPreDefinedExam();
    await fetchPreDefinedTag();
    await fetchPreDefinedTreatment();
    if (userRole == '0') {
      List<QuestionObject> loadedData = await fetchQuestionList();
      setState(() {
        nisitQuestionList = loadedData;
        questionObjList = loadedData;
        displayList = loadedData;
      });
    } else {
      await fetchFullQuestionList();
      setState(() {
        teacherQuestionObjList = teacherQuestionList;
        teacherDisplayList = teacherQuestionList;
      });
    }
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController quesSearchController = TextEditingController();

    void updateTagList(List<TagObject> newList) {
      selectedTags = newList;
      setState(() {
        _draftCheckBoxStatus = false;
        if (userRole == '0') {
          displayList =
              filterFromTags(questionObjList, newList).cast<QuestionObject>();
        } else {
          teacherDisplayList = filterFromTags(teacherQuestionObjList, newList)
              .cast<FullQuestionObject>();
        }
      });
    }

    void updateDraft(bool checkBoxStat) {
      if (checkBoxStat == true) {
        setState(() {
          teacherDisplayList = teacherDisplayList
              .where((element) => element.status == 0)
              .toList();
        });
      } else {
        setState(() {
          updateTagList(selectedTags);
        });
      }
    }

    return !_isLoadData
        ? Scaffold(
            appBar: userRole == '0'
                ? const AppbarNisit() as PreferredSizeWidget
                : const AppbarTeacher() as PreferredSizeWidget,
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'เลือกโจทย์',
                                    style: kHeaderTextStyle,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: quesSearchController,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        labelText: 'ค้นหารหัสโจทย์',
                                        labelStyle: TextStyle(fontSize: 20),
                                      ),
                                      onEditingComplete: () {
                                        if (userRole == '0') {
                                          setState(() {
                                            displayList = filterFromQuesName(
                                                    questionObjList,
                                                    quesSearchController.text)
                                                .cast<QuestionObject>();
                                          });
                                        } else {
                                          setState(() {
                                            teacherDisplayList =
                                                filterFromQuesName(
                                                        teacherQuestionList,
                                                        quesSearchController
                                                            .text)
                                                    .cast<FullQuestionObject>();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        userRole == '1'
                            ? Row(
                                children: [
                                  Checkbox(
                                      value: _draftCheckBoxStatus,
                                      onChanged: (newValue) {
                                        _draftCheckBoxStatus = newValue!;
                                        updateDraft(newValue);
                                      }),
                                  const Text('Show only draft questions'),
                                ],
                              )
                            : const SizedBox(),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        TagSearchBox(
                            initTags: selectedTags,
                            updateListCallback: updateTagList),
                        const SizedBox(
                          height: 20,
                        ),
                        _isLoadData == false
                            ? userRole == '0'
                                ? displayList.isNotEmpty
                                    ? MasonryGridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2,
                                        itemCount: displayList.length,
                                        itemBuilder: (context, index) {
                                          return QuestionCard(
                                              questionObj: displayList[index]);
                                        })
                                    : const SizedBox()
                                : teacherDisplayList.isNotEmpty
                                    ? MasonryGridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2,
                                        itemCount: teacherDisplayList.length,
                                        itemBuilder: (context, index) {
                                          return FullQuestionCard(
                                            questionObj:
                                                teacherDisplayList[index],
                                          );
                                        })
                                    : const SizedBox()
                            : const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()));
  }
}
