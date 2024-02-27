import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensNisit/probListAns.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/UIModels/nisit/selected_exam_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';

class ProbList extends StatelessWidget {
  int round;
  QuestionObject questionObj;

  ProbList({super.key, required this.round, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: round == 1
            ? LeftPartContent(questionObj: questionObj)
            : LeftPartContent(
                questionObj: questionObj,
                addedContent: Column(
                  children: [
                    TitleAndDottedListView(
                        title: 'Problem List ครั้งที่ 1',
                        showList: problemProvider.problemAnsList1
                            .map((e) => e.name)
                            .toList()),
                    TitleAndExams(
                      title: 'Examination ครั้งที่ 1',
                      showList: examProvider.examList1,
                      resultList: examProvider.resultList1,
                    ),
                  ],
                ),
              ),
        rightPart: RightPart_ProbList(
          round: round,
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPart_ProbList extends StatefulWidget {
  int round;
  QuestionObject questionObj;

  RightPart_ProbList(
      {super.key, required this.round, required this.questionObj});

  @override
  State<RightPart_ProbList> createState() => _RightPart_ProbListState();
}

class _RightPart_ProbListState extends State<RightPart_ProbList> {
  List<bool> selectedBool =
      List.generate(problemListPreDefined.length, (index) => false);
  TextEditingController _searchController = TextEditingController();
  List<ProblemObject> _selectedList = [];
  late List<ProblemObject> _fullList = [];
  late List<ProblemObject> _displayList = _fullList;
  bool _isListViewVisible = false;
  late SelectedProblem problemProvider;
  late int heart;
  late List<ProblemObject> probAnsList;
  bool isLoadingData = false;

  void updateList(List<ProblemObject> newList, int round) {
    _selectedList = newList;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fullList = problemListPreDefined;
      problemProvider = Provider.of<SelectedProblem>(context, listen: false);
      getData();
    });
  }

  Future<void> getData() async {
    setState(() {
      isLoadingData = false;
    });
    List<ProblemObject> loadedData =
        await fetchProblemAns(widget.questionObj.id, widget.round);
    setState(() {
      probAnsList = loadedData;
      problemProvider.assignAnswer(loadedData, widget.round);
    });
    setState(() {
      isLoadingData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider = Provider.of<SelectedProblem>(context);

    void showModal(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFBBF5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('คำตอบไม่ถูกต้อง ต้องการเลือกใหม่หรือไม่',
                        style: kNormalTextStyle.copyWith(
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B72BE),
                          ),
                          child: const Text('เลือกคำตอบใหม่'),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProbListAns(
                                  round: widget.round,
                                  questionObj: widget.questionObj,
                                ),
                              ),
                            );
                          },
                          child: const Text('เฉลยคำตอบ'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: isLoadingData
          ? Column(
              children: [
                Text(
                  'เลือก Problem List ครั้งที่ ${widget.round}',
                  style: kSubHeaderTextStyle,
                ),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _isListViewVisible = true;
                      _displayList =
                          filterProblemList(_searchController, _fullList);
                      _displayList.sort((a, b) => a.name.compareTo(b.name));
                    });
                    if (query.isEmpty) {
                      setState(() {
                        _isListViewVisible = false;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                Visibility(
                  visible: _isListViewVisible,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: _displayList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            tileColor: const Color(0xFFE7F9FF),
                            hoverColor: const Color(0xFFA0E9FF),
                            title: Text(_displayList[index].name),
                            onTap: () {
                              setState(() {
                                _selectedList.add(_displayList[index]);
                                _searchController.clear();
                                _displayList.remove(_displayList[index]);
                                _isListViewVisible = false;
                              });
                            });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isListViewVisible,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: _selectedList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_selectedList[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                _displayList.add(_selectedList[index]);
                                _selectedList.remove(_selectedList[index]);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int heart = widget.round == 1
                        ? problemProvider.heart1
                        : problemProvider.heart2;
                    problemProvider.assignProblem(_selectedList, widget.round);
                    if (!problemProvider.checkProbAns(widget.round)) {
                      problemProvider.reduceHeart(widget.round);
                      if (heart > 1) {
                        // print('heart = $heart');
                        showModal(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProbListAns(
                              round: widget.round,
                              questionObj: widget.questionObj,
                            ),
                          ),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProbListAns(
                            round: widget.round,
                            questionObj: widget.questionObj,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('ยืนยัน'),
                ),
              ],
            )
          : const SizedBox(
              width: 10, child: Center(child: CircularProgressIndicator())),
    );
  }
}
