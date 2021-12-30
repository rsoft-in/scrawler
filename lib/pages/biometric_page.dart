import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({Key? key}) : super(key: key);

  @override
  _BiometricPageState createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print('bio');
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authenticate for Testing",
        useErrorDialogs: true,
        stickyAuth: true,
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (authenticated) Navigator.pop(context, true);
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    _authenticateMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
