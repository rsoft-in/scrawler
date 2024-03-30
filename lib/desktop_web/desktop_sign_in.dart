import 'dart:convert';

import 'package:bnotes/helpers/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../desktop/pages/desktop_forgot_pwd.dart';
import '../helpers/adaptive.dart';
import '../helpers/constants.dart';
import '../helpers/globals.dart' as globals;
import '../providers/user_api_provider.dart';
import '../widgets/scrawl_snackbar.dart';
import 'desktop_app_screen.dart';
import 'desktop_sign_up.dart';

class DesktopSignIn extends StatefulWidget {
  const DesktopSignIn({super.key});

  @override
  State<DesktopSignIn> createState() => _DesktopSignInState();
}

class _DesktopSignInState extends State<DesktopSignIn> {
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNodePassword;
  double loginWidth = 400;
  bool isSigningIn = false;
  bool hidePassword = true;
  ScreenSize screenSize = ScreenSize.large;

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
    showSnackBar(context, 'Signing In...');
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
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const DesktopApp()),
              (route) => false);
        }
      } else {
        showSnackBar(context, value['error']);
      }
      isSigningIn = false;
      setState(() {});
    });
  }

  void sendOtp() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'email': _emailController.text,
      })
    };
    showSnackBar(context, 'Sending OTP...');
    final result = await UserApiProvider.forgotPasswordVerification(post);
    if (result['error'].toString().isEmpty) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DesktopForgotPassword(
                      email: _emailController.text,
                    )),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnackBar(context, result['error']);
      }
    }
  }

  @override
  void initState() {
    focusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = getScreenSize(context);
    Widget loginContent = SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: kGlobalOuterPadding,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Visibility(
                  visible: kIsWeb,
                  child: Text(
                    kAppName,
                    style: TextStyle(fontSize: 36),
                  ),
                ),
                const Visibility(visible: kIsWeb, child: kVSpace),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                kVSpace,
                TextFormField(
                  controller: _emailController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Symbols.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (!RegExp(kEmailRegEx).hasMatch(value)) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    focusNodePassword.requestFocus();
                  },
                ),
                kVSpace,
                TextFormField(
                  focusNode: focusNodePassword,
                  controller: _pwdController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Symbols.password),
                      suffixIcon: IconButton(
                        icon: hidePassword
                            ? const Icon(Symbols.visibility)
                            : const Icon(Symbols.visibility_off),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                ),
                kVSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Text('Forgot password?'),
                      onTap: () {
                        if (_emailController.text.isNotEmpty) {
                          sendOtp();
                        } else {
                          showSnackBar(context, 'Enter Email address!');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: isSigningIn
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  signIn();
                                }
                              },
                        child: const Text('Sign In'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const DesktopSignUp()),
                                (route) => false),
                        child: const Text('Register Now'),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
    return screenSize == ScreenSize.large
        ? Scaffold(
            backgroundColor: kPrimaryColor.withOpacity(0.2),
            resizeToAvoidBottomInset: false,
            body: Row(
              children: [
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
                      child: Card(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 50),
                            child: loginContent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: kPrimaryColor.withOpacity(0.2),
            body: Container(
              margin: const EdgeInsets.only(top: 56),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'images/welcome.svg',
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ],
              ),
            ),
            bottomSheet:
                Padding(padding: kGlobalOuterPadding * 2, child: loginContent),
          );
  }
}
