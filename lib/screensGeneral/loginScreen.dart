import 'package:flutter/material.dart';
import 'package:frontend/components/BoxesInAddQ.dart';
import 'package:frontend/screensGeneral/mainShowQuestion.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/AllDataFile.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                const Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
                ),
                const SizedBox(height: 35),
                SimpleTextField(
                    myController: emailController, hintText: "Email"),
                const SizedBox(height: 15),
                SimpleTextField(
                    myController: passwordController, hintText: "Password"),
                const Expanded(
                    child: SizedBox(
                  height: double.infinity,
                )),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      //go to mainShowQuestion
                      //TODO tmp-delete later
                      userRole = int.parse(emailController.text);
                      context.goNamed('mainShowQuestion');
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        //TODO go to register page
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: Color(0xFF3DABF5)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
