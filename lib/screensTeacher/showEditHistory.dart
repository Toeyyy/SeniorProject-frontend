import 'package:flutter/material.dart';
import 'package:frontend/components/appbar.dart';
import 'package:frontend/components/back_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/logObject.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:intl/intl.dart';

class ShowEditHistory extends StatelessWidget {
  final List<LogObject> logList;
  const ShowEditHistory({super.key, required this.logList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const Text(
                  'ประวัติการแก้ไขโจทย์',
                  style: kHeaderTextStyle,
                ),
                const DividerWithSpace(),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingTextStyle: kTableHeaderTextStyle,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFFA0E9FF)),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text('ชื่ออาจารย์'),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text('วันที่แก้ไข'),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text('เวลาที่แก้ไข'),
                          ),
                        ),
                      ],
                      rows: List.generate(logList.length, (index) {
                        String date = logList[index].dateTime.substring(0, 10);
                        String time = logList[index].dateTime.substring(11, 16);
                        String hour =
                            (int.parse(time.substring(0, 2)) + 7).toString();
                        time =
                            "${hour.length == 2 ? hour : "0$hour"}:${time.substring(3, 5)}";
                        DateTime dateInType = DateTime.parse(date);
                        return DataRow(
                            color: MaterialStateColor.resolveWith(
                                (states) => const Color(0xFFE7F9FF)),
                            cells: <DataCell>[
                              DataCell(Center(
                                child: Text(logList[index].name),
                              )),
                              DataCell(Center(
                                child: Text(DateFormat('dd/MM/yyyy')
                                    .format(dateInType)),
                              )),
                              DataCell(Center(
                                child: Text(time),
                              )),
                            ]);
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyBackButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
