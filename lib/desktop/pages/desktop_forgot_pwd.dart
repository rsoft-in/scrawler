import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/desktop/pages/desktop_sign_in.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/providers/user_api_provider.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:yaru_icons/yaru_icons.dart';

class DesktopForgotPassword extends StatefulWidget {
  final String email;
  const DesktopForgotPassword({Key? key, required this.email})
      : super(key: key);

  @override
  State<DesktopForgotPassword> createState() => _DesktopForgotPasswordState();
}

class _DesktopForgotPasswordState extends State<DesktopForgotPassword> {
  bool isDesktop = false;
  final _formKey = GlobalKey<FormState>();
  bool otpVerified = false;
  final loginWidth = 400.0;

  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void verifyOtp() async {
    if (otpController.text.isEmpty) return;
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'email': widget.email,
        'otp': otpController.text,
        'type': 'fpwd'
      })
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(ScrawlSnackBar.show(context, 'Verifying OTP...'));
    final result = await UserApiProvider.verifyRecoveryOtp(post);
    if (result['error'].toString().isEmpty) {
      setState(() {
        otpVerified = true;
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(ScrawlSnackBar.show(
          context,
          result['error'],
          duration: const Duration(seconds: 2),
        ));
      }
    }
  }

  void updatePassword() async {
    if (newPasswordController.text.compareTo(confirmPasswordController.text) !=
        0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(ScrawlSnackBar.show(context, 'Password mismatch!'));
      return;
    }
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'user_email': widget.email,
        'user_pwd': newPasswordController.text
      })
    };
    final result = await UserApiProvider.updatePassword(post);
    if (result['error'].toString().isEmpty) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DesktopSignIn()),
            (route) => false);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(ScrawlSnackBar.show(
          context,
          result['error'],
          duration: const Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    Widget loginContent = SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Visibility(
                visible: kIsWeb,
                child: Text(
                  kAppName,
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200),
                ),
              ),
              const Visibility(visible: kIsWeb, child: kVSpace),
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Visibility(
                visible: !otpVerified,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
                  child: TextFormField(
                    controller: otpController,
                    decoration: const InputDecoration(
                      hintText: 'Enter OTP here',
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !otpVerified,
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => verifyOtp(),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: otpVerified,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
                  child: TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter New Password',
                      suffixIcon: Icon(YaruIcons.key),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Language.get('mandatory_field');
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {},
                  ),
                ),
              ),
              Visibility(
                visible: otpVerified,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      suffixIcon: Icon(YaruIcons.key),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Language.get('mandatory_field');
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {},
                  ),
                ),
              ),
              Visibility(
                visible: otpVerified,
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updatePassword();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
    return kIsWeb
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: darkModeOn ? kDarkSecondary : kLightSecondary,
            body: Row(
              children: [
                if (isDesktop)
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        'images/welcome.svg',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: loginWidth,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          decoration: BoxDecoration(
                              color: darkModeOn ? kDarkPrimary : kLightPrimary,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      darkModeOn ? kDarkStroke : kLightStroke,
                                  width: 2)),
                          child: loginContent),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: MoveWindow(
                child: Container(
                  // color: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Visibility(
                    visible: !UniversalPlatform.isMacOS,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: darkModeOn
                                      ? kDarkSecondary
                                      : kLightSelected,
                                  border: Border.all(
                                      color: darkModeOn
                                          ? kDarkStroke
                                          : kLightStroke),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                YaruIcons.window_minimize,
                                size: 14,
                              )),
                          onTap: () => appWindow.minimize(),
                        ),
                        kHSpace,
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: darkModeOn
                                      ? kDarkSecondary
                                      : kLightSelected,
                                  border: Border.all(
                                      color: darkModeOn
                                          ? kDarkStroke
                                          : kLightStroke),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.close_outlined,
                                size: 14,
                              )),
                          onTap: () => appWindow.close(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              // padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(top: 56),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Image.asset(
                    'images/scrawler-desktop.png',
                    // fit: BoxFit.fitHeight,
                    width: 50,
                    height: 50,
                  ),
                  kVSpace,
                  const Text(
                    kAppName,
                    style:
                        TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ),
            bottomSheet: Container(
              decoration: BoxDecoration(
                  color: darkModeOn ? kDarkSecondary : kLightSecondary,
                  border: Border(
                      top: BorderSide(
                          color: darkModeOn ? kDarkStroke : kLightStroke,
                          width: 2))),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                  child: loginContent),
            ),
          );
  }
}
