import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/logObject.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:intl/intl.dart';

class ShowEditHistory extends StatelessWidget {
  List<LogObject> logList;
  ShowEditHistory({super.key, required this.logList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B72BE),
                  ),
                  child: const Text(
                    'กลับ',
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