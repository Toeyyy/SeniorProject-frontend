import 'package:flutter/material.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/components/functions.dart';
import 'package:frontend/UIModels/teacher/treatmentContainer_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/constants.dart';

class TreatmentContainer extends StatefulWidget {
  String id;
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
}

class _TreatmentContainerState extends State<TreatmentContainer> {
  String findID() {
    return treatmentListPreDefined
        .where((item) {
          return widget.selectedTreatmentTopic == item.type &&
              widget.selectedTreatmentDetail == item.name;
        })
        .toList()
        .first
        .id;
  }

  @override
  Widget build(BuildContext context) {
    TreatmentContainerProvider treatmentProvider =
        Provider.of<TreatmentContainerProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('เลือกหัวข้อ Treatment'),
                  DropDownButtonInAddQ(
                      selectedValue: widget.selectedTreatmentTopic,
                      list: getTreatmentTopic(),
                      hintText: "เลือกหัวข้อ Treatment",
                      onChanged: (value) {
                        setState(() {
                          widget.selectedTreatmentTopic = value.toString();
                          widget.selectedTreatmentDetail =
                              filterTreatment(widget.selectedTreatmentTopic)
                                  .first;
                          widget.id = findID();
                        });
                      }),
                ],
              ),
              IconButton(
                onPressed: () {
                  treatmentProvider.deleteContainer(widget.key);
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
          const H20Sizedbox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('เลือกชื่อ Treatment'),
              DropDownButtonInAddQ(
                  selectedValue: widget.selectedTreatmentDetail,
                  list: filterTreatment(widget.selectedTreatmentTopic),
                  hintText: "เลือกรายละเอียด Treatment",
                  onChanged: (value) {
                    setState(() {
                      widget.selectedTreatmentDetail = value.toString();
                      widget.id = findID();
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowTreatmentContainer extends StatelessWidget {
  final String treatmentTopic;
  final String treatment;

  const ShowTreatmentContainer(
      {super.key, required this.treatmentTopic, required this.treatment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFA0E9FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  'ประเภท Treatment',
                  style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 10),
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
                const SizedBox(width: 10),
                Text(treatment, style: kNormalTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
