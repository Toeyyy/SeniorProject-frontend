import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screensGeneral/loginStudentScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailConfirmScreen extends StatefulWidget {
  String code;
  String id;
  String email;
  EmailConfirmScreen(
      {super.key, required this.code, required this.id, required this.email});

  @override
  State<EmailConfirmScreen> createState() => _EmailConfirmScreenState();
}

class _EmailConfirmScreenState extends State<EmailConfirmScreen> {
  bool _isValid = false;
  int _resendStatus = 0;

  Future<void> _resendEmailFunction() async {
    setState(() {
      _resendStatus = 1;
    });
    try {
      var data = {
        "email": widget.email,
      };
      final http.Response response = await http.post(
        Uri.parse("${dotenv.env['API_PATH']}/resend-email"),
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
      print('Error resend Email: $error');
    }
    setState(() {
      _resendStatus = 2;
    });
  }

  Future<void> _confirmEmail() async {
    try {
      final http.Response response = await http.get(
        Uri.parse(
            "${dotenv.env['API_PATH']}/confirmEmail?id=${widget.id}&code=${widget.code}"),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Success: ${response.body}");
        setState(() {
          _isValid = true;
        });
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
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print('Error confirm email: $error');
    }
  }

  Widget resendIcon() {
    if (_resendStatus == 1) {
      return const SizedBox(
          width: 10, height: 10, child: CircularProgressIndicator());
    } else if (_resendStatus == 2) {
      return const Icon(Icons.check);
    }
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    _confirmEmail();
  }

  @override
  Widget build(BuildContext context) {
    print('status = $_resendStatus');

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
          child: !_isValid
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset('assets/images/email_icon.png'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "You're almost done!",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 40),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          children: [
                            const TextSpan(text: "We have sent email to "),
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                color: Color(0xFF42C2FF),
                              ),
                            ),
                            const TextSpan(
                                text:
                                    " to confirm your email and activate your account."),
                          ],
                        ),
                      ),
                      const Expanded(
                          child: SizedBox(
                        height: double.infinity,
                      )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't get any mail?"),
                          TextButton(
                            onPressed: () {
                              _resendEmailFunction();
                            },
                            child: Row(
                              children: [
                                const Text('Resend confirmation email'),
                                const SizedBox(
                                  width: 5,
                                ),
                                resendIcon(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 70),
                  child: Column(
                    children: [
                      const Text(
                        "Congratulations!",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 40),
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