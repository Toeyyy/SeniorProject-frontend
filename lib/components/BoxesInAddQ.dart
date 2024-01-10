import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/UIModels/examContainer_provider.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';

class DropDownButtonInAddQ extends StatelessWidget {
  String selectedValue;
  List<String> list;
  void Function(String?) onChanged;

  DropDownButtonInAddQ(
      {required this.selectedValue,
      required this.list,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      icon: Icon(Icons.arrow_drop_down),
      padding: EdgeInsets.all(5),
      isDense: true,
      alignment: Alignment.center,
      focusColor: Color(0xFFF2F5F7),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class TextAndTextfield extends StatelessWidget {
  TextEditingController myController = TextEditingController();
  String title;

  TextAndTextfield({required this.title, required this.myController});

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(title),
        SizedBox(
          width: 100,
          child: TextField(
            controller: myController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(isDense: true),
          ),
        ),
      ],
    );
  }
}

class TextBoxMultiLine extends StatelessWidget {
  TextEditingController myController = TextEditingController();
  final String hintText;
  final String titleText;
  final int maxLine;
  final Color boxColor;

  TextBoxMultiLine(
      {required this.myController,
      required this.hintText,
      required this.titleText,
      required this.maxLine,
      required this.boxColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (titleText != "")
            ? Text(
                titleText,
                style: kSubHeaderTextStyle,
              )
            : SizedBox(
                width: 2,
              ),
        Container(
          color: boxColor,
          child: TextField(
            controller: myController,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}

class H20Sizedbox extends StatelessWidget {
  const H20Sizedbox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class DividerWithSpace extends StatelessWidget {
  const DividerWithSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const H20Sizedbox(),
        Divider(),
        const H20Sizedbox(),
      ],
    );
  }
}

class ProbListMultiSelectDropDown extends StatelessWidget {
  List<ProblemObject> selectedList;
  List<ProblemObject> displayList;
  String round;
  final String hintText;
  Function(List<ProblemObject>, String) updateListCallback;

  ProbListMultiSelectDropDown(
      {required this.selectedList,
      required this.displayList,
      required this.hintText,
      required this.round,
      required this.updateListCallback});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
        searchEnabled: true,
        hint: hintText,
        chipConfig: ChipConfig(
            backgroundColor: Color(0xFF42C2FF), wrapType: WrapType.wrap),
        onOptionSelected: (List<ValueItem> selectedOptions) {
          updateListCallback(
              selectedOptions.map((item) {
                return ProblemObject(id: item.value, name: item.label);
              }).toList(),
              round);
        },
        options: displayList.map<ValueItem<String>>((ProblemObject item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList());
  }
}

class DiagnosisMultiSelectDropDown extends StatelessWidget {
  List<DiagnosisObject> selectedList;
  final List<DiagnosisObject> displayList;
  String hintText;
  Function(List<DiagnosisObject>) updateListCallback;

  DiagnosisMultiSelectDropDown(
      {required this.selectedList,
      required this.displayList,
      required this.hintText,
      required this.updateListCallback});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
        searchEnabled: true,
        hint: hintText,
        chipConfig: ChipConfig(
            backgroundColor: Color(0xFF42C2FF), wrapType: WrapType.wrap),
        onOptionSelected: (List<ValueItem> selectedOptions) {
          // selectedList = selectedOptions.map((item) {
          //   return DiagnosisObject(id: item.value, name: item.label);
          // }).toList();
          updateListCallback(selectedOptions.map((item) {
            return DiagnosisObject(id: item.value, name: item.label);
          }).toList());
        },
        options: displayList.map<ValueItem<String>>((DiagnosisObject item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList());
  }
}

class ExamsButtonAndContainer extends StatelessWidget {
  List<ExamContainer> examContainers;
  ExamContainerProvider examListProvider;
  String round;
  ////
  TextEditingController examController = TextEditingController();

  ExamsButtonAndContainer(
      {required this.examContainers,
      required this.examListProvider,
      required this.round});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'ผลการส่งตรวจครั้งที่ $round',
              style: kSubHeaderTextStyle,
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                final int currentNub = examListProvider.nub;
                examListProvider.addExamContainer(
                    ExamContainer(
                        id: currentNub,
                        key: ObjectKey(currentNub),
                        round: round,
                        selectedDepartment: departmentList.first,
                        selectedExamTopic: topicExamList1.first,
                        examController: examController,
                        imageFile: null,
                        haveImage: false),
                    examContainers);
              },
              child: Text('เพิ่มการส่งตรวจ'),
            ),
          ],
        ),
        const H20Sizedbox(),
        ListView.builder(
            shrinkWrap: true,
            itemCount: examContainers.length,
            itemBuilder: (context, index) {
              // String itemId = examContainers[index].id;
              // // Key itemKey = Key(itemId);
              // examContainers[index].itemKey = Key(itemId);
              return examContainers[index];
            }),
      ],
    );
  }
}

//////////////////////For ShowAndEdit Page/////////////////////

class DottedListView extends StatelessWidget {
  List<String> showList;

  DottedListView({required this.showList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: showList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(showList[index]),
            leading: Icon(Icons.circle, size: 15),
          );
        });
  }
}
