import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dataObject.dart';

Future<List<QuestionObj>> fetchData() async {
  try {
    final String jsonString =
        await rootBundle.loadString("data/exampleData.json");
    // print('jsonString: $jsonString');

    final List<dynamic> jsonList = json.decode(jsonString);

    // print('run2: $jsonList');

    // List tmp = jsonList.map((data) => QuestionObj.fromJson(data)).toList();
    // print('tmp: $tmp');

    return jsonList.map((data) => QuestionObj.fromJson(data)).toList();
  } catch (error) {
    print('Error fetching data: $error');
    return [];
  }
}
