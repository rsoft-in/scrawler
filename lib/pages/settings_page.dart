import 'dart:convert';
import 'dart:typed_data';

import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/pages/about_page.dart';
import 'package:bnotes/pages/app_lock_page.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:bnotes/pages/biometric_page.dart';
import 'package:bnotes/pages/login_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
  bool useBiometric = false;
  late String username;
  late String useremail;
  Uint8List? avatarData;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = false;

  int themeModeState = 0;
  String themeModeStateName = '';
  ThemeMode themeMode = ThemeMode.system;
  String _themeModeName = 'System';

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppUnlocked = sharedPreferences.getBool("is_app_unlocked") ?? false;
      isPinRequired = sharedPreferences.getBool("is_pin_required") ?? false;
      isAppLogged = sharedPreferences.getBool('is_logged') ?? false;
      themeModeState = sharedPreferences.getInt('themeMode') ?? 2;
      useBiometric = sharedPreferences.getBool('use_biometric') ?? false;
      username = sharedPreferences.getString('nc_userdisplayname') ?? '';
      useremail = sharedPreferences.getString('nc_useremail') ?? '';
      avatarData = base64Decode(sharedPreferences.getString('nc_avatar') ?? '');
    });
    getThemeModeName();
  }

  setThemeMode(BuildContext context, String value) {
    print(value);
    setState(() {
      if (value == '0') {
        themeMode = ThemeMode.light;
        sharedPreferences.setInt('themeMode', 0);
        print(sharedPreferences.getInt('themeMode'));
        Phoenix.rebirth(context);
      } else if (value == '1') {
        themeMode = ThemeMode.dark;
        sharedPreferences.setInt('themeMode', 1);
        print(sharedPreferences.getInt('themeMode'));
        Phoenix.rebirth(context);
      } else {
        themeMode = ThemeMode.system;
        sharedPreferences.setInt('themeMode', 2);
        print(sharedPreferences.getInt('themeMode'));
        Phoenix.rebirth(context);
      }
      getThemeModeName();
    });
  }

  void getThemeModeName() async {
    int _themeMode = 2;
    setState(() {
      _themeMode = sharedPreferences.getInt('themeMode') ?? 2;
      switch (_themeMode) {
        case 0:
          _themeModeName = 'Light';
          break;
        case 1:
          _themeModeName = 'Dark';
          break;
        case 2:
          _themeModeName = 'System';
          break;
        default:
          _themeModeName = 'System';
          break;
      }
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          // physics:
          //     BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: UniversalPlatform.isAndroid ? 80 : 100,
              ),
              Padding(
                padding: kGlobalOuterPadding,
                child: Column(
                  children: [
                    Padding(
                      padding: kGlobalCardPadding,
                      child: (isAppLogged
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
                                      child: OutlinedButton(
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
                                if (isDesktop) {
                                  final result = await showDialog(
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
                                              child: LoginPage(),
                                            ),
                                          ),
                                        );
                                      });
                                  if (result == true)
                                    setState(() {
                                      isAppLogged = true;
                                      getPref();
                                    });
                                } else {
                                  final result = await Navigator.of(context)
                                      .push(CupertinoPageRoute(
                                          builder: (context) => LoginPage()));
                                  setState(() {});
                                  if (result == true)
                                    setState(() {
                                      isAppLogged = true;
                                      getPref();
                                    });
                                }
                                // if (result == true)
                                //   setState(() {
                                //     isAppLogged = true;
                                //     getPref();
                                //   });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  foregroundColor: Colors.blue,
                                  child: Icon(Icons.person_outline),
                                ),
                                title: Text(
                                  'Nextcloud Login',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text('Sync Notes to cloud'),
                              ),
                            )),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          if (isDesktop) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Dialog(
                                      child: Container(
                                        width: isDesktop
                                            ? 800
                                            : MediaQuery.of(context).size.width,
                                        child: LabelsPage(
                                          noteid: '',
                                          notelabel: '',
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => LabelsPage(
                                      noteid: '',
                                      notelabel: '',
                                    )));
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple[100],
                            foregroundColor: Colors.purple,
                            child: Icon(Icons.label_outline),
                          ),
                          title: Text(
                            'Labels',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Create labels'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () async {
                          if (isDesktop) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Dialog(
                                      child: Container(
                                        width: isDesktop
                                            ? 800
                                            : MediaQuery.of(context).size.width,
                                        child: BackupRestorePage(),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            final res = await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) => BackupRestorePage()));
                            if (res == "yes") {
                              // loadNotes();
                            }
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[100],
                            foregroundColor: Colors.teal,
                            child: Icon(Icons.archive_outlined),
                          ),
                          title: Text(
                            'Backup & Restore',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Bring back the dead'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: ExpansionTile(
                        subtitle: Text('Secure your notes'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[100],
                          foregroundColor: Colors.red,
                          child: Icon(Icons.lock_outline),
                        ),
                        title: Text('App Lock'),
                        children: [
                          if (!isPinRequired)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
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
                                  leading: SizedBox(
                                    width: 20,
                                  ),
                                  title: Text(
                                    'Set Pin',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: ListTile(
                              leading: SizedBox(
                                width: 20,
                              ),
                              title: Text(
                                'Use Biometric',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              trailing: UniversalPlatform.isIOS
                                  ? CupertinoSwitch(
                                      value: useBiometric,
                                      onChanged: (value) {
                                        setState(() {
                                          useBiometric = value;
                                          if (value) {
                                            confirmBiometrics();
                                          } else {
                                            sharedPreferences.setBool(
                                                'use_biometric', false);
                                          }
                                          print(useBiometric);
                                        });
                                      },
                                    )
                                  : Switch(
                                      value: useBiometric,
                                      onChanged: (value) {
                                        setState(() {
                                          useBiometric = value;
                                          if (value) {
                                            confirmBiometrics();
                                          } else {
                                            sharedPreferences.setBool(
                                                'use_biometric', false);
                                          }
                                          print(useBiometric);
                                        });
                                      },
                                    ),
                            ),
                          ),
                          if (isPinRequired)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  callAppLock();
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 20,
                                  ),
                                  title: Text(
                                    'Reset Passcode',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          if (isPinRequired)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  unSetAppLock();
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 20,
                                  ),
                                  title: Text(
                                    'Remove App lock',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: PopupMenuButton(
                          padding: EdgeInsets.all(50),
                          tooltip: 'Choose Theme',
                          offset: Offset(100, 0),
                          itemBuilder: (_) => <PopupMenuItem<String>>[
                            new PopupMenuItem<String>(
                                child: const Text('Light'), value: '0'),
                            new PopupMenuItem<String>(
                                child: const Text('Dark'), value: '1'),
                            new PopupMenuItem<String>(
                                child: const Text('System'), value: '2'),
                          ],
                          onSelected: (value) =>
                              setThemeMode(context, value.toString()),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange[100],
                              foregroundColor: Colors.orange,
                              child: Icon(Icons.dark_mode_outlined),
                            ),
                            title: Text('App Theme'),
                            subtitle: Text(_themeModeName),
                            trailing: Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: kGlobalCardPadding,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () async {
                          if (isDesktop) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Dialog(
                                      child: Container(
                                        width: isDesktop
                                            ? 800
                                            : MediaQuery.of(context).size.width,
                                        child: AboutPage(),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AboutPage()));
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.grey,
                            child: Icon(Icons.info_outline_rounded),
                          ),
                          title: Text(
                            'About',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
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

  void confirmBiometrics() async {
    bool res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new BiometricPage()));
    setState(() {
      if (res) {
        sharedPreferences.setBool('use_biometric', true);
        useBiometric = true;
      } else {
        sharedPreferences.setBool('use_biometric', false);
        useBiometric = false;
      }
    });
  }

  void showAppLockMenu() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: BoxConstraints(maxWidth: 800, minWidth: 300),
        builder: (context) {
          return Container(
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 140,
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
          );
        });
  }

  void _confirmLogOut() async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
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
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('No'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: ElevatedButton(
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
