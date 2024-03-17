import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/UIModels/nisit/selected_diagnosis_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/screensNisit/examScreens/exam_topics.dart';
import 'package:frontend/UIModels/nisit/selected_problem_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';

class DiffDiag extends StatelessWidget {
  QuestionObject questionObj;
  DiffDiag({super.key, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    // SelectedQuestion questionProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: const AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(
          questionObj: questionObj,
          addedContent: TitleAndDottedListView(
              title: 'Problem List ครั้งที่ 1',
              showList:
                  problemProvider.problemAnsList1.map((e) => e.name).toList()),
        ),
        rightPart:
            // Text('tmp')
            RightPart_DiffDiag(
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPart_DiffDiag extends StatefulWidget {
  QuestionObject questionObj;

  RightPart_DiffDiag({super.key, required this.questionObj});

  @override
  State<RightPart_DiffDiag> createState() => _RightPart_DiffDiagState();
}

class _RightPart_DiffDiagState extends State<RightPart_DiffDiag> {
  final TextEditingController _searchController = TextEditingController();
  List<DiagnosisObject> _displayList = [];
  final List<DiagnosisObject> _fullList =
      groupBy(diagnosisListPreDefined, (e) => e.type)['differential']!;
  List<DiagnosisObject> _selectedList = [];
  bool _isListViewVisible = false;

  @override
  Widget build(BuildContext context) {
    SelectedDiagnosis diagProvider = Provider.of<SelectedDiagnosis>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: widget.questionObj != null
          ? Column(
              children: [
                const Text(
                  'Differential Diagnosis',
                  style: kHeaderTextStyle,
                ),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _isListViewVisible = true;
                      _displayList =
                          filterDiagnosisList(_searchController, _fullList);
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
                              _selectedList.add(_displayList[index]);
                              _searchController.clear();
                              setState(() {
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
                    //go to exam
                    diagProvider.assignList(_selectedList, 'diff');
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamTopic(
                          questionObj: widget.questionObj,
                        ),
                      ),
                    );
                  },
                  child: const Text('ยืนยัน'),
                ),
              ],
            )
          : const Center(
              child: SizedBox(
                width: 10,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
