import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_detail.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';

class EditPredefinedTreatmentType extends StatelessWidget {
  Map<String, List<TreatmentObject>> groupedByType =
      groupBy(treatmentListPreDefined, (e) => e.type);

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
                  'เลือกหัวข้อ Treatment',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: groupedByType.length,
                    itemBuilder: (context, index) {
                      String title = groupedByType.keys.elementAt(index);
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPredefinedTreatmentDetail(
                                      groupedByType: groupedByType,
                                      selectedType: title),
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
      ),
    );
  }
}
