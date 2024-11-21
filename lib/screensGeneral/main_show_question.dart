import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/screensGeneral/full_question_card.dart';
import 'package:frontend/screensGeneral/question_card.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/components/tag_search_box.dart';
import 'package:frontend/models/tag_object.dart';
import 'package:frontend/models/full_question_object.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frontend/my_secure_storage.dart';

class MainShowQuestion extends StatefulWidget {
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
  late int totalCard = 0;
  int cardPerPage = 8;
  late int pageCount = 0;
  int currentPage = 0;

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
        questionObjList = loadedData;
        displayList = loadedData;
        totalCard = questionObjList.length;
        pageCount = (totalCard / cardPerPage).ceil();
      });
    } else {
      await fetchFullQuestionList();
      setState(() {
        teacherQuestionObjList = teacherQuestionList;
        teacherDisplayList = teacherQuestionList;
        totalCard = teacherQuestionObjList.length;
        pageCount = (totalCard / cardPerPage).ceil();
      });
    }
    setState(() {
      _isLoadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController quesSearchController = TextEditingController();

    void updateTagList(List<TagObject> newList, [bool? isFiltered]) {
      isFiltered ??= false;
      selectedTags = newList;
      setState(() {
        _draftCheckBoxStatus = false;
        if (userRole == '0') {
          if (!isFiltered!) {
            displayList =
                filterFromTags(questionObjList, newList).cast<QuestionObject>();
          } else {
            displayList =
                filterFromTags(displayList, newList).cast<QuestionObject>();
          }
          totalCard = displayList.length;
          pageCount = (totalCard / cardPerPage).ceil();
        } else {
          if (!isFiltered!) {
            teacherDisplayList = filterFromTags(teacherQuestionObjList, newList)
                .cast<FullQuestionObject>();
          } else {
            teacherDisplayList = filterFromTags(teacherDisplayList, newList)
                .cast<FullQuestionObject>();
          }
          totalCard = teacherDisplayList.length;
          pageCount = (totalCard / cardPerPage).ceil();
        }
      });
    }

    void updateDraft(bool checkBoxStat) {
      if (checkBoxStat == true) {
        setState(() {
          teacherDisplayList = teacherDisplayList
              .where((element) => element.status == 0)
              .toList();
          currentPage = 0;
          totalCard = teacherDisplayList.length;
          pageCount = (totalCard / cardPerPage).ceil();
        });
      } else {
        setState(() {
          currentPage = 0;
          teacherDisplayList = teacherQuestionList;
          updateTagList(selectedTags);
          totalCard = teacherDisplayList.length;
          pageCount = (totalCard / cardPerPage).ceil();
        });
      }
    }

    void upDateTextField() {
      if (userRole == '0') {
        setState(() {
          displayList =
              filterFromQuesName(questionObjList, quesSearchController.text)
                  .cast<QuestionObject>();
          updateTagList(selectedTags, true);
          totalCard = displayList.length;
          pageCount = (totalCard / cardPerPage).ceil();
        });
      } else {
        setState(() {
          teacherDisplayList = filterFromQuesName(
                  teacherQuestionObjList, quesSearchController.text)
              .cast<FullQuestionObject>();
          updateTagList(selectedTags, true);
          totalCard = teacherDisplayList.length;
          pageCount = (totalCard / cardPerPage).ceil();
        });
      }
    }

    previousPage() {
      setState(() {
        currentPage -= 1;
      });
    }

    nextPage() {
      setState(() {
        currentPage += 1;
      });
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
                                        upDateTextField();
                                        quesSearchController.text =
                                            quesSearchController.text;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: _draftCheckBoxStatus,
                                          onChanged: (newValue) {
                                            _draftCheckBoxStatus = newValue!;
                                            updateDraft(newValue);
                                          }),
                                      const Text('Show only draft questions'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      currentPage > 0
                                          ? IconButton(
                                              onPressed: () {
                                                previousPage();
                                              },
                                              icon: const Icon(CupertinoIcons
                                                  .chevron_left_circle),
                                            )
                                          : const SizedBox(),
                                      Text('หน้าที่ ${currentPage + 1}'),
                                      currentPage < pageCount - 1
                                          ? IconButton(
                                              onPressed: () {
                                                nextPage();
                                              },
                                              icon: const Icon(CupertinoIcons
                                                  .chevron_right_circle),
                                            )
                                          : const SizedBox(),
                                    ],
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  currentPage > 0
                                      ? IconButton(
                                          onPressed: () {
                                            previousPage();
                                          },
                                          icon: const Icon(CupertinoIcons
                                              .chevron_left_circle),
                                        )
                                      : const SizedBox(),
                                  Text('หน้าที่ ${currentPage + 1}'),
                                  currentPage < pageCount - 1
                                      ? IconButton(
                                          onPressed: () {
                                            nextPage();
                                          },
                                          icon: const Icon(CupertinoIcons
                                              .chevron_right_circle),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
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
                                        itemCount:
                                            displayList.length < cardPerPage
                                                ? displayList.length
                                                : cardPerPage,
                                        itemBuilder: (context, index) {
                                          return QuestionCard(
                                              questionObj: displayList[index +
                                                  (currentPage * cardPerPage)]);
                                        })
                                    : const SizedBox()
                                : teacherDisplayList.isNotEmpty
                                    ? MasonryGridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 2,
                                        itemCount: teacherDisplayList.length <
                                                cardPerPage
                                            ? teacherDisplayList.length
                                            : cardPerPage,
                                        itemBuilder: (context, index) {
                                          int realIndex = index +
                                              (currentPage * cardPerPage);
                                          FullQuestionObject? showCard;
                                          if (realIndex >
                                              teacherDisplayList.length - 1) {
                                            showCard = null;
                                          } else {
                                            showCard =
                                                teacherDisplayList[realIndex];
                                          }
                                          return showCard != null
                                              ? FullQuestionCard(
                                                  questionObj: showCard,
                                                )
                                              : const SizedBox();
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
