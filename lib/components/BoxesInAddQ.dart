import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/UIModels/teacher/examContainer_provider.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/components/resultContainer.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DropDownButtonInAddQ extends StatelessWidget {
  String? selectedValue;
  List<String> list;
  void Function(String?) onChanged;
  String hintText;

  DropDownButtonInAddQ(
      {super.key,
      required this.selectedValue,
      required this.list,
      required this.hintText,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return (list
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                .toList()
                .where((element) => element.value == selectedValue)
                .length ==
            1)
        ? DropdownButton(
            value: selectedValue,
            hint: Text(hintText),
            icon: const Icon(Icons.arrow_drop_down),
            padding: const EdgeInsets.all(5),
            isDense: true,
            alignment: Alignment.center,
            focusColor: const Color(0xFFF2F5F7),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          )
        : const SizedBox();
  }
}

class TextAndTextfield extends StatelessWidget {
  TextEditingController myController = TextEditingController();
  String title;

  TextAndTextfield(
      {super.key, required this.title, required this.myController});

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(title),
        SizedBox(
          width: 150,
          child: TextField(
            controller: myController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(isDense: true),
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
      {super.key,
      required this.myController,
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
            : const SizedBox(
                width: 2,
              ),
        Container(
          color: boxColor,
          child: TextField(
            controller: myController,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
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
    return const Column(
      children: [
        H20Sizedbox(),
        Divider(),
        H20Sizedbox(),
      ],
    );
  }
}

class ProbListMultiSelectDropDown extends StatelessWidget {
  List<ProblemObject> selectedList;
  List<ProblemObject> displayList;
  int round;
  final String hintText;
  Function(List<ProblemObject>, int) updateListCallback;

  ProbListMultiSelectDropDown(
      {super.key,
      required this.selectedList,
      required this.displayList,
      required this.hintText,
      required this.round,
      required this.updateListCallback});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
        searchEnabled: true,
        hint: hintText,
        chipConfig: const ChipConfig(
            backgroundColor: Color(0xFF42C2FF), wrapType: WrapType.wrap),
        onOptionSelected: (List<ValueItem> selectedOptions) {
          updateListCallback(
              selectedOptions.map((item) {
                return ProblemObject(id: item.value, name: item.label);
              }).toList(),
              round);
        },
        selectedOptions: selectedList.map((item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList(),
        options: displayList.map<ValueItem<String>>((ProblemObject item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList());
  }
}

class DiagnosisMultiSelectDropDown extends StatelessWidget {
  List<DiagnosisObject> selectedList;
  final List<DiagnosisObject> displayList;
  String type;
  String hintText;
  Function(List<DiagnosisObject>, String) updateListCallback;

  DiagnosisMultiSelectDropDown(
      {super.key,
      required this.selectedList,
      required this.displayList,
      required this.type,
      required this.hintText,
      required this.updateListCallback});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
        searchEnabled: true,
        hint: hintText,
        chipConfig: const ChipConfig(
            backgroundColor: Color(0xFF42C2FF), wrapType: WrapType.wrap),
        onOptionSelected: (List<ValueItem> selectedOptions) {
          updateListCallback(
              selectedOptions.map((item) {
                return DiagnosisObject(
                    id: item.value, type: type, name: item.label);
              }).toList(),
              type);
        },
        selectedOptions: selectedList.map((item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList(),
        options: displayList
            .where((e) => e.type == type)
            .map<ValueItem<String>>((DiagnosisObject item) {
          return ValueItem(label: item.name, value: item.id);
        }).toList());
  }
}

// displayList.map<ValueItem<String>>((DiagnosisObject item) {
// return ValueItem(label: item.name, value: item.id);

class ExamsButtonAndContainer extends StatelessWidget {
  List<ExamContainer> examContainers;
  ExamContainerProvider examListProvider;

  TextEditingController examController = TextEditingController();

  ExamsButtonAndContainer(
      {super.key,
      required this.examContainers,
      required this.examListProvider});

  Map<String, List<ExamPreDefinedObject>> groupedByLab =
      groupBy(examListPreDefined, (e) => e.lab);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'ผลการส่งตรวจ',
              style: kSubHeaderTextStyle,
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                final int currentNub = examListProvider.nub;
                examListProvider.addExamContainer(
                    ExamContainer(
                        id: groupedByLab.values.first.first.id,
                        key: ObjectKey(currentNub),
                        selectedDepartment: groupedByLab.keys.first,
                        selectedExamTopic: groupedByLab.values.first.first.type,
                        selectedExamName: groupedByLab.values.first.first.name,
                        selectedArea: groupedByLab.values.first.first.area,
                        areaNull: groupedByLab.values.first.first.area == null,
                        examController: examController,
                        imagePath: null,
                        imageResult: null,
                        haveImage: false),
                    examContainers);
              },
              child: const Text('เพิ่มการส่งตรวจ'),
            ),
          ],
        ),
        const H20Sizedbox(),
        ListView.builder(
            shrinkWrap: true,
            itemCount: examContainers.length,
            itemBuilder: (context, index) {
              return examContainers[index];
            }),
      ],
    );
  }
}

void alertModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.height * 0.5,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Center(
              child: Text(
                'กรุณากรอกข้อมูลให้ครบ',
                style: kSubHeaderTextStyle,
              ),
            ),
          ),
        );
      });
}

//////////////////////For ShowAndEdit Page/////////////////////

class DottedListView extends StatelessWidget {
  List<String>? showList;

  DottedListView({super.key, required this.showList});

