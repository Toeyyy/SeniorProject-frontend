import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/models/problemListObject.dart';

class ProbList1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: RightPart_ProbList1(),
      ),
    );
  }
}

class RightPart_ProbList1 extends StatefulWidget {
  const RightPart_ProbList1({super.key});

  @override
  State<RightPart_ProbList1> createState() => _RightPart_ProbList1State();
}

class _RightPart_ProbList1State extends State<RightPart_ProbList1> {
  List<bool> selectedItem = List.generate(probListSet.length, (index) => false);
  TextEditingController _searchController = TextEditingController();
  // List<String> probObjectList =
  //     probListSet.map((prob) => prob.problem).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Text(
            'เลือก Problem List',
            style: kSubHeaderTextStyle,
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ค้นหา Problem List',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterList(_searchController, probListSet).length,
              itemBuilder: (context, index) {
                int originalIndex = probListSet
                    .indexOf(filterList(_searchController, probListSet)[index]);
                return ListTile(
                  title:
                      Text(filterList(_searchController, probListSet)[index]),
                  leading: Checkbox(
                    value: selectedItem[originalIndex],
                    onChanged: (value) {
                      setState(() {
                        selectedItem[originalIndex] = value!;
                        if (value) {
                          String checkedItem = probListSet.removeAt(index);
                          probListSet.insert(0, checkedItem);
                          bool selected = selectedItem.removeAt(index);
                          selectedItem.insert(0, selected);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}
