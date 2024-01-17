import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';

class TeacherShowQuestion extends StatefulWidget {
  const TeacherShowQuestion({super.key});

  @override
  State<TeacherShowQuestion> createState() => _TeacherShowQuestionState();
}

class _TeacherShowQuestionState extends State<TeacherShowQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
    );
  }
}
