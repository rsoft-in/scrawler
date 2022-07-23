import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/widgets/scrawl_primary_button.dart';
import 'package:bnotes/widgets/scrawl_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DesktopSignIn extends StatefulWidget {
  const DesktopSignIn({Key? key}) : super(key: key);

  @override
  State<DesktopSignIn> createState() => _DesktopSignInState();
}

class _DesktopSignInState extends State<DesktopSignIn> {
  bool isDesktop = false;

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF0072A2),
          Color(0xFF18837c),
          Color(0xFF33b864)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
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
                                fontSize: 40.0, fontWeight: FontWeight.w500),
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
                        ScrawlTextField(),
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
                                    onPressed: () {})),
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
                                      print('Login Text Clicked');
                                    }),
                            ]),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Expanded(child: Text('Don\'t have an Account?')),
                        //     kHSpace,
                        //     ScrawlButtonLink(
                        //         label: 'Register Now', onPressed: () {}),
                        //   ],
                        // ),
                      ]),
                ),
              )),
        ),
      ),
    );
  }
}
