import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/appBar.dart';
import 'package:collection/collection.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/UIModels/nisit/selectedTreatment_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensNisit/treatmentTotal.dart';

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
  List<TreatmentObject> _displayList = [];
  late List<TreatmentObject>? fullList = getList();
  bool _isListViewVisible = false;
  final Map<String, List<TreatmentObject>> _groupedByType =
      groupBy(preDefinedTreatmentAll, (e) => e.type);

  List<TreatmentObject>? getList() {
    String type = widget.topic.split(' ').length == 2
        ? widget.topic
        : widget.topic.split(' ')[0];
    return _groupedByType[type];
  }

  List<TreatmentObject> filterList(TextEditingController searchController,
      List<TreatmentObject> listForSearch) {
    String query = searchController.text.toLowerCase();
    return listForSearch
        .where((item) => item.name.toLowerCase().startsWith(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    SelectedTreatment treatmentProvider =
        Provider.of<SelectedTreatment>(context);

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
                _displayList = filterList(_searchController, fullList!);
                _displayList.sort((a, b) => a.name.compareTo(b.name));
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
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFFB5C1BE), width: 1.0),
                      ),
                      child: ListTile(
                          title: Text(_displayList[index].name),
                          trailing:
                              Text("${_displayList[index].cost.toString()}.-"),
                          hoverColor: Color(0xFFA0E9FF),
                          onTap: () {
                            treatmentProvider.addItem(_displayList[index]);
                            Navigator.popAndPushNamed(
                              context,
                              '/Nisit/treatmentTotal',
                            );
                          }),
                    ),
                  );
                },
              ),
            ),
          ),
          MyBackButton(myContext: context),
        ],
      ),
    );
  }
}
