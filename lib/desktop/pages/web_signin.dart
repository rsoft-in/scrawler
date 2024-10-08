import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/desktop/desktop_app.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/models/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/globals.dart' as globals;

class WebSignIn extends StatefulWidget {
  const WebSignIn({super.key});

  @override
  State<WebSignIn> createState() => _WebSignInState();
}

class _WebSignInState extends State<WebSignIn> {
  late SharedPreferences preferences;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<User> users = [];

  Future<void> setAPIServer() async {
    try {
      String server = await rootBundle.loadString('res/apiserver');
      globals.apiServer = server;
      getPreferences();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final appSignedIn = preferences.getBool("scrawler_signed_in") ?? false;
    if (appSignedIn && mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DesktopApp()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> signIn() async {
    try {
      var response = await http.Client().post(
          Uri.parse("${globals.apiServer}/signin"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': usernameController.text,
            'password': passwordController.text
          }));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        users = parsed.map<User>((json) => User.fromJson(json)).toList();
        if (mounted) {
          if (users.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid Username or Password!'),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            setState(() {
              globals.user = users[0];
              preferences.setBool('scrawler_signed_in', true);
              preferences.setString('user_id', globals.user!.userId);
              preferences.setString('user_name', globals.user!.userName);
              preferences.setString('user_email', globals.user!.userEmail);
              preferences.setBool('user_enabled', globals.user!.userEnabled);
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DesktopApp()),
                (Route<dynamic> route) => false);
          }
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setAPIServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                kAppName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              kVSpace,
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Symbols.person),
                ),
              ),
              kVSpace,
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Symbols.password),
                ),
              ),
              kVSpace,
              FilledButton(
                onPressed: () => signIn(),
                child: const Text('Sign-In'),
              ),
              kVSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do not have account?'),
                  kHSpace,
                  TextButton(
                    onPressed: () {},
                    child: const Text('Sign-Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
