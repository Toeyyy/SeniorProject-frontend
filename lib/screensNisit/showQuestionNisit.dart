import 'package:flutter/material.dart';
import 'package:frontend/aboutData/getData.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/components/questionCard.dart';
import 'package:frontend/aboutData/dataObject.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/components/tagSearchBox.dart';
import 'package:frontend/models/tagObject.dart';

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
    List<TagObject> selectedTags = [];

    void updateTagList(List<TagObject> newList) {
      selectedTags = newList;
    }

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('โจทย์ยอดนิยม'),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  TagSearchBox(
                      initTags: selectedTags,
                      updateListCallback: updateTagList),
                  SizedBox(
                    height: 20,
                  ),
                  questionObj.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8),
                          itemCount: questionObj.length,
                          itemBuilder: (context, index) {
                            return QuestionCard(
                                questionObj: questionObj[index]);
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
