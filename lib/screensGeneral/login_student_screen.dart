import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/boxes_component.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginStudentScreen extends StatefulWidget {
  const LoginStudentScreen({super.key});

  @override
  State<LoginStudentScreen> createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isDataValid = true;

  void goToMainPage() {
    context.go('/mainShowQuestion');
  }

  Future<void> _postLogin() async {
    int correct = 0;
    try {
      var data = {
        "userName": emailController.text,
        "password": passwordController.text,
      };
      final http.Response response = await http.post(
        Uri.parse("${dotenv.env['API_PATH']}/user-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
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
        correct = 1;
      } else {
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
        if (response.statusCode >= 400 && response.statusCode <= 403) {
          setState(() {
            _isDataValid = false;
            correct = 0;
          });
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error login(user)');
      }
    }
    if (correct == 1) {
      goToMainPage();
    }
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
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 500, minHeight: 540),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/project_logo.png'),
                  ),
                ),
                const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
                  ),
                ),
                const SizedBox(height: 35),
                SimpleTextField(
                  myController: emailController,
                  hintText: "Email",
                  textFieldNotEmpty: true,
                ),
                const SizedBox(height: 15),
                PasswordTextField(
                  myController: passwordController,
                  hintText: "Password",
                  textFieldNotEmpty: true,
                ),
                Visibility(
                  visible: !_isDataValid,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Username หรือ Password ไม่ถูกต้อง',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const Expanded(
                    child: SizedBox(
                  height: double.infinity,
                )),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      //go to mainShowQuestion
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _postLogin();
                        // await MySecureStorage()
                        //     .writeSecureData('userRole', '1');
                        // await MySecureStorage()
                        //     .writeSecureData('accessToken', 'asfdafsfsdfa');
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
                    child: const Text('LOGIN', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account yet?"),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: const Text('Register here'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
