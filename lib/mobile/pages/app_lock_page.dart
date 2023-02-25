// ignore_for_file: non_constant_identifier_names

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/utility.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/mobile/pages/app.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockPage extends StatefulWidget {
  final AppLockState appLockState;
  const AppLockPage({Key? key, required this.appLockState}) : super(key: key);

  @override
  State<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  late SharedPreferences prefs;
  String pinNumber = '';
  String pinNumberConfirmed = '';
  bool isAppUnlocked = false;
  bool useBiometric = false;
  String helperText = "";
  final String SET_PIN = 'Set your PIN';
  final String CONFIRM_PIN = 'Confirm PIN';
  final String ENTER_PIN = 'Enter PIN';
  final String LOCK_SET = 'App lock set!';
  final String PIN_MISMATCH = 'Pin mismatch';
  final String INVALID_PIN = 'Invalid PIN!';

  getPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isAppUnlocked = prefs.getBool("is_app_unlocked") ?? false;
      useBiometric = prefs.getBool('use_biometric') ?? false;
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
    if (widget.appLockState == AppLockState.set) {
      helperText = SET_PIN;
    } else {
      helperText = ENTER_PIN;
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    return Scaffold(
      backgroundColor: FlexColor.jungleDarkPrimary,
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: kGlobalOuterPadding,
                    child: Text(
                      helperText,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: kGlobalOuterPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PinDots(
                          isFilled: pinNumber.isNotEmpty,
                        ),
                        PinDots(
                          isFilled: pinNumber.length > 1,
                        ),
                        PinDots(
                          isFilled: pinNumber.length > 2,
                        ),
                        PinDots(
                          isFilled: pinNumber.length > 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinButton(
                        onTap: () => setPin('1'),
                        child: const Text(
                          '1',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      PinButton(
                        onTap: () => setPin('2'),
                        child: const Text(
                          '2',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      PinButton(
                        onTap: () => setPin('3'),
                        child: const Text(
                          '3',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinButton(
                        onTap: () => setPin('4'),
                        child: const Text(
                          '4',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      PinButton(
                        onTap: () => setPin('5'),
                        child: const Text(
                          '5',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      PinButton(
                        onTap: () => setPin('6'),
                        child: const Text(
                          '6',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinButton(
                        onTap: () => setPin('7'),
                        child: const Text(
                          '7',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      PinButton(
                        onTap: () => setPin('8'),
                        child: const Text(
                          '8',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      PinButton(
                        onTap: () => setPin('9'),
                        child: const Text(
                          '9',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: widget.appLockState == AppLockState.set,
                        child: FunctionButton(
                            onTap: () => Navigator.pop(context, 'no'),
                            child: const Icon(Icons.arrow_back)),
                      ),
                      Visibility(
                          visible: widget.appLockState != AppLockState.set,
                          child: SizedBox(
                            height: 100,
                            width: 100,
                          )),
                      PinButton(
                        onTap: () => setPin('0'),
                        child: const Text(
                          '0',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      FunctionButton(
                          onTap: () => deleteDigit(),
                          child: const Icon(Icons.backspace_outlined)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setPin(String pinDigit) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (pinNumber.length < 4) {
        pinNumber += pinDigit;
      }

      // FOR LOGIN TO APP
      if (pinNumber.length == 4 &&
          widget.appLockState == AppLockState.confirm) {
        if (pinNumber == prefs.getString('app_pin')) {
          // Store Logged status in Shared Preferences
          prefs.setBool("is_app_unlocked", true);

          Navigator.of(context).pushAndRemoveUntil(
              new CupertinoPageRoute(
                  builder: (BuildContext context) => new ScrawlApp()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              behavior: SnackBarBehavior.floating, content: Text(INVALID_PIN)));
          pinNumber = '';
          helperText = ENTER_PIN;
        }
      }

      // FOR SETTING OR RESETTING PIN
      if (pinNumber.length == 4 && widget.appLockState == AppLockState.set) {
        if (pinNumberConfirmed.isEmpty) {
          pinNumberConfirmed = pinNumber;
          pinNumber = '';
          helperText = CONFIRM_PIN;
        }
        if (pinNumber.length == 4 && pinNumberConfirmed.length == 4) {
          if (pinNumber == pinNumberConfirmed) {
            // Store the PIN in Shared Preferences
            prefs.setBool("is_app_unlocked", true);
            prefs.setBool("is_pin_required", true);
            prefs.setString("app_pin", pinNumber);
            print('dingdong');
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                behavior: SnackBarBehavior.floating, content: Text(LOCK_SET)));
          } else {
            pinNumber = '';
            pinNumberConfirmed = '';
            helperText = SET_PIN;
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(PIN_MISMATCH)));
          }
        }
      }
    });
  }

  void deleteDigit() {
    setState(() {
      if (pinNumber.isNotEmpty) {
        pinNumber = pinNumber.substring(0, pinNumber.length - 1);
      }
    });
  }
}

class PinDots extends StatefulWidget {
  final bool isFilled;
  const PinDots({Key? key, required this.isFilled}) : super(key: key);

  @override
  _PinDotsState createState() => _PinDotsState();
}

class _PinDotsState extends State<PinDots> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: widget.isFilled
            ? (darkModeOn ? Colors.white : Colors.black)
            : Colors.transparent,
        border: Border.all(
          color: (darkModeOn ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class PinButton extends StatefulWidget {
  final Widget child;
  final Function onTap;
  const PinButton({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  _PinButtonState createState() => _PinButtonState();
}

class _PinButtonState extends State<PinButton> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        focusColor: kPrimaryColor,
        // splashColor: kPrimaryColor,
        highlightColor: kPrimaryColor.withOpacity(0.2),
        onTap: () => widget.onTap(),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class FunctionButton extends StatefulWidget {
  final Widget child;
  final Function onTap;
  const FunctionButton({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  _FunctionButtonState createState() => _FunctionButtonState();
}

class _FunctionButtonState extends State<FunctionButton> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        highlightColor: kPrimaryColor.withOpacity(0.2),
        onTap: () => widget.onTap(),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
