import 'package:flutter/material.dart';
import 'package:frontend/components/HoverColorListTile.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensNisit/treatmentDetail.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/screensNisit/treatmentTotal.dart';

class TreatmentTopic extends StatelessWidget {
  const TreatmentTopic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: RightPart_TreatmentTopic(),
      ),
    );
  }
}

class RightPart_TreatmentTopic extends StatefulWidget {
  @override
  State<RightPart_TreatmentTopic> createState() =>
      _RightPart_TreatmentTopicState();
}

class _RightPart_TreatmentTopicState extends State<RightPart_TreatmentTopic> {
  final List<String> _treatmentList = [
    'Medical Treatment',
    'Surgical Treatment',
    'Nutritional support',
    'Other Treatment',
  ];

  Map<String, List<TreatmentObject>> _groupedByType =
      groupBy(preDefinedTreatmentAll, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Text(
            'Treatment',
            style: kHeaderTextStyle,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _groupedByType.keys.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 8,
              ),
              itemBuilder: (context, index) {
                return HoverColorListTile(
                  hoverColor: Color(0xFF42C2FF),
                  title: Text(_groupedByType.keys.toList()[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TreatmentDetail(
                            _groupedByType.keys.toList()[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TreatmentTotal(),
                ),
              );
            },
            child: Text('Treatment ที่เลือก'),
          ),
        ],
      ),
    );
  }
}
