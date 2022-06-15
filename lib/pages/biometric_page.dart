import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:bnotes/helpers/utility.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({Key? key}) : super(key: key);

  @override
  _BiometricPageState createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  SupportState _supportState = SupportState.unknown;
  bool? _canCheckBiometrics;
  String _message = "Not Authorized";

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print('bio');
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }
    if (_supportState == SupportState.unknown) Navigator.pop(context, false);
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Use fingerprint",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
          biometricOnly: false,
        ),
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
    _localAuthentication.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState =
              isSupported ? SupportState.supported : SupportState.unsupported),
        );

    _checkBiometrics();
    _authenticateMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_supportState == SupportState.unknown)
              const CircularProgressIndicator()
            else if (_supportState == SupportState.supported)
              Container()
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sentiment_very_dissatisfied,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'This device is not supported',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            SizedBox(
              height: 30,
            ),
            if (_supportState == SupportState.unsupported)
              OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Continue'))
          ],
        ),
      ),
    );
  }
}
