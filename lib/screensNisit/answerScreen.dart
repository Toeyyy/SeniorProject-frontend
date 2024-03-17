import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';
import 'package:frontend/models/problemListObject.dart';

class AnswerInit extends StatefulWidget {
  String quesId;
  AnswerInit({super.key, required this.quesId});

  @override
  State<AnswerInit> createState() => _AnswerInitState();
}

class _AnswerInitState extends State<AnswerInit> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
