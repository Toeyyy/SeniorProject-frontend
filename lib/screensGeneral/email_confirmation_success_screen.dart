import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screensGeneral/login_student_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailConfirmSuccess extends StatefulWidget {
  final String code;
  final String id;

  const EmailConfirmSuccess({super.key, required this.id, required this.code});

  @override
  State<EmailConfirmSuccess> createState() => _EmailConfirmSuccessState();
}

class _EmailConfirmSuccessState extends State<EmailConfirmSuccess> {
  Future<void> _confirmEmail() async {
    try {
      final http.Response response = await http.get(
        Uri.parse(
            "${dotenv.env['API_PATH']}/confirmEmail?id=${widget.id}&code=${widget.code}"),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (kDebugMode) {
          print("Success");
        }
        dynamic jsonFile = jsonDecode(response.body);
        //assign token in storage
        await MySecureStorage()
            .writeSecureData('accessToken', jsonFile['accessToken']);
        await MySecureStorage()
            .writeSecureData('refreshToken', jsonFile['refreshToken']);
        await MySecureStorage()
            .writeSecureData('tokenExpires', jsonFile['tokenExpires']);
        //assign userRole
        await MySecureStorage().writeSecureData('userRole', '0');
      } else {
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error confirm email');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _confirmEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBF5FF),
              Color(0xFFA0E9FF),
              Color(0xFF42C2FF),
              Color(0xFF3DABF5),
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 70),
            child: Column(
              children: [
                const Text(
                  "Congratulations!",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Your email has already been confirmed. You can now login our application",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginStudentScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF42C2FF),
                    size: 120,
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
