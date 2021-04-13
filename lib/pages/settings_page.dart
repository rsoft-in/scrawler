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
  SharedPreferences sharedPreferences;
  bool isLogged = false;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLogged = sharedPreferences.getBool('is_logged') ?? false;
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
      appBar: AppBar(
        title: Text('Accounts & Settings'),
      ),
      body: ListView(
        children: [
          (isLogged
              ? ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue,
                    child: Icon(CupertinoIcons.person),
                  ),
                  title:
                      Text(sharedPreferences.getString('nc_userdisplayname')),
                  subtitle: Text(sharedPreferences.getString('nc_useremail')),
                  onTap: () {},
                )
              : ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue,
                    child: Icon(CupertinoIcons.person),
                  ),
                  title: Text('Nextcloud Login'),
                  subtitle: Text('Sync Notes to cloud'),
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    if (result == true)
                      setState(() {
                        isLogged = true;
                      });
                  },
                )),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber[100],
              foregroundColor: Colors.amber,
              child: Icon(CupertinoIcons.tag),
            ),
            title: Text('Labels'),
            subtitle: Text('Create labels'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LabelsPage(
                      noteid: '',
                      notelabel: '',
                    ))),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple[100],
              foregroundColor: Colors.deepPurple,
              child: Icon(CupertinoIcons.lock_shield),
            ),
            title: Text('App Lock'),
            subtitle: Text('Secure your notes'),
            onTap: () {},
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[100],
              foregroundColor: Colors.red,
              child: Icon(CupertinoIcons.cloud_upload),
            ),
            title: Text('Backup & Restore'),
            subtitle: Text('Bring back the dead'),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BackupRestorePage())),
          ),
        ],
      ),
    );
  }
}
