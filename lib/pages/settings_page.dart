import 'dart:convert';
import 'dart:typed_data';

import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/pages/about_page.dart';
import 'package:bnotes/pages/account_page.dart';
import 'package:bnotes/pages/app_lock_page.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:bnotes/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import 'labels_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences sharedPreferences;
  bool isAppLogged = false;
  bool isAppUnlocked = false;
  bool isPinRequired = false;
  late String username;
  late String useremail;
  Uint8List? avatarData;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = UniversalPlatform.isDesktop;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppUnlocked = sharedPreferences.getBool("is_app_unlocked") ?? false;
      isPinRequired = sharedPreferences.getBool("is_pin_required") ?? false;
      isAppLogged = sharedPreferences.getBool('is_logged') ?? false;
      username = sharedPreferences.getString('nc_userdisplayname') ?? '';
      useremail = sharedPreferences.getString('nc_useremail') ?? '';
      avatarData = base64Decode(sharedPreferences.getString('nc_avatar') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(
              //   height: 56,
              // ),
              Padding(
                padding: kGlobalOuterPadding,
                child: Column(
                  children: [
                    Padding(
                      padding: kGlobalCardPadding,
                      child: (isAppLogged
                          // ? InkWell(
                          //     onTap: () async {
                          //       final res = await Navigator.of(context).push(
                          //           CupertinoPageRoute(
                          //               builder: (context) => AccountPage()));
                          //       if (res is String) {
                          //         getPref();
                          //       }
                          //     },
                          //     borderRadius: BorderRadius.circular(15.0),
                          //     child: ListTile(
                          //       leading: CircleAvatar(
                          //         backgroundColor: Colors.blue[100],
                          //         foregroundColor: Colors.blue,
                          //         child: ClipRRect(
                          //           borderRadius: BorderRadius.circular(100),
                          //           child: avatarData != null
                          //               ? Image(
                          //                   image: MemoryImage(avatarData!),
                          //                   width: 100,
                          //                 )
                          //               : Image(
                          //                   image:
                          //                       AssetImage('images/bnotes.png'),
                          //                   width: 100,
                          //                 ),
                          //         ),
                          //       ),
                          //       title: Text(username),
                          //       subtitle: Text(useremail),
                          //     ),
                          //   )
                          ? Card(
                              child: Container(
                                padding: kGlobalCardPadding * 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: avatarData != null
                                              ? Image(
                                                  image:
                                                      MemoryImage(avatarData!),
                                                  width: 80,
                                                )
                                              : Image(
                                                  image: AssetImage(
                                                      'images/bnotes.png'),
                                                  width: 100,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(username,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)),
                                        Text(useremail,
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    Container(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.red,
                                            backgroundColor:
                                                Colors.red.withOpacity(0.2)),
                                        child: Text('Sign Out'),
                                        onPressed: () {
                                          _confirmLogOut();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
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
                            child: Icon(Icons.label_outline),
                          ),
                          title: Text('Labels'),
                          subtitle: Text('Create labels'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () async {
                          if (isAndroid) {
                            final res = await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) => BackupRestorePage()));
                            if (res == "yes") {
                              // loadNotes();
                            }
                          }
                          if (isDesktop) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width * .1),
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(8.0),
                                        child: BackupRestorePage(),
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[100],
                            foregroundColor: Colors.teal,
                            child: Icon(Icons.archive_outlined),
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
                          if (isPinRequired) {
                            showAppLockMenu();
                          } else {
                            callAppLock();
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red,
                            child: Icon(Icons.lock_outline),
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
                          if (isAndroid || isIOS) {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AboutPage()));
                          }
                          if (isDesktop) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width * .1),
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(8.0),
                                        child: AboutPage(),
                                      ),
                                    ),
                                  );
                                });
                          }
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAppLockMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (context) {
          return Container(
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 140,
                child: Card(
                  child: Padding(
                    padding: kGlobalOuterPadding,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            callAppLock();
                          },
                          child: ListTile(
                            title: Text('Reset Passcode'),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            unSetAppLock();
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            title: Text('Remove App lock'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _confirmLogOut() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (context) {
          return Container(
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 150,
                child: Card(
                  child: Padding(
                    padding: kGlobalOuterPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: kGlobalCardPadding,
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: kGlobalCardPadding,
                          child: Text('Are you sure you want to log out?'),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: kGlobalCardPadding,
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('No'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: kGlobalCardPadding,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.red,
                                      backgroundColor:
                                          Colors.red.withOpacity(0.2)),
                                  onPressed: () {
                                    sharedPreferences.clear();
                                    getPref();
                                    Navigator.pop(context, true);
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
            ),
          );
        });
  }

  void callAppLock() async {
    final res = await Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => AppLockPage(
              appLockState: AppLockState.SET,
            )));
    if (res == true) getPref();
  }

  void unSetAppLock() async {
    setState(() {
      sharedPreferences.setBool("is_pin_required", false);
      sharedPreferences.setBool("is_app_unlocked", true);
      sharedPreferences.setString("app_pin", '');
      isAppUnlocked = true;
      isPinRequired = false;
    });
  }
}
