import 'dart:convert';
import 'dart:typed_data';

import 'package:bnotes/common/constants.dart';
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
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

import 'labels_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences sharedPreferences;
  bool isAppLogged = false;
  bool isAppUnlocked = false;
  bool usePin = false;
  bool useBiometric = false;
  late String username;
  late String useremail;
  Uint8List? avatarData;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = false;
  bool _isExpanded = false;

  int themeModeState = 0;
  String themeModeStateName = '';
  ThemeMode themeMode = ThemeMode.system;
  String _themeModeName = 'System';

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppUnlocked = sharedPreferences.getBool("is_app_unlocked") ?? false;
      usePin = sharedPreferences.getBool("is_pin_required") ?? false;
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
      } else if (value == '2') {
        themeMode = ThemeMode.dark;
        sharedPreferences.setInt('themeMode', 2);
        print(sharedPreferences.getInt('themeMode'));
        Phoenix.rebirth(context);
      } else {
        themeMode = ThemeMode.system;
        sharedPreferences.setInt('themeMode', 3);
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
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 100.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: darkModeOn ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 30, bottom: 15),
              ),
            ),
          ];
        },
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                            ? Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: darkModeOn
                                          ? Colors.white24
                                          : Colors.black12,
                                    )),
                                child: Container(
                                  padding: kGlobalCardPadding * 3,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                    image: MemoryImage(
                                                        avatarData!),
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
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                            onPrimary: darkModeOn
                                                ? Colors.black
                                                : Colors.white,
                                          ),
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
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: () async {
                                  if (!UniversalPlatform.isDesktop) {
                                    final result = await Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                            builder: (context) => LoginPage()));

                                    setState(() {});
                                    if (result == true)
                                      setState(() {
                                        isAppLogged = true;
                                        getPref();
                                      });
                                  } else {
                                    // final result = await Navigator.of(context)
                                    //     .push(CupertinoPageRoute(
                                    //         builder: (context) => LoginPage()));
                                    openDialog(LoginPage());
                                    setState(() {});
                                    // if (result == true)
                                    //   setState(() {
                                    //     isAppLogged = true;
                                    //     getPref();
                                    //   });
                                  }
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    // backgroundColor: Colors.blue[100],
                                    // foregroundColor: Colors.blue,
                                    child: Icon(Iconsax.user),
                                  ),
                                  title: Text(
                                    'Nextcloud Login',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text('Sync Notes to cloud'),
                                ),
                              )),
                      ),
                      Padding(
                        padding: kGlobalCardPadding,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => LabelsPage(
                                      noteid: '',
                                      notelabel: '',
                                    )));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: Colors.purple[100],
                              // foregroundColor: Colors.purple,
                              child: Icon(Iconsax.tag),
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
                          borderRadius: BorderRadius.circular(10.0),
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
                              // backgroundColor: Colors.teal[100],
                              // foregroundColor: Colors.teal,
                              child: Icon(Iconsax.document_download),
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
                            // backgroundColor: Colors.red[100],
                            // foregroundColor: Colors.red,
                            child: Icon(Iconsax.lock),
                          ),
                          title: Text('App Lock',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Icon(Iconsax.arrow_down_1),
                          children: [
                            if (!usePin && !useBiometric)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {
                                    if (usePin) {
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
                            if (!usePin)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 20,
                                  ),
                                  title: Text(
                                    'Use Biometric',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Switch.adaptive(
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
                            if (usePin)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
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
                            if (usePin)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            themeDialog();
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: Colors.grey[100],
                              // foregroundColor: Colors.grey,
                              child: Icon(Iconsax.moon),
                            ),
                            title: Text(
                              'App Theme',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(_themeModeName),
                          ),
                        ),
                      ),
                      Padding(
                        padding: kGlobalCardPadding,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AboutPage()));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: Colors.grey[100],
                              // foregroundColor: Colors.grey,
                              child: Icon(Iconsax.info_circle),
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
      ),
    );
  }

  openDialog(Widget page) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: darkModeOn ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: darkModeOn ? Colors.white24 : Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
                decoration: BoxDecoration(
                  color: darkModeOn ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                    maxWidth: 600,
                    minWidth: 400,
                    minHeight: 600,
                    maxHeight: 600),
                padding: EdgeInsets.all(8),
                child: page),
          );
        });
  }

  void themeDialog() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 40.0),
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 200,
                child: Padding(
                  padding: kGlobalOuterPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Change theme',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: FlexColor.jungleDarkSecondary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 18),
                        child: Text(
                          _themeModeName,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: FlexColor.jungleDarkSecondary),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.sun_1,
                                    size: 30,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Light',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => setThemeMode(context, '0'),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.moon,
                                    size: 30,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Dark',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => setThemeMode(context, '1'),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.setting,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'System',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => setThemeMode(context, '2'),
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
            margin: EdgeInsets.only(bottom: 10.0),
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
      usePin = false;
    });
  }
}
