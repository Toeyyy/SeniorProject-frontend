import 'package:flutter/material.dart';
import 'package:frontend/components/HoverColorListTile.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensNisit/treatmentDetail.dart';
import 'package:frontend/components/appBar.dart';

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
    'Nutritional Support',
    'Other Treatment',
  ];

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
              itemCount: _treatmentList.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 8,
              ),
              itemBuilder: (context, index) {
                return HoverColorListTile(
                  hoverColor: Color(0xFF42C2FF),
                  title: Text(_treatmentList[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TreatmentDetail(_treatmentList[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Treatment ที่เลือก'),
          ),
        ],
      ),
    );
  }
}
