import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_treatment_detail.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/aboutData/getDataFunctions.dart';

class EditPredefinedTreatmentType extends StatelessWidget {
  Map<String, List<TreatmentObject>> groupedByType =
      groupBy(treatmentListPreDefined, (e) => e.type);

  Future<void> getData() async {
    await fetchPreDefinedTreatment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: groupedByType.length,
                    itemBuilder: (context, index) {
                      String title = groupedByType.keys.elementAt(index);
                      return ListTile(
                        tileColor: const Color(0xFFA0E9FF),
                        hoverColor: const Color(0xFF42C2FF),
                        title: Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () async {
                          await getData().then((value) {
                            groupedByType =
                                groupBy(treatmentListPreDefined, (e) => e.type);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPredefinedTreatmentDetail(
                                        groupedByType: groupedByType,
                                        selectedType: title),
                              ),
                            );
                          });
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
