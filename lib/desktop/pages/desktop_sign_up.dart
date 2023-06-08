import 'dart:convert';

import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/string_values.dart';
import 'package:bnotes/desktop/pages/desktop_app_screen.dart';
import 'package:bnotes/desktop/pages/desktop_sign_in.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/providers/user_api_provider.dart';
import 'package:bnotes/widgets/scrawl_otp_textfield.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopSignUp extends StatefulWidget {
  const DesktopSignUp({Key? key}) : super(key: key);

  @override
  State<DesktopSignUp> createState() => _DesktopSignUpState();
}

class _DesktopSignUpState extends State<DesktopSignUp> {
  bool isDesktop = false;
  late SharedPreferences prefs;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  ScrawlOtpFieldController otpController = ScrawlOtpFieldController();

  int showIndex = 0;
  bool isBusy = false;
  String otp = '';
  bool otpSent = false;
  bool showSkipButton = false;

  final _signUpFormKey = GlobalKey<FormState>();

  void signUp() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'email': emailController.text,
        'name': fullNameController.text,
        'pwd': passwordController.text
      })
    };
    setState(() {
      isBusy = true;
    });
    UserApiProvider.sendVerification(post).then((value) {
      if (value['status']) {
        otpSent = true;
        showIndex++;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(ScrawlSnackBar.show(
          context,
          value['error'],
          duration: const Duration(seconds: 2),
        ));
      }
    });
  }

  void otpVerification() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'email': emailController.text,
        'otp': otp,
      })
    };
    setState(() {
      isBusy = true;
    });
    UserApiProvider.verifyOtp(post).then((value) async {
      if (value['user'] != null) {
        prefs = await SharedPreferences.getInstance();
        prefs.setBool('is_signed_in', true);
        globals.user = value['user'];
        prefs.setString('user_id', globals.user!.userId);
        prefs.setString('user_email', globals.user!.userEmail);
        prefs.setString('user_name', globals.user!.userName);
        prefs.setString('user_otp', globals.user!.userOtp);
        prefs.setString('user_pwd', globals.user!.userPwd);
        prefs.setBool('user_enabled', globals.user!.userEnabled);
        setState(() {});
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const DesktopApp()),
            (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['error']),
          duration: const Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    Widget signUpItems = Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Text(
              kLabels['join_the_family']!,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Text(
            kLabels['email']!,
            style: const TextStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
            child: TextFormField(
              controller: emailController,
              onChanged: (value) {
                showSkipButton =
                    value.isNotEmpty && RegExp(kEmailRegEx).hasMatch(value);
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return kLabels['please_enter_text'];
                }
                if (!RegExp(kEmailRegEx).hasMatch(value)) {
                  return kLabels['invalid_email'];
                }
                return null;
              },
            ),
          ),
          Visibility(
            visible: showSkipButton,
            child: Container(
              padding: kGlobalOuterPadding,
              alignment: Alignment.center,
              child: TextButton(
                child: Text(kLabels['have_otp']!),
                onPressed: () {
                  setState(() {
                    showIndex = 1;
                    otpSent = true;
                  });
                },
              ),
            ),
          ),
          Text(
            kLabels['fullname']!,
            style: const TextStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
            child: TextFormField(
              controller: fullNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return kLabels['please_enter_text'];
                }
                return null;
              },
            ),
          ),
          Text(
            kLabels['password']!,
            style: const TextStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return kLabels['please_enter_text'];
                }
                return null;
              },
            ),
          ),
          Text(
            kLabels['confirm_password']!,
            style: const TextStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
            child: TextFormField(
              controller: confirmPassController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return kLabels['please_enter_text'];
                }
                if (value != passwordController.text) {
                  return kLabels['password_mismatch'];
                }
                return null;
              },
            ),
          ),
          kVSpace,
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  child: Text(kLabels['continue']!),
                  onPressed: () {
                    if (_signUpFormKey.currentState!.validate()) {
                      signUp();
                    } else {
                      return;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
    Widget otpItems =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Text(
          kLabels['verify_email']!,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Text(
          kLabels['otp_sent_to_email']!,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          kLabels['otp']!,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Row(
          children: [
            Expanded(
                child: ScrawlOtpTextField(
                    length: 6,
                    otpController: otpController,
                    onChanged: (pin) {
                      otp = pin;
                      setState(() {});
                    },
                    onCompleted: (pin) {
                      otp = pin;
                      setState(() {});
                    })),
          ],
        ),
      ),
      Row(
        children: [
          FilledButton.tonal(
            onPressed: () {
              setState(() {
                showIndex = 0;
                otpSent = false;
              });
            },
            child: const Icon(Icons.arrow_back),
          ),
          kHSpace,
          Expanded(
            child: FilledButton(
              onPressed: otp.length == 6
                  ? () {
                      otpVerification();
                    }
                  : null,
              child: Text(kLabels['continue']!),
            ),
          ),
        ],
      ),
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // decoration: kBackGroundGradient,
        decoration: const BoxDecoration(color: kPrimaryColor),
        child: Row(
          children: [
            Visibility(
                visible: isDesktop,
                child: const Expanded(
                    child: Center(
                  child: FlutterLogo(
                    size: 300,
                  ),
                ))),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(30),
                alignment: isDesktop ? Alignment.centerRight : Alignment.center,
                child: SizedBox(
                  width: 500,
                  child: Card(
                    child: Container(
                        // width: isDesktop
                        //     ? 500
                        //     : MediaQuery.of(context).size.width * 0.9,
                        // height: MediaQuery.of(context).size.height * 0.95,
                        // height: 600,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            // color: Colors.white.withOpacity(0.8),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      kAppName,
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  if (showIndex == 0) signUpItems,
                                  if (showIndex == 1 && otpSent) otpItems,
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: kLabels['already_have_account'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Raleway',
                                          ),
                                        ),
                                        TextSpan(
                                            text: kLabels['login'],
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
                                                                const DesktopSignIn()),
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
            ),
          ],
        ),
      ),
    );
  }
}
