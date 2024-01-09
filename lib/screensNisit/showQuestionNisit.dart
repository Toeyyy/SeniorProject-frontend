import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getData.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/components/questionCard.dart';
import 'package:frontend/aboutData/dataObject.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/components/tagSearchBox.dart';

class NisitShowQuestion extends StatefulWidget {
  const NisitShowQuestion({super.key});

  @override
  State<NisitShowQuestion> createState() => _NisitShowQuestionState();
}

class _NisitShowQuestionState extends State<NisitShowQuestion> {
  List<QuestionObj> questionObj = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    // super.initState();
    List<QuestionObj> loadedData = await fetchData();
    // print('loaded data = ${loadedData[0].type}');

    setState(() {
      questionObj = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('run1: $questionObj');

    return Scaffold(
      appBar: AppbarNisit(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          'เลือกโจทย์',
                          style: kHeaderTextStyle,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              labelText: 'ค้นหารหัสโจทย์',
                              labelStyle: TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  TagSearchBox(initTags: []),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 600,
                    child: questionObj.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.9),
                            itemCount: questionObj.length,
                            itemBuilder: (context, index) {
                              return QuestionCard(
                                  questionObj: questionObj[index]);
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
