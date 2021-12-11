import 'package:bnotes/constants.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud/nextcloud.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _hostController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late SharedPreferences loginPreferences;
  bool isLoading = false;

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: kGlobalOuterPadding,
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Nextcloud_Logo.svg/2560px-Nextcloud_Logo.svg.png',
                  width: 200,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _hostController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    icon: Icon(Icons.http),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    icon: Icon(Icons.password),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_hostController.text.isNotEmpty &&
                            _usernameController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          getdata();
                        }
                      },
                      child: Text('Sign-In')),
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  title: Text('Register'),
                  subtitle: Text('on Nextcloud Provider'),
                  trailing: OutlinedButton(
                    child: Text('Qloud'),
                    onPressed: () => _launchURL(
                        'https://efss.qloud.my/index.php/apps/registration/'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _restoreNote() async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container(
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 150,
                child: Padding(
                  padding: kGlobalOuterPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: kGlobalCardPadding,
                        child: Text(
                          'Restore',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: kGlobalCardPadding,
                        child:
                            Text('Do you want to restore your previous notes?'),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context,
                                      'yes'); // Confirmation Dialog Pop
                                  Navigator.pop(
                                      context, true); // Login Page Pop
                                },
                                child: Text('No'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, true); // Confirmation Dialog Pop
                                  Navigator.pop(
                                      context, true); // Login Page Pop
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          BackupRestorePage()));
                                },
                                child: Text('Yes'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future getdata() async {
    loginPreferences = await SharedPreferences.getInstance();
    try {
      showLoaderDialog(context);
      // setState(() {
      //   isLoading = true;
      // });

      final client = NextCloudClient.withCredentials(
        Uri(host: _hostController.text),
        _usernameController.text,
        _passwordController.text,
      );

      final user = await client.user.getUser();
      print(user);

      // ignore: unnecessary_null_comparison
      if (user != null) {
        loginPreferences.setString('nc_host', _hostController.text);
        loginPreferences.setString('nc_username', _usernameController.text);
        loginPreferences.setString('nc_password', _passwordController.text);

        loginPreferences.setString('nc_userdisplayname', user.displayName);
        loginPreferences.setString('nc_useremail', user.email);

        final userData = await client.avatar.getAvatar(
            loginPreferences.getString('nc_username').toString(), 150);
        loginPreferences.setString('nc_avatar', userData);
        loginPreferences.setBool('is_logged', true);
        loginPreferences.setBool('nextcloud_backup', true);
        // setState(() {
        //   isLoading = false;
        // });
        Navigator.pop(context);
        _restoreNote();
      } else {
        setState(() {
          isLoading = false;
        });
        _showAlert();
      }
    } on RequestException catch (e, stacktrace) {
      print('qs' + e.statusCode.toString());
      print(e.body);
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text('Unable to login. Try again.'),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      elevation: 1,
      title: Text('Logging in'),
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text('Please wait')),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
          title: Text('Error'),
        );
      },
    );
  }
}
