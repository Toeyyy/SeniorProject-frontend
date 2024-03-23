import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/screensGeneral/emailConfirmationScreen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController stdIDController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void goToLoginScreen() {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => EmailConfirmScreen(email: emailController.text),
      //   ),
      // );
      context.pop();
    }

    Future<void> postRegisterInfo() async {
      try {
        var data = {
          "firstName": nameController.text,
          "lastName": surnameController.text,
          "studentId": stdIDController.text,
          "email": emailController.text,
          "password": passwordController.text,
        };
        final http.Response response = await http.post(
          Uri.parse("${dotenv.env['API_PATH']}/user-register"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print("Success: ${response.body}");
          goToLoginScreen();
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
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/project_logo.png'),
                  ),
                  const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
                  ),
                  const SizedBox(height: 35),
                  SimpleTextField(
                      myController: emailController,
                      hintText: "Email",
                      textFieldNotEmpty: true),
                  const SizedBox(height: 15),
                  PasswordTextField(
                      myController: passwordController,
                      hintText: "Password",
                      textFieldNotEmpty: true),
                  const SizedBox(height: 15),
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
                  const SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty &&
                            surnameController.text.isNotEmpty &&
                            stdIDController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          //post and go to mainShowQuestion
                          postRegisterInfo();
                          // await MySecureStorage()
                          //     .writeSecureData('userRole', '0');
                          // await MySecureStorage()
                          //     .writeSecureData('accessToken', 'accwsfdas');
                          // goToMainPage();
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      child: const Text('REGISTER',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
