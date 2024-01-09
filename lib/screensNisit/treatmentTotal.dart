import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';

class TreatmentTotal extends StatelessWidget {
  final String newTreatment;

  TreatmentTotal(this.newTreatment);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: RightPart_TreatmentTotal(newTreatment: newTreatment),
      ),
    );
  }
}

class RightPart_TreatmentTotal extends StatefulWidget {
  final String newTreatment;

  RightPart_TreatmentTotal({required this.newTreatment});

  @override
  State<RightPart_TreatmentTotal> createState() =>
      _RightPart_TreatmentTotalState();
}

class _RightPart_TreatmentTotalState extends State<RightPart_TreatmentTotal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    );
  }
}
