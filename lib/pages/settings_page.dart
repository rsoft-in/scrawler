import 'package:bnotes/constants.dart';
import 'package:bnotes/pages/about_page.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:bnotes/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'labels_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences sharedPreferences;
  bool isAppLogged = false;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppLogged = sharedPreferences.getBool('is_logged') ?? false;
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
                              onTap: () {},
                              borderRadius: BorderRadius.circular(15.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  foregroundColor: Colors.blue,
                                  child: Icon(Icons.person),
                                ),
                                title: Text(sharedPreferences
                                        .getString('nc_userdisplayname') ??
                                    ''),
                                subtitle: Text(sharedPreferences
                                        .getString('nc_useremail') ??
                                    ''),
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
                                  });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  foregroundColor: Colors.blue,
                                  child: Icon(Icons.person),
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
                            child: Icon(Icons.label_outlined),
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
                            child: Icon(Icons.backup_outlined),
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
