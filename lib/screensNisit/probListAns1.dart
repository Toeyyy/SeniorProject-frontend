import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/problemListObject.dart';

class ProbListAns1 extends StatelessWidget {
  List<ProblemObject> userProbList = [
    ProblemObject(id: '1', name: 'problem List 1'),
    ProblemObject(id: '1', name: 'problem List 3'),
    ProblemObject(id: '1', name: 'problem List 4'),
    ProblemObject(id: '1', name: 'problem List 7'),
    ProblemObject(id: '1', name: 'problem List 9'),
    ProblemObject(id: '1', name: 'problem List 10'),
    ProblemObject(id: '1', name: 'problem List 13'),
  ];

  List<ProblemObject> correctProbList = [
    ProblemObject(id: '1', name: 'problem List 1'),
    ProblemObject(id: '1', name: 'problem List 2'),
    ProblemObject(id: '1', name: 'problem List 5'),
    ProblemObject(id: '1', name: 'problem List 7'),
    ProblemObject(id: '1', name: 'problem List 10'),
  ];

  // final List<String> userProbList = [
  //   'problem List 1',
  //   'problem List 3',
  //   'problem List 4',
  //   'problem List 7',
  //   'problem List 9',
  //   'problem List 10',
  //   'problem List 11',
  //   'problem List 13',
  //   'problem List 15',
  // ];
  //
  // List<String> correctProbList = [
  //   'problem List 1',
  //   'problem List 2',
  //   'problem List 5',
  //   'problem List 7',
  //   'problem List 10',
  // ];

  ListView showAnsProbList(
      List<ProblemObject> ansList, List<ProblemObject> actualList) {
    List<bool> checkList = [];
    for (ProblemObject item in actualList) {
      if (ansList.map((e) => e.name).toList().contains(item.name))
        checkList.add(true);
      else
        checkList.add(false);
    }
    return ListView.builder(
      itemCount: actualList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            actualList[index].name,
            style: TextStyle(
              color: checkList[index] ? Color(0xFF42C2FF) : Color(0xFF16302B),
            ),
          ),
          trailing: checkList[index]
              ? Icon(
                  Icons.check,
                  color: Color(0xFF42C2FF),
                )
              : Icon(
                  Icons.close,
                  color: Color(0xFF16302B),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Text(
                'Correct Problem List',
                style: kHeaderTextStyle,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: correctProbList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(correctProbList[index].name),
                      leading: Icon(
                        Icons.circle,
                        size: 15,
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Your Problem List',
                style: kHeaderTextStyle,
              ),
              Expanded(
                child: showAnsProbList(correctProbList, userProbList),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('ส่งตรวจ'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
