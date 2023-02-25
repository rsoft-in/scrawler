import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/language.dart';
import 'package:bnotes/desktop/pages/desktop_home_page.dart';
import 'package:bnotes/desktop/pages/desktop_sign_up.dart';
import 'package:bnotes/providers/user_api_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopSignIn extends StatefulWidget {
  const DesktopSignIn({Key? key}) : super(key: key);

  @override
  State<DesktopSignIn> createState() => _DesktopSignInState();
}

class _DesktopSignInState extends State<DesktopSignIn> {
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNodePassword;
  double loginWidth = 500;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  void signIn() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'email': _emailController.text,
        'pwd': _pwdController.text
      })
    };
    UserApiProvider.checkUserCredential(post).then((value) async {
      if (value['error'].toString().isEmpty) {
        globals.user = value['user'];
        prefs = await SharedPreferences.getInstance();
        prefs.setBool('is_signed_in', true);
        prefs.setString('user_id', globals.user!.userId);
        prefs.setString('user_email', globals.user!.userEmail);
        prefs.setString('user_name', globals.user!.userName);
        prefs.setString('user_otp', globals.user!.userOtp);
        prefs.setString('user_pwd', globals.user!.userPwd);
        prefs.setBool('user_enabled', globals.user!.userEnabled);
        setState(() {});
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const DesktopHomePage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['error']),
          duration: const Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  void initState() {
    focusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          decoration: kBackGroundGradient,
          child: Center(
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                width: loginWidth <= 500 ? loginWidth : 500,
                // height: 600,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              kAppName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            Language.get('welcome_back'),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Text(
                            Language.get('email'),
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 25.0, top: 10.0),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return Language.get('mandatory_field');
                                }
                                if (!RegExp(kEmailRegEx).hasMatch(value)) {
                                  return Language.get('invalid_email');
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                focusNodePassword.requestFocus();
                              },
                            ),
                          ),
                          Text(
                            Language.get('password'),
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 25.0, top: 10.0),
                            child: TextFormField(
                              focusNode: focusNodePassword,
                              controller: _pwdController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return Language.get('mandatory_field');
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                if (_formKey.currentState!.validate()) {
                                  signIn();
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: Text(Language.get('sign_in')),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      signIn();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          kVSpace,
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  child: Text(Language.get('forgot_password')),
                                  onPressed: () {
                                    if (_emailController.text.isNotEmpty) {}
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: Language.get('dont_have_account'),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                  ),
                                ),
                                TextSpan(
                                    text: Language.get('register_now'),
                                    style: const TextStyle(
                                      color: kLinkColor,
                                      fontFamily: 'Raleway',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const DesktopSignUp()),
                                                (route) => false);
                                      }),
                              ]),
                            ),
                          ),
                        ]),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
