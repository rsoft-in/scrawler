import 'dart:convert';
import 'dart:typed_data';

import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/api_provider.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/pages/about_page.dart';
import 'package:bnotes/pages/account_page.dart';
import 'package:bnotes/pages/app_lock_page.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:bnotes/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'labels_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences sharedPreferences;
  bool isAppLogged = false;
  late String username;
  late String useremail;
  Uint8List? avatarData;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppLogged = sharedPreferences.getBool('is_logged') ?? false;
      username = sharedPreferences.getString('nc_userdisplayname') ?? '';
      useremail = sharedPreferences.getString('nc_useremail') ?? '';
      avatarData = base64Decode(sharedPreferences.getString('nc_avatar') ?? '');
    });
  }

  checkUser() async {
    Map<String, String> post = {
      'postdata':
          jsonEncode({'email': 'nandanrmenon@gmail.com', 'name': 'Nandan'})
    };
    ApiProvider.fetchClients(post).then((res) async {
      print(res);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 56),
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: kGlobalOuterPadding,
                child: Column(
                  children: [
                    Padding(
                      padding: kGlobalCardPadding,
                      child: (isAppLogged
                          ? InkWell(
                              onTap: () async {
                                final res = await Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) => AccountPage()));
                                if (res is String) {
                                  getPref();
                                }
                              },
                              borderRadius: BorderRadius.circular(15.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  foregroundColor: Colors.blue,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: avatarData != null
                                        ? Image(
                                            image: MemoryImage(avatarData!),
                                            width: 100,
                                          )
                                        : Image(
                                            image:
                                                AssetImage('images/bnotes.png'),
                                            width: 100,
                                          ),
                                  ),
                                ),
                                title: Text(username),
                                subtitle: Text(useremail),
                              ),
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(15.0),
                              onTap: () async {
                                final result = await Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) => LoginPage()));
                                if (result == true)
                                  setState(() {
                                    isAppLogged = true;
                                    getPref();
                                  });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  foregroundColor: Colors.blue,
                                  child: Icon(LineIcons.user),
                                ),
                                title: Text('Nextcloud Login'),
                                subtitle: Text('Sync Notes to cloud'),
                              ),
                            )),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => LabelsPage(
                                    noteid: '',
                                    notelabel: '',
                                  )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple[100],
                            foregroundColor: Colors.purple,
                            child: Icon(LineIcons.tag),
                          ),
                          title: Text('Labels'),
                          subtitle: Text('Create labels'),
                        ),
                      ),
                    ),
                    // Archive
                    // Padding(
                    //   padding: kGlobalCardPadding,
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //       Navigator.of(context).push(CupertinoPageRoute(
                    //           builder: (context) => LabelsPage(
                    //                 noteid: '',
                    //                 notelabel: '',
                    //               )));
                    //     },
                    //     child: ListTile(
                    //       leading: CircleAvatar(
                    //         backgroundColor: Colors.red[100],
                    //         foregroundColor: Colors.red,
                    //         child: Icon(Icons.archive_outlined),
                    //       ),
                    //       title: Text('Archive'),
                    //       subtitle: Text('See your archived notes'),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () async {
                          final res = await Navigator.of(context).push(
                              CupertinoPageRoute(
                                  builder: (context) => BackupRestorePage()));
                          if (res == "yes") {
                            // loadNotes();
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[100],
                            foregroundColor: Colors.teal,
                            child: Icon(LineIcons.archiveFile),
                          ),
                          title: Text('Backup & Restore'),
                          subtitle: Text('Bring back the dead'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => AppLockPage(appLockState: AppLockState.SET,)));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red,
                            child: Icon(LineIcons.lock),
                          ),
                          title: Text('App Lock'),
                          subtitle: Text('Secure your notes'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () async {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => AboutPage()));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.grey,
                            child: Icon(Icons.info_outline_rounded),
                          ),
                          title: Text('About'),
                          subtitle: Text('Know the Team'),
                        ),
                      ),
                    ),
                    // ElevatedButton(onPressed: () {
                    //   checkUser();
                    // }, child: Text('API'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
