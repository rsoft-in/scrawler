import 'package:bnotes/constants.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud/nextcloud.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _hostController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences loginPreferences;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Nextcloud'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Card(
          color: Colors.blue[100],
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(5.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)), // set rounded corner radius
                  ),
                  child: TextField(
                    keyboardType: TextInputType.url,
                    controller: _hostController,
                    decoration: InputDecoration(
                      hintText: 'Host',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)), // set rounded corner radius
                  ),
                  child: TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)), // set rounded corner radius
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_hostController.text.isNotEmpty &&
                            _usernameController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          getdata();
                        }
                      },
                      child: Text('Login')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getdata() async {
    loginPreferences = await SharedPreferences.getInstance();
    try {
      final client = NextCloudClient.withCredentials(
        Uri(host: _hostController.text),
        _usernameController.text,
        _passwordController.text,
      );
      print(client);
      // await listFiles(client).then((value) {});

      final user = await client.user.getUser();
      print(user);
      print('hi');
      if (user != null) {

        loginPreferences.setString('nc_host', _hostController.text);
        loginPreferences.setString('nc_username', _usernameController.text);
        loginPreferences.setString('nc_password', _passwordController.text);

        loginPreferences.setString('nc_userdisplayname', user.displayName);
        loginPreferences.setString('nc_useremail', user.email);
        loginPreferences.setBool('is_logged', true);

        Navigator.pop(context, true);
      }
      else{
        _showAlert();
      }
    } on RequestException catch (e, stacktrace) {
      print('qs'+ e.statusCode.toString());
      print(e.body);
      print(stacktrace);
      _showAlert();
    }
  }

  Future listFiles(NextCloudClient client) async {
    final files = await client.webDav.ls('/');
    for (final file in files) {
      print(file.path);
    }
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ssd'),
        );
      },
    );
  }
}
