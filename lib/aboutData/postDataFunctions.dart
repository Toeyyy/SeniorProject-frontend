import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/models/statModels/StatQuestionObject.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> postSelectedItemNisit(
    Map<String, dynamic> data, String questionID) async {
  final String apiUrl = "${dotenv.env['API_PATH']}/student/$questionID/stats";
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("Success: ${response.body}");
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }
}
