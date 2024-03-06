import 'package:flutter/material.dart';
import 'package:frontend/components/tag_box.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/questionObject.dart';

class SplitScreenNisit extends StatelessWidget {
  Widget leftPart;
  Widget rightPart;

  SplitScreenNisit(
      {super.key, required this.leftPart, required this.rightPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: leftPart,
          ),
        ),
        const VerticalDivider(
          indent: 50,
          endIndent: 50,
        ),
        Expanded(
          child: Container(
            child: rightPart,
          ),
        ),
      ],
    );
  }
}

class LeftPartContent extends StatelessWidget {
  QuestionObject questionObj;
  Widget? addedContent;

  LeftPartContent({super.key, required this.questionObj, this.addedContent});

  @override
  Widget build(BuildContext context) {
    List<String> generalList = questionObj.generalInfo.split(',');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รหัสโจทย์: ${questionObj.name}',
              style: kSubHeaderTextStyle,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 2,
              runSpacing: 5,
              children: questionObj.tags
                  .map(
                    (e) => TagBox(text: e.name),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              'ข้อมูลทั่วไป',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            Text('ชนิดสัตว์: ${questionObj.signalment.species}'),
            Text('พันธุ์: ${questionObj.signalment.breed}'),
            Text('เพศ: ${questionObj.signalment.gender}'),
            Text(questionObj.signalment.sterilize == true
                ? 'ทำหมันแล้ว'
                : 'ยังไม่ได้ทำหมัน'),
            Text('อายุ: ${questionObj.signalment.age}'),
            Text('น้ำหนัก: ${questionObj.signalment.weight}'),
            const SizedBox(
              height: 20,
            ),
            // Client Complains
            const Text(
              'Client Complains',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 20),
              color: const Color(0xFFDFE4E0),
              child: Text(questionObj.clientComplains),
            ),
            // History Taking
            const Text(
              'History Taking',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 20),
              color: const Color(0xFFDFE4E0),
              child: Text(questionObj.historyTakingInfo),
            ),
            // General Test
            const Text(
              'ผลตรวจร่างกาย',
              style: kSubHeaderTextStyleInLeftPart,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: generalList.length,
              itemBuilder: (context, index) {
                if (generalList[index].trim() == '') {
                  return null;
                }
                return ListTile(
                  leading: const Icon(
                    Icons.circle,
                    size: 15,
                  ),
                  title: Text(generalList[index].trim()),
                );
              },
            ),
            addedContent != null ? addedContent! : const Column(),
          ],
        ),
      ),
    );
  }
}
