import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/adaptive.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/models/user.dart';
import 'package:scrawler/src/screens/desktop/app.dart';
import 'package:scrawler/src/screens/mobile/app.dart';
import 'package:scrawler/src/widgets/scrawl_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/globals.dart' as globals;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late SharedPreferences preferences;
  bool isSignUpMode = false;
  String userName = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  List<User> users = [];
  final _signInFormKey = GlobalKey<FormState>();
  String otp = '';
  bool busyVerifying = false;
  bool showSignIn = false;
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  void getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final appSignedIn = preferences.getBool("scrawler_signed_in") ?? false;
    if (appSignedIn && mounted) {
      globals.user.userId = preferences.getString('user_id') ?? '';
      globals.user.userName = preferences.getString('user_name') ?? '';
      globals.user.userEmail = preferences.getString('user_email') ?? '';
      globals.user.userEnabled = preferences.getBool('user_enabled') ?? false;

      if (Platform.isAndroid || Platform.isIOS) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppMobile()),
            (Route<dynamic> route) => false);
      }
      else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppDesktop()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        showSignIn = true;
      });
    }
  }

  Future<void> signIn() async {
    try {
      var response = await http.Client().post(
          Uri.parse("${globals.apiServer}/signin"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': emailController.text, 'name': userName}));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        users = parsed.map<User>((json) => User.fromJson(json)).toList();
        if (mounted) {
          if (users.isEmpty) {
            showSnackBar(context, 'unable_to_create_account'.tr());
          } else {
            setState(() {
              globals.user = users[0];
              preferences.setBool('scrawler_signed_in', true);
              preferences.setString('user_id', globals.user.userId);
              preferences.setString('user_name', globals.user.userName);
              preferences.setString('user_email', globals.user.userEmail);
              preferences.setBool('user_enabled', globals.user.userEnabled);
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AppMobile()),
                (Route<dynamic> route) => false);
          }
        }
      } else {
        if (mounted) showSnackBar(context, response.body);
      }
    } on Exception catch (e) {
      if (mounted) {
        showSnackBar(context, '$e');
      }
    }
  }

  Future<void> emailVerification() async {
    setState(() {
      busyVerifying = true;
      final emailParts = emailController.text.split("@");
      userName = emailParts[0];
    });
    try {
      var response = await http.Client().post(
        Uri.parse('${globals.apiServer}/verifyemail'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': emailController.text, 'name': userName}),
      );
      if (mounted) {
        if (response.statusCode == 200) {
          final res = response.body.split('|');
          if (res.length == 2) {
            showSnackBar(context, 'check_email_for_code'.tr());
            setState(() {
              otp = res[1];
            });
          } else {
            showSnackBar(context, 'email_verification_failed'.tr());
          }
        } else {
          showSnackBar(context, response.body);
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        showSnackBar(context, '$e');
      }
    } finally {
      setState(() {
        busyVerifying = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    nameFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);
    Widget signInForm = Form(
      key: _signInFormKey,
      child: Column(
        children: [
          Text(
            'sign_in_help_text'.tr(),
            style: TextStyle(fontSize: 12),
          ),
          kVSpace,
          TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'email'.tr(),
              prefixIcon: Icon(Symbols.email),
            ),
            validator: emailValidator,
            onEditingComplete: () {
              if (_signInFormKey.currentState!.validate()) {
                emailVerification();
              }
            },
          ),
          kVSpace,
          FilledButton(
            onPressed: busyVerifying
                ? null
                : () {
                    if (_signInFormKey.currentState!.validate()) {
                      emailVerification();
                    }
                  },
            child: Text('sign_in'.tr()),
          ),
        ],
      ),
    );

    Widget otpForm = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'email_verification'.tr(),
          style: TextStyle(fontSize: 18),
        ),
        kVSpace,
        Text(
          'otp_hint'.tr(),
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
          onEditingComplete: () {
            if (otpController.text.length == 6 && otpController.text == otp) {
              signIn();
            }
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
          child: Text('submit'.tr()),
        ),
      ],
    );

    return Scaffold(
      body: showSignIn
          ? Row(
              children: [
                if (screenSize == ScreenSize.large)
                  Expanded(
                      child: Center(
                    child: SvgPicture.asset(
                      'images/undraw_friends_xscy.svg',
                      width: MediaQuery.of(context).size.width * 0.5 * 0.8,
                    ),
                  )),
                Expanded(
                  child: Stack(
                    children: [
                      Center(
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
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: kPaddingLarge,
                          child: Center(
                            child: Text(
                              '© Rennovation Software 2024',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
