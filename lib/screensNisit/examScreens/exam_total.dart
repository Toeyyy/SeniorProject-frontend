import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:provider/provider.dart';

class ExamTotal extends StatelessWidget {
  String round;
  ExamTotal({required this.round});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
