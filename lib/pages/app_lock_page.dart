import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/pages/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockPage extends StatefulWidget {
  final AppLockState appLockState;
  const AppLockPage({Key? key, required this.appLockState}) : super(key: key);

  @override
  _AppLockPageState createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  late SharedPreferences prefs;
  String pinNumber = '';
  String pinNumberConfirmed = '';
  bool isAppUnlocked = false;
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
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
    if (widget.appLockState == AppLockState.SET) {
      helperText = SET_PIN;
    } else {
      helperText = ENTER_PIN;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: kGlobalOuterPadding,
              child: Text(helperText),
            ),
            Padding(
              padding: kGlobalOuterPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PinDots(
                    isFilled: pinNumber.length > 0,
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PinButton(
                  onTap: () => setPin('1'),
                  child: Text(
                    '1',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                  onTap: () => setPin('2'),
                  child: Text(
                    '2',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                  onTap: () => setPin('3'),
                  child: Text(
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
                  child: Text(
                    '4',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                  onTap: () => setPin('5'),
                  child: Text(
                    '5',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                  onTap: () => setPin('6'),
                  child: Text(
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
                  child: Text(
                    '7',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                  onTap: () => setPin('8'),
                  child: Text(
                    '8',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                  onTap: () => setPin('9'),
                  child: Text(
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
                  visible: widget.appLockState == AppLockState.SET,
                  child: PinButton(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back)),
                ),
                Visibility(
                    visible: widget.appLockState != AppLockState.SET,
                    child: Container(
                      height: 100,
                      width: 100,
                    )),
                PinButton(
                  onTap: () => setPin('0'),
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PinButton(
                    onTap: () => deleteDigit(),
                    child: Icon(LineIcons.backspace)),
              ],
            ),
          ],
        ),
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
          widget.appLockState == AppLockState.CONFIRM) {
        if (pinNumber == prefs.getString('app_pin')) {
          // Store Logged status in Shared Preferences
          prefs.setBool("is_app_unlocked", true);

          Navigator.of(context).pushAndRemoveUntil(
              new CupertinoPageRoute(
                  builder: (BuildContext context) => new ScrawlApp()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(new SnackBar(content: Text(INVALID_PIN)));
          pinNumber = '';
          helperText = ENTER_PIN;
        }
      }

      // FOR SETTING OR RESETTING PIN
      if (pinNumber.length == 4 && widget.appLockState == AppLockState.SET) {
        if (pinNumberConfirmed.length == 0) {
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
            ScaffoldMessenger.of(context)
                .showSnackBar(new SnackBar(content: Text(LOCK_SET)));
            Navigator.pop(context);
          } else {
            pinNumber = '';
            pinNumberConfirmed = '';
            helperText = SET_PIN;
            ScaffoldMessenger.of(context)
                .showSnackBar(new SnackBar(content: Text(PIN_MISMATCH)));
          }
        }
      }
    });
  }

  void deleteDigit() {
    setState(() {
      if (pinNumber.length > 0) {
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
    return Container(
      width: 20,
      height: 20,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: widget.isFilled ? kSecondaryColor : Colors.transparent,
        border: Border.all(
          color: kSecondaryColor,
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
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => widget.onTap(),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)),
          child: widget.child,
        ),
      ),
    );
  }
}
