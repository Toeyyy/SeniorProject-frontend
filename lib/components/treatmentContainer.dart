import 'package:flutter/material.dart';
import '../tmpQuestion.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/UIModels/treatmentContainer_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';

class TreatmentContainer extends StatefulWidget {
  final int id;
  final Key key;
  String selectedTreatmentTopic;
  String selectedTreatmentDetail;

  TreatmentContainer(
      {required this.id,
      required this.key,
      required this.selectedTreatmentTopic,
      required this.selectedTreatmentDetail})
      : super(key: key);

  @override
  State<TreatmentContainer> createState() => _TreatmentContainerState();

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is TreatmentContainer &&
  //         runtimeType == other.runtimeType &&
  //         id == other.id &&
  //         key == other.key;
  //
  // @override
  // int get hashCode => id.hashCode ^ key.hashCode;
}

class _TreatmentContainerState extends State<TreatmentContainer> {
  // String selectedTreatmentTopic = treatmentTopicList.first;
  // String selectedTreatmentDetail = medicalTreatmentList.first;

  @override
  Widget build(BuildContext context) {
    TreatmentContainerProvider treatmentProvider =
        Provider.of<TreatmentContainerProvider>(context);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFA0E9FF)),
      child: Column(
        // key: widget.key,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedTreatmentTopic,
                  list: treatmentTopicList,
                  onChanged: (value) {
                    setState(() {
                      widget.selectedTreatmentTopic = value.toString();
                      widget.selectedTreatmentDetail =
                          filterTreatment(widget.selectedTreatmentTopic).first;
                    });
                  }),
              IconButton(
                onPressed: () {
                  print('this container id = ${widget.id}');
                  treatmentProvider.deleteContainer(widget.id, widget.key);
                },
                icon: Icon(Icons.remove),
              ),
            ],
          ),
          const H20Sizedbox(),
          DropDownButtonInAddQ(
              selectedValue: widget.selectedTreatmentDetail,
              list: filterTreatment(widget.selectedTreatmentTopic),
              onChanged: (value) {
                setState(() {
                  widget.selectedTreatmentTopic = value.toString();
                });
              }),
        ],
      ),
    );
  }
}

class ShowTreatmentContainer extends StatelessWidget {
  String treatmentTopic;
  String treatment;

  ShowTreatmentContainer(
      {required this.treatmentTopic, required this.treatment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'ประเภท Treatment',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(width: 10),
                Text(treatmentTopic, style: kNormalTextStyle),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  'Treatment',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(width: 10),
                Text(treatment, style: kNormalTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
