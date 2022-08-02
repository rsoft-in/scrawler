import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/desktop/pages/desktop_sign_up.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/providers/user_api_provider.dart';
import 'package:bnotes/widgets/scrawl_primary_button.dart';
import 'package:bnotes/widgets/scrawl_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/common/globals.dart' as globals;

class DesktopSignIn extends StatefulWidget {
  const DesktopSignIn({Key? key}) : super(key: key);

  @override
  State<DesktopSignIn> createState() => _DesktopSignInState();
}

class _DesktopSignInState extends State<DesktopSignIn> {
  bool isDesktop = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  void signIn() async {
    Map<String, String> _post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'email': _emailController.text,
        'pwd': _pwdController.text
      })
    };
    UserApiProvider.checkUserCredential(_post).then((value) {
      if (value['error'].toString().isEmpty) {
        globals.user = value['user'];
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['error']),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: kBackGroundGradient,
        child: Center(
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              width: isDesktop ? 500 : MediaQuery.of(context).size.width * 0.9,
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            kAppName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          kLabels['welcome_back']!,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          kLabels['email']!,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        ScrawlTextField(controller: _emailController),
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          kLabels['password']!,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        ScrawlTextField(
                          controller: _pwdController,
                          obscure: true,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ScrawlButtonPrimary(
                                label: kLabels['login']!,
                                onPressed: () {
                                  if (_emailController.text.isNotEmpty &&
                                      _pwdController.text.isNotEmpty) {
                                    signIn();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'Don\'t have an Account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              TextSpan(
                                  text: 'Register Now',
                                  style: TextStyle(
                                    color: kLinkColor,
                                    fontFamily: 'Raleway',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new DesktopSignUp()),
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
    );
  }
}
