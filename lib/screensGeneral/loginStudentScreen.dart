import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:frontend/my_secure_storage.dart';
import 'package:frontend/AllDataFile.dart';

const List<String> scopes = <String>[
  'email',
];
typedef HandleSignInFn = Future<void> Function();

//// The SignInDemo app.
class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignInScreen> {
  // final _storage = const FlutterSecureStorage();
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  final _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    clientId: dotenv.env['CLIENT_ID'],
    scopes: scopes,
    hostedDomain: 'ku.th',
  );
  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
// #docregion CanAccessScopes
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, on web...
      if (kIsWeb && account != null) {
        isAuthorized = true;
      }
// #enddocregion CanAccessScopes

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {}
    });

    _googleSignIn.signInSilently();
  }

  Future<Map<String, dynamic>> _handlePostToken(
      GoogleSignInAccount user) async {
    final GoogleSignInAuthentication auth = await user.authentication;
    final String apiUrl = "${dotenv.env['API_PATH']}/verify";
    String token = auth.idToken!;
    //await _storage.write(key: 'jwt', value: token);
    MySecureStorage().writeSecureData('idToken', token);
    bool isSuccess = false;
    bool result = false;
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Success: ${response.body}");
        isSuccess = true;
        result = jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }

    Map<String, dynamic> data = {
      "isSuccess": isSuccess,
      "token": token,
      "response": result
    };
    return data;
  }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  // #docregion SignIn
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // Check if the user is signed in after the sign-in attempt
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget buildSignInButton({HandleSignInFn? onPressed}) {
    return web.renderButton();
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    String? token;
    // The user is NOT Authenticated
    if (_isAuthorized) {
      _handlePostToken(user!).then((data) async => {
            print(data),
            // _storage.read(key: 'jwt').then((value) => token = value),
            token = await MySecureStorage().readSecureData('idToken'),
            if (data['isSuccess'])
              {
                if (data['response'])
                  {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      MySecureStorage().writeSecureData('userRole', '0');
                      context.go('/mainShowQuestion');
                    })
                  }
                else
                  {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/register');
                    })
                  }
              }
          });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: [
            Image.asset(
              'assets/images/google_logo.png',
              height: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Log In',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
            ),
          ],
        ),
        buildSignInButton(
          onPressed: _handleSignIn,
        ),
      ],
    );
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
            width: MediaQuery.of(context).size.width * 0.5,
            constraints: const BoxConstraints(maxWidth: 300, minHeight: 350),
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }
}
