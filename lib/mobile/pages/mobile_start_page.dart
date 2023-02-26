import 'package:bnotes/mobile/pages/mobile_home_page.dart';
import 'package:bnotes/mobile/pages/mobile_signin_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileStartPage extends StatefulWidget {
  const MobileStartPage({Key? key}) : super(key: key);

  @override
  State<MobileStartPage> createState() => _MobileStartPageState();
}

class _MobileStartPageState extends State<MobileStartPage> {
  late SharedPreferences prefs;
  bool isVerifiedUser = false;
  bool isUserSignedIn = false;

  getPref(context) async {
    prefs = await SharedPreferences.getInstance();
    isVerifiedUser = prefs.getBool("is_verified_user") ?? false;
    isUserSignedIn = prefs.getBool("is_used_signedin") ?? false;
    if (isVerifiedUser) {
      if (isUserSignedIn) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MobileHomePage()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MobileSignIn()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileHomePage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    getPref(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'images/bnotes.png',
                  width: 120,
                )),
          ],
        ),
      ),
    );
  }
}
