import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/users_model.dart';
import 'package:scrawler/src/screens/app.dart';
import 'package:scrawler/src/widgets/scrawl_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/globals.dart' as globals;

class WebSignIn extends StatefulWidget {
  const WebSignIn({super.key});

  @override
  State<WebSignIn> createState() => _WebSignInState();
}

class _WebSignInState extends State<WebSignIn> {
  late SharedPreferences preferences;
  bool isSignUpMode = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  List<User> users = [];
  final _signInFormKey = GlobalKey<FormState>();
  String otp = '';
  bool busyVerifying = false;

  void getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final appSignedIn = preferences.getBool("scrawler_signed_in") ?? false;
    if (appSignedIn && mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> signIn() async {
    try {
      var response = await http.Client().post(
          Uri.parse("${globals.apiServer}/signin"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': emailController.text}));
      debugPrint('${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        users = parsed.map<User>((json) => User.fromJson(json)).toList();
        if (mounted) {
          if (users.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to create account!'),
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
                MaterialPageRoute(builder: (context) => const AppPage()),
                (Route<dynamic> route) => false);
          }
        }
      }
    } on Exception catch (e) {
      debugPrint('$e');
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

  Future<void> emailVerification() async {
    setState(() {
      busyVerifying = true;
    });
    try {
      var response = await http.Client().post(
        Uri.parse('${globals.apiServer}/verifyemail'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
        }),
      );
      debugPrint('${response.statusCode} ${response.body}');
      if (mounted) {
        if (response.statusCode == 200) {
          final res = response.body.split('|');
          if (res.length == 2) {
            showSnackBar(
                context, 'Check your email for the verification code!');
            setState(() {
              otp = res[1];
            });
          } else {
            showSnackBar(context, 'Unable to verify Email');
          }
        } else {
          showSnackBar(context, response.body);
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        showSnackBar(context, '$e');
      }
    }
    setState(() {
      busyVerifying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    Widget signInForm = Form(
      key: _signInFormKey,
      child: Column(
        children: [
          kVSpace,
          Text(
            'Use your email to create or access your account',
            style: TextStyle(fontSize: 12),
          ),
          kVSpace,
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Symbols.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Email';
              }
              return null;
            },
          ),
          kVSpace,
          FilledButton(
            onPressed: () {
              if (_signInFormKey.currentState!.validate()) {
                emailVerification();
              }
            },
            child: const Text('Sign-In'),
          ),
        ],
      ),
    );

    Widget otpForm = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Email Verification',
          style: TextStyle(fontSize: 18),
        ),
        kVSpace,
        Text(
          'An OTP has been sent to your Email address. '
          'Please enter it here for verification.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        kVSpace,
        TextFormField(
          controller: otpController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.center,
          decoration: InputDecoration(counterText: ''),
          style: TextStyle(fontWeight: FontWeight.bold),
          onChanged: (value) {
            setState(() {});
          },
        ),
        kVSpace,
        FilledButton(
          onPressed: otpController.text.length < 6
              ? null
              : () {
                  if (otpController.text == otp) {
                    signIn();
                  }
                },
          child: Text('Submit'),
        ),
      ],
    );

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                kAppName,
                style: TextStyle(fontSize: 28),
              ),
              kVSpace,
              otp.isEmpty ? signInForm : otpForm,
              kVSpace,
              Text(
                '© Rennovation Software 2024',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