  @override
  Widget build(BuildContext context) {
    return showList != []
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: showList!.length,
            itemBuilder: (context, index) {
              if (showList![index].trim() == '') {
                return null;
              }
              return ListTile(
                title: Text(showList![index]),
                leading: const Icon(Icons.circle, size: 15),
              );
            })
        : const SizedBox();
  }
}

//////for show in split screen//////
class TitleAndDottedListView extends StatelessWidget {
  String title;
  List<String> showList;
  TitleAndDottedListView(
      {super.key, required this.title, required this.showList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kSubHeaderTextStyleInLeftPart,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: showList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(
                Icons.circle,
                size: 15,
              ),
              title: Text(showList[index]),
            );
          },
        ),
      ],
    );
  }
}

class TitleAndExams extends StatelessWidget {
  final String title;
  final List<ExamPreDefinedObject> showList;
  final List<ResultContainer> resultList;
  const TitleAndExams(
      {super.key,
      required this.title,
      required this.showList,
      required this.resultList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kSubHeaderTextStyleInLeftPart,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: showList.length,
            itemBuilder: (context, index) {
              var item = showList[index];
              ExamResultObject resultItem = resultList[index].result;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        const Text(
                          'แผนกที่เลือกตรวจ: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(item.lab),
                      ],
                    ),
                    leading: const Icon(
                      Icons.circle,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: Row(
                        children: [
                          const Text(
                            'หัวข้อการตรวจ: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(item.type)
                        ],
                      ),
                    ),
                  ),
                  item.area != null
                      ? ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Row(
                              children: [
                                const Text('ตัวอย่างการส่งตรวจ: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                Text(item.area!),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: Row(
                        children: [
                          const Text('ชื่อการส่งตรวจ: ',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          Text(item.name),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50, top: 5),
                    child: Text(
                      'ผลการตรวจ',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  // const SizedBox(height: 15),
                  resultItem.imgResult != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Image.network(
                            "${dotenv.env['RESOURCE_PATH']}${resultItem.imgResult!.replaceFirst("Uploads", "")}",
                            width: 300,
                            height: 200,
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft,
                          ),
                        )
                      : const SizedBox(),
                  resultItem.textResult != null
                      ? Column(
                          children: [
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(resultItem.textResult!),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              );
            }),
        const SizedBox(height: 15),
      ],
    );
  }
}

/////stat pages/////

void probDiagTreatmentModal(
    BuildContext context, String title, List<dynamic> list) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.5,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4),
            decoration: BoxDecoration(
              color: const Color(0xFFBBF5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: kSubHeaderTextStyleInLeftPart),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(list[index].name),
                            leading: const Icon(Icons.circle, size: 15),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void examModal(BuildContext context, List<ExamPreDefinedObject> examList) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              color: const Color(0xFFBBF5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Examination',
                        style: kSubHeaderTextStyleInLeftPart),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: examList.length,
                        itemBuilder: (context, index) {
                          var item = examList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    const Text(
                                      'แผนกที่เลือกตรวจ: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(item.lab),
                                  ],
                                ),
                                leading: const Icon(
                                  Icons.circle,
                                  size: 15,
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'หัวข้อการตรวจ: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(item.type)
                                    ],
                                  ),
                                ),
                              ),
                              item.area != null
                                  ? ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Row(
                                          children: [
                                            const Text('ตัวอย่างการส่งตรวจ: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Text(item.area!),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: Row(
                                    children: [
                                      const Text('ชื่อการส่งตรวจ: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(item.name),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

class StatBarGraph extends StatelessWidget {
  Map<String, int> statList;
  String title;

  StatBarGraph({super.key, required this.statList, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: statList.values.reduce(
                      (value, element) => value > element ? value : element) +
                  1,
              gridData: const FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  axisNameWidget: Container(
                    alignment: Alignment.topLeft,
                    child: Text(title, style: kTableHeaderTextStyle),
                  ),
                  axisNameSize: 35,
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value >= 0 && value < statList.length) {
                        String title = statList.keys.toList()[value.toInt()];
                        // return Text(title);
                        return Transform.rotate(
                          angle: -45,
                          child: Text(title),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              barGroups: statList.entries.map((entry) {
                final String name = entry.key;
                final int count = entry.value;
                return BarChartGroupData(
                  x: statList.keys.toList().indexOf(name),
                  barRods: [BarChartRodData(toY: count.toDouble())],
                  barsSpace: 2,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/////login & register page/////
class SimpleTextField extends StatefulWidget {
  TextEditingController myController;
  String hintText;
  bool textFieldNotEmpty;
  SimpleTextField(
      {super.key,
      required this.myController,
      required this.hintText,
      required this.textFieldNotEmpty});

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.myController,
      decoration: InputDecoration(
        errorText: widget.textFieldNotEmpty ? null : "Value can't be empty",
        border: const OutlineInputBorder(),
        hintText: widget.hintText,
      ),
      onChanged: (newValue) {
        setState(() {
          widget.textFieldNotEmpty = widget.myController.text.isNotEmpty;
        });
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  TextEditingController myController;
  String hintText;
  bool textFieldNotEmpty;
  PasswordTextField(
      {super.key,
      required this.myController,
      required this.hintText,
      required this.textFieldNotEmpty});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.myController,
      decoration: InputDecoration(
        errorText: widget.textFieldNotEmpty ? null : "Value can't be empty",
        border: const OutlineInputBorder(),
        hintText: widget.hintText,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: _obscureText
                ? const Icon(CupertinoIcons.eye_slash)
                : const Icon(CupertinoIcons.eye),
          ),
        ),
      ),
      obscureText: _obscureText,
      onChanged: (newValue) {
        setState(() {
          widget.textFieldNotEmpty = widget.myController.text.isNotEmpty;
        });
      },
    );
  }
}
