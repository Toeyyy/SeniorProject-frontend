import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';
import 'package:frontend/UIModels/nisit/selectedDiagnosis_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/UIModels/nisit/selectedProblem_provider.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:frontend/components/BoxesInAddQ.dart';

class Diagnosis extends StatelessWidget {
  QuestionObject questionObj;

  Diagnosis({super.key, required this.questionObj});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider =
        Provider.of<SelectedExam>(context, listen: false);
    SelectedProblem problemProvider =
        Provider.of<SelectedProblem>(context, listen: false);
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(
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
              TitleAndDottedListView(
                  title: 'Problem List ครั้งที่ 2',
                  showList: problemProvider.problemAnsList2
                      .map((e) => e.name)
                      .toList()),
              TitleAndExams(
                title: 'Examination ครั้งที่ 2',
                showList: examProvider.examList2,
                resultList: examProvider.resultList2,
              ),
            ],
          ),
        ),
        rightPart: RightPart_Diagnosis(
          questionObj: questionObj,
        ),
      ),
    );
  }
}

class RightPart_Diagnosis extends StatefulWidget {
  QuestionObject questionObj;

  RightPart_Diagnosis({super.key, required this.questionObj});

  @override
  State<RightPart_Diagnosis> createState() => _RightPart_DiagnosisState();
}

class _RightPart_DiagnosisState extends State<RightPart_Diagnosis> {
  TextEditingController _searchController = TextEditingController();
  List<DiagnosisObject> _displayList = [];
  List<DiagnosisObject> _fullList = diagnosisListPreDefined;
  List<DiagnosisObject> _selectedList = [];
  bool _isListViewVisible = false;

  @override
  Widget build(BuildContext context) {
    SelectedDiagnosis diagProvider = Provider.of<SelectedDiagnosis>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tentative/Definitive Diagnosis',
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
                // separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return Container(
                    child: ListTile(
                        tileColor: Color(0xFFE7F9FF),
                        hoverColor: Color(0xFFA0E9FF),
                        title: Text(_displayList[index].name),
                        onTap: () {
                          _selectedList.add(_displayList[index]);
                          _searchController.clear();
                          setState(() {
                            // _fullList.remove(_displayList[index]);
                            _displayList.remove(_displayList[index]);
                            _isListViewVisible = false;
                          });
                        }),
                  );
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
                          // _fullList.add(_selectedList[index]);
                          _displayList.add(_selectedList[index]);
                          // diagnosisList.add(_selectedList[index]);
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
              //TODO go to treatment
              diagProvider.assignList(_selectedList);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => TreatmentTopic(),
              //   ),
              // );
              // Navigator.popAndPushNamed(context, '/Nisit/treatmentTopic');
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TreatmentTopic(questionObj: widget.questionObj),
                ),
              );
            },
            child: Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}
