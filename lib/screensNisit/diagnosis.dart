import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/tmpQuestion.dart';

class Diagnosis extends StatelessWidget {
  const Diagnosis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: RightPart_Diagnosis(),
      ),
    );
  }
}

class RightPart_Diagnosis extends StatefulWidget {
  const RightPart_Diagnosis({super.key});

  @override
  State<RightPart_Diagnosis> createState() => _RightPart_DiagnosisState();
}

class _RightPart_DiagnosisState extends State<RightPart_Diagnosis> {
  TextEditingController _searchController = TextEditingController();
  // List<String> diagnosisList = [
  //   'kasjdfkhskjdf',
  //   'kjdfkadf',
  //   'iuyqieyriuiewr',
  //   'zcqifuhydhf',
  //   'aahcujghskgf',
  //   'acajfkdfwuearf',
  // ];
  List<DiagnosisObject> _displayList = [];
  List<DiagnosisObject> _selectedList = [];
  bool _isListViewVisible = false;

  @override
  Widget build(BuildContext context) {
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
                    filterDiagnosisList(_searchController, diagnosisList);
                _displayList.sort();
              });
              if (query.isEmpty) {
                setState(() {
                  _isListViewVisible = false;
                });
              }
            },
            decoration: InputDecoration(
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
                  return Container(
                    color: Color(0xFFE7F9FF),
                    child: ListTile(
                        title: Text(_displayList[index].name),
                        onTap: () {
                          _selectedList.add(_displayList[index]);
                          _searchController.clear();
                          setState(() {
                            diagnosisList.remove(_displayList[index]);
                            _displayList.remove(_displayList[index]);
                            _isListViewVisible = false;
                          });
                        }),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedList[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        _displayList.add(_selectedList[index]);
                        diagnosisList.add(_selectedList[index]);
                        _selectedList.remove(_selectedList[index]);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}
