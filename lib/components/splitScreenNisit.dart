import 'package:flutter/material.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';

class SplitScreenNisit extends StatelessWidget {
  Widget leftPart;
  Widget rightPart;

  SplitScreenNisit({required this.leftPart, required this.rightPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: leftPart,
            ),
          ),
        ),
        VerticalDivider(
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
  const LeftPartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // General Information
        Row(
          children: [
            Text(
              'รหัสโจทย์: ${listForSplitScreen.name}',
              style: kSubHeaderTextStyle,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: listForSplitScreen.tags
                    .map(
                      (e) => TagBox(text: e.name),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'ข้อมูลทั่วไป',
          style: kSubHeaderTextStyleInLeftPart,
        ),
        Text('ชนิดสัตว์: ${listForSplitScreen.signalment.species}'),
        Text('พันธุ์: ${listForSplitScreen.signalment.breed}'),
        Text('เพศ: ${listForSplitScreen.signalment.gender}'),
        Text(listForSplitScreen.signalment.sterilize == true
            ? 'ทำหมันแล้ว'
            : 'ยังไม่ได้ทำหมัน'),
        Text('อายุ: ${listForSplitScreen.signalment.age}'),
        Text('น้ำหนัก: ${listForSplitScreen.signalment.weight}'),
        SizedBox(
          height: 20,
        ),
        // Client Complains
        Text(
          'Client Complains',
          style: kSubHeaderTextStyleInLeftPart,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 20),
          color: Color(0xFFDFE4E0),
          child: Text('${listForSplitScreen.clientComplains}'),
        ),
        // History Taking
        Text(
          'History Taking',
          style: kSubHeaderTextStyleInLeftPart,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 20),
          color: Color(0xFFDFE4E0),
          child: Text('${listForSplitScreen.historyTakingInfo}'),
        ),
        // General Test
        Text(
          'ผลตรวจร่างกาย',
          style: kSubHeaderTextStyleInLeftPart,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listForSplitScreen.generalInfo.split(',').length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 15,
                ),
                title: Text(
                    listForSplitScreen.generalInfo.split(',')[index].trim()),
              );
            },
          ),
        ),
      ],
    );
  }
}
