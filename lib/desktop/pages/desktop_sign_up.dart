import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/desktop/pages/desktop_sign_in.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/widgets/scrawl_otp_textfield.dart';
import 'package:bnotes/widgets/scrawl_primary_button.dart';
import 'package:bnotes/widgets/scrawl_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DesktopSignUp extends StatefulWidget {
  const DesktopSignUp({Key? key}) : super(key: key);

  @override
  State<DesktopSignUp> createState() => _DesktopSignUpState();
}

class _DesktopSignUpState extends State<DesktopSignUp> {
  bool isDesktop = false;
  int showIndex = 0;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  ScrawlOtpFieldController otpController = ScrawlOtpFieldController();

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: kBackGroundGradient,
        child: Row(
          children: [
            Visibility(
                visible: isDesktop,
                child: Expanded(flex: 2, child: Container())),
            Expanded(
              flex: 1,
              child: Container(
                  width:
                      isDesktop ? 500 : MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height,
                  // height: 600,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 60),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            // SCREEN 1
                            Visibility(
                              visible: showIndex == 0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: Text(
                                  kLabels['join_the_family']!,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 0,
                              child: Text(
                                kLabels['email']!,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: ScrawlTextField(
                                  controller: emailController,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 0,
                              child: Text(
                                kLabels['fullname']!,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: ScrawlTextField(
                                  controller: fullNameController,
                                ),
                              ),
                            ),
                            // SCREEN 2
                            Visibility(
                              visible: showIndex == 1,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  kLabels['verify_email']!,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 1,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: Text(
                                  kLabels['otp_sent_to_email']!,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 1,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: Text(
                                  kLabels['otp']!,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showIndex == 1,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ScrawlOtpTextField(
                                            length: 6,
                                            otpController: otpController,
                                            onChanged: (pin) {
                                              print("Changed: " + pin);
                                            },
                                            onCompleted: (pin) {
                                              print("Completed: " + pin);
                                            })),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: ScrawlButtonPrimary(
                                        label: kLabels['continue']!,
                                        onPressed: () {
                                          showIndex++;
                                          setState(() {});
                                        })),
                              ],
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Already have an Account? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Raleway',
                                    ),
                                  ),
                                  TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: kLinkColor,
                                        fontFamily: 'Raleway',
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new DesktopSignIn()),
                                                  (route) => false);
                                        }),
                                ]),
                              ),
                            ),
                          ]),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
