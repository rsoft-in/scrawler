import 'dart:convert';

import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/desktop/pages/desktop_app_screen.dart';
import 'package:bnotes/desktop/pages/desktop_sign_up.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/providers/user_api_provider.dart';
import 'package:bnotes/widgets/scrawl_button_filled.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  double loginWidth = 400;
  bool isSigningIn = false;
  bool isDesktop = true;

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
    ScaffoldMessenger.of(context)
        .showSnackBar(ScrawlSnackBar.show(context, 'Signing In...'));
    isSigningIn = true;
    setState(() {});
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
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const DesktopApp()),
              (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(ScrawlSnackBar.show(
          context,
          value['error'],
          duration: const Duration(seconds: 2),
        ));
      }
      isSigningIn = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    focusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Row(
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
                        horizontal: 30, vertical: 60),
                    decoration: BoxDecoration(
                      color: kLightPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              Language.get('welcome_back'),
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Text(
                              Language.get('email'),
                              style: const TextStyle(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 25.0, top: 10.0),
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
                              style: const TextStyle(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 25.0, top: 10.0),
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
                                  child: ScrawlFilledButton(
                                    onPressed: isSigningIn
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              signIn();
                                            }
                                          },
                                    label: Language.get('sign_in'),
                                  ),
                                ),
                              ],
                            ),
                            kVSpace,
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    child:
                                        Text(Language.get('forgot_password')),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Language.get('dont_have_account')),
                                TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const DesktopSignUp()),
                                            (route) => false),
                                    child: Text(Language.get('register_now'))),
                              ],
                            ),
                          ]),
                    ),
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
