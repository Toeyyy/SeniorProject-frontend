import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/problemListObject.dart';

class ProbList extends StatelessWidget {
  String round;

  ProbList({required this.round});

  // String round;
  //
  // ProbList1({required this.round});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: RightPart_ProbList(round: round),
      ),
    );
  }
}

class RightPart_ProbList extends StatefulWidget {
  String round;
  RightPart_ProbList({required this.round});

  @override
  State<RightPart_ProbList> createState() => _RightPart_ProbListState();
}

class _RightPart_ProbListState extends State<RightPart_ProbList> {
  List<bool> selectedBool =
      List.generate(probObjectList.length, (index) => false);
  TextEditingController _searchController = TextEditingController();
  List<ProblemObject> selectedList = [];
  List<ProblemObject> displayList = probObjectList;

  void updateList(List<ProblemObject> newList, String round) {
    selectedList = newList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Text(
            'เลือก Problem List ครั้งที่${widget.round}',
            style: kSubHeaderTextStyle,
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                displayList =
                    filterProblemList(_searchController, probObjectList);
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ค้นหา Problem List',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                int oriIndex = probObjectList.indexOf(displayList[index]);
                return ListTile(
                  title: Text(displayList[index].name),
                  leading: Checkbox(
                    value: selectedBool[oriIndex],
                    onChanged: (newValue) {
                      setState(() {
                        selectedBool[oriIndex] = newValue!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print(filterProblemList(_searchController, probObjectList));
              print(displayList);
            },
            child: Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}
