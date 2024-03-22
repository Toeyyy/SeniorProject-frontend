import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginTeacherScreen extends StatefulWidget {
  const LoginTeacherScreen({super.key});

  @override
  State<LoginTeacherScreen> createState() => _LoginTeacherScreenState();
}

class _LoginTeacherScreenState extends State<LoginTeacherScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isDataValid = true;

  void goToMainPage() {
    context.go('/mainShowQuestion');
  }

  Future<void> _postAdminLogin() async {
    try {
      var data = {
        "userName": userNameController.text,
        "password": passwordController.text,
      };
      final http.Response response = await http.post(
        Uri.parse("${dotenv.env['API_PATH']}/admin-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (kDebugMode) {
          print("Success: ${response.body}");
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
        await MySecureStorage().writeSecureData('userRole', '1');
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        if (response.statusCode == 400) {
          setState(() {
            _isDataValid = false;
          });
        }
      }
    } catch (error) {
      print('Error login(admin): $error');
    }
    goToMainPage();
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
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset('assets/images/project_logo.png'),
                ),
                const Text(
                  'Admin Log In',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
                ),
                const SizedBox(height: 35),
                SimpleTextField(
                  myController: userNameController,
                  hintText: "Username",
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
                    padding: EdgeInsets.only(left: 20, top: 10),
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
                      if (userNameController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _postAdminLogin();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
