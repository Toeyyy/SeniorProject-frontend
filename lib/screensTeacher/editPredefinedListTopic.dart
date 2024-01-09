import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/screensTeacher/editPredefinedListDetail.dart';

class EditPredefinedListTopic extends StatelessWidget {
  const EditPredefinedListTopic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  'Edit Predefined List',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: editPredefinedList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(
                          editPredefinedList[index],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPredefinedListDetail(
                                  title: editPredefinedList[index]),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 8,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B72BE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
