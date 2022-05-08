import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:bnotes/widgets/small_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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

  bool isDesktop = false;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SAppBar(
          title: 'Nextcloud Login',
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: kGlobalOuterPadding,
        child: Container(
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
          child: ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Nextcloud_Logo.svg/2560px-Nextcloud_Logo.svg.png',
                height: 120,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _hostController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Web address',
                  icon: Icon(Iconsax.global),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Username',
                  icon: Icon(Iconsax.user),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Password',
                  icon: Icon(Iconsax.password_check),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
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
                  child: Text('Sign Up'),
                  onPressed: () => _launchURL('https://nextcloud.com/signup/'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _restoreNote() async {
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 160,
                child: Padding(
                  padding: kGlobalOuterPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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

                                  if (isDesktop) {
                                    Navigator.pop(context, true);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            child: Dialog(
                                              child: Container(
                                                width: isDesktop
                                                    ? 800
                                                    : MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                child: BackupRestorePage(),
                                              ),
                                            ),
                                          );
                                        });
                                    //Login Page Pop
                                  } else {
                                    Navigator.pop(context, true);
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                BackupRestorePage()));
                                  }
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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Unable to login. Check credentials and try again.'),
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
