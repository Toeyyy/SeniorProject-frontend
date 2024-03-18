import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController stdIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void goToMainPage() {
      context.go('/mainShowQuestion');
    }

    Future<void> _postRegisterInfo() async {
      try {
        var data = {
          "firstname": nameController.text,
          "lastname": surnameController.text,
          "studentid": stdIDController.text,
          "idToken": MySecureStorage().readSecureData('idToken'),
        };
        final http.Response response = await http.put(
          Uri.parse("${dotenv.env['API_PATH']}/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print("Success: ${response.body}");
          //TODO assign token in storage
          //TODO assign userRole
          goToMainPage();
        } else {
          print("Error: ${response.statusCode} - ${response.body}");
        }
      } catch (error) {
        print('Error register: $error');
      }
    }

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
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 500, minHeight: 540),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Column(
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
                ),
                const SizedBox(height: 35),
                SimpleTextField(
                  myController: nameController,
                  hintText: "Name",
                  textFieldNotEmpty: true,
                ),
                const SizedBox(height: 15),
                SimpleTextField(
                  myController: surnameController,
                  hintText: "Surname",
                  textFieldNotEmpty: true,
                ),
                const SizedBox(height: 15),
                SimpleTextField(
                  myController: stdIDController,
                  hintText: "bXXXXXXXXXX",
                  textFieldNotEmpty: true,
                ),
                const Expanded(
                    child: SizedBox(
                  height: double.infinity,
                )),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          surnameController.text.isNotEmpty &&
                          stdIDController.text.isNotEmpty) {
                        print('can register');
                        //TODO post and go to mainShowQuestion
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    child:
                        const Text('REGISTER', style: TextStyle(fontSize: 20)),
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
