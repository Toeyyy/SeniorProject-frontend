import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';

class ProbListAns1 extends StatelessWidget {
  List<String> userProbList = [
    'problem List 1',
    'problem List 3',
    'problem List 4',
    'problem List 7',
    'problem List 9',
    'problem List 10',
    'problem List 11',
    'problem List 13',
    'problem List 15',
  ];

  List<String> correctProbList = [
    'problem List 1',
    'problem List 2',
    'problem List 5',
    'problem List 7',
    'problem List 10',
  ];

  ListView showAnsProbList(List<String> ansList, List<String> actualList) {
    List<bool> checkList = [];
    for (String l in actualList) {
      if (ansList.contains(l))
        checkList.add(true);
      else
        checkList.add(false);
    }
    return ListView.builder(
      itemCount: actualList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            actualList[index],
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
                      title: Text(correctProbList[index]),
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
