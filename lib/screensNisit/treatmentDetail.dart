import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/components/appBar.dart';

class TreatmentDetail extends StatelessWidget {
  final String topic;

  TreatmentDetail(this.topic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
          leftPart: LeftPartContent(),
          rightPart: RightPart_TreatmentDetail(
            topic: topic,
          )),
    );
  }
}

class RightPart_TreatmentDetail extends StatefulWidget {
  final String topic;

  RightPart_TreatmentDetail({required this.topic});

  @override
  State<RightPart_TreatmentDetail> createState() =>
      _RightPart_TreatmentDetailState();
}

class _RightPart_TreatmentDetailState extends State<RightPart_TreatmentDetail> {
  TextEditingController _searchController = TextEditingController();
  List<String> _displayList = [];
  bool _isListViewVisible = false;

  List<String> getTreatmentList(String topic) {
    if (topic == 'Medical Treatment') {
      return M_treatmentList;
    } else if (topic == 'Surgical Treatment') {
      return S_treatmentList;
    } else if (topic == 'Nutritional Support') {
      return N_treatmentList;
    } else {
      return O_treatmentList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.topic,
            style: kHeaderTextStyle,
          ),
          TextField(
            controller: _searchController,
            onChanged: (query) {
              setState(() {
                _isListViewVisible = true;
                _displayList = filterList(
                  _searchController,
                  getTreatmentList(widget.topic),
                );
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
          Expanded(
            child: Visibility(
              visible: _isListViewVisible,
              child: ListView.builder(
                itemCount: _displayList.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Color(0xFFE7F9FF),
                    child: ListTile(
                        title: Text(_displayList[index]),
                        onTap: () {
                          print(_displayList[index]);
                        }),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFF8B72BE),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }
}
