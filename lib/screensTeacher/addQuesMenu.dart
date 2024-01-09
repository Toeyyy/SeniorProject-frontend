import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screensTeacher/addQuestion.dart';
import 'package:frontend/screensTeacher/editPredefinedListTopic.dart';

class AddQuesMenu extends StatelessWidget {
  const AddQuesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'เพิ่มโจทย์',
                style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Download CSV Template',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('แนบไฟล์ CSV'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3DABF5),
                  textStyle: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddQuestion()));
                },
                child: Text('กรอกโจทย์โดยตรง'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B72BE),
                  textStyle: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPredefinedListTopic()));
                },
                child: Text('แก้ไข Predefined List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF694873),
                  textStyle: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
