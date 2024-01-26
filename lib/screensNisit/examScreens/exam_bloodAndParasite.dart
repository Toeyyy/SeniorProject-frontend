import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/splitScreenNisit.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/examConstants.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/UIModels/nisit/selectedExam_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/backButton.dart';

class ExamBloodAndParasiteType extends StatelessWidget {
  List<ExamPreDefinedObject> list;
  String title;
  String round;
  ExamBloodAndParasiteType(
      {required this.list, required this.title, required this.round});

  late Map<String, List<ExamPreDefinedObject>> groupedByType =
      groupBy(list, (e) => e.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Text(title, style: kSubHeaderTextStyle),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: groupedByType.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Color(0xFFA0E9FF),
                      hoverColor: Color(0xFF42C2FF),
                      title: Text(groupedByType.keys.toList()[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamBloodAndParasiteName(
                              list: groupedByType.values.toList()[index],
                              title: groupedByType.keys.toList()[index],
                              round: round,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              MyBackButton(myContext: context),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamBloodAndParasiteName extends StatelessWidget {
  List<ExamPreDefinedObject> list;
  String title;
  String round;

  ExamBloodAndParasiteName(
      {required this.list, required this.title, required this.round});

  @override
  Widget build(BuildContext context) {
    SelectedExam examProvider = Provider.of<SelectedExam>(context);

    return Scaffold(
      appBar: AppbarNisit(),
      body: SplitScreenNisit(
        leftPart: LeftPartContent(),
        rightPart: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Text(title, style: kSubHeaderTextStyle),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Color(0xFFA0E9FF),
                      hoverColor: Color(0xFF42C2FF),
                      title: Text(list[index].name),
                      trailing: Text(list[index].cost.toString()),
                      onTap: () {
                        examProvider.addItem(list[index], round);
                      },
                    );
                  },
                ),
              ),
              MyBackButton(myContext: context),
            ],
          ),
        ),
      ),
    );
  }
}
