import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/UIModels/nisit/selectedTreatment_provider.dart';
import 'package:frontend/constants.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screensNisit/treatmentTopic.dart';

class TreatmentTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: RightPart_TreatmentTotal(),
      ),
    );
  }
}

class RightPart_TreatmentTotal extends StatefulWidget {
  @override
  State<RightPart_TreatmentTotal> createState() =>
      _RightPart_TreatmentTotalState();
}

class _RightPart_TreatmentTotalState extends State<RightPart_TreatmentTotal> {
  @override
  Widget build(BuildContext context) {
    SelectedTreatment treatmentProvider =
        Provider.of<SelectedTreatment>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Text(
            "Treatment ที่เลือก",
            style: kHeaderTextStyle,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: treatmentProvider.treatmentList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.circle, size: 15),
                  title: Text(treatmentProvider.treatmentList[index].name),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TreatmentTopic(),
                    ),
                  );
                },
                child: Text('เลือก Treatment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B72BE),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('ส่งคำตอบ'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
