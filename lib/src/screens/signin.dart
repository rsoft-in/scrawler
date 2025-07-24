import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:http/http.dart' as http;
import 'package:scrawler/src/helpers/adaptive.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/models/user.dart';
import 'package:scrawler/src/screens/app.dart';
import 'package:scrawler/src/widgets/rs_toast.dart';
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

  void getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final appSignedIn = preferences.getBool("scrawler_signed_in") ?? false;
    if (appSignedIn && mounted) {
      globals.user.userId = preferences.getString('user_id') ?? '';
      globals.user.userName = preferences.getString('user_name') ?? '';
      globals.user.userEmail = preferences.getString('user_email') ?? '';
      globals.user.userEnabled = preferences.getBool('user_enabled') ?? false;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const App()),
          (Route<dynamic> route) => false);
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
            RSToast.show(context, message: 'unable_to_create_account'.tr());
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
                MaterialPageRoute(builder: (context) => const App()),
                (Route<dynamic> route) => false);
          }
        }
      } else {
        if (mounted) RSToast.show(context, message: response.body);
      }
    } on Exception catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
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
            RSToast.show(context, message: 'check_email_for_code'.tr());
            setState(() {
              otp = res[1];
            });
          } else {
            RSToast.show(context, message: 'email_verification_failed'.tr());
          }
        } else {
          RSToast.show(context, message: response.body);
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
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
          FTextFormField(
            controller: emailController,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            hint: 'email'.tr(),
            prefixBuilder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(FIcons.mail),
            ),
            validator: emailValidator,
            onEditingComplete: () {
              if (_signInFormKey.currentState!.validate()) {
                emailVerification();
              }
            },
          ),
          kVSpace,
          FButton(
            onPress: busyVerifying
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
          'otp_hint'.tr(namedArgs: {'email': emailController.text}),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        kVSpace,
        FTextFormField(
          controller: otpController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.center,
          onChange: (value) {
            setState(() {});
          },
          onEditingComplete: () {
            if (otpController.text.length == 6 && otpController.text == otp) {
              signIn();
            }
          },
        ),
        kVSpace,
        FButton(
          onPress: otpController.text.length < 6
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

    return FScaffold(
      child: showSignIn
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
              child: FProgress.circularIcon(),
            ),
    );
  }
}
