import 'dart:convert';
import 'dart:typed_data';

import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late SharedPreferences loginPreferences;
  bool isLoading = false;
  Uint8List? avatarData;
  String username = '';
  String useremail = '';

  getPref() async {
    loginPreferences = await SharedPreferences.getInstance();
    setState(() {
      avatarData = base64Decode(loginPreferences.getString('nc_avatar') ?? '');
      username = loginPreferences.getString('nc_userdisplayname')!;
      useremail = loginPreferences.getString('nc_useremail')!;
    });
  }

  @override
  void initState() {
    // getdata();
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: kGlobalOuterPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: kGlobalOuterPadding,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: avatarData != null
                            ? Image(
                                image: MemoryImage(avatarData!),
                                width: 100,
                              )
                            : Image(
                                image: AssetImage('images/bnotes.png'),
                                width: 100,
                              ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalOuterPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(username, style: TextStyle(fontSize: 24)),
                          Text(useremail, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: kGlobalOuterPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: kGlobalOuterPadding,
                        child: TextButton(
                            onPressed: () {
                              loginPreferences.clear();
                              Navigator.pop(context, 'yes');
                            },
                            child: Text('Log Out')),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getdata() async {
    loginPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        isLoading = true;
      });
      final client = NextCloudClient.withCredentials(
        Uri(host: loginPreferences.getString('nc_host')),
        loginPreferences.getString('nc_username') ?? '',
        loginPreferences.getString('nc_password') ?? '',
      );
      final user = await client.user.getUser();
      print(user);
      setState(() {
        isLoading = false;
      });
      getPref();
      // ignore: unnecessary_null_comparison
    } on RequestException catch (e, stacktrace) {
      print('qs' + e.statusCode.toString());
      print(e.body);
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Unable to login. Try again.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
