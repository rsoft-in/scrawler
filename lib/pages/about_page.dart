import 'package:bnotes/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: kGlobalOuterPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: kGlobalOuterPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/bnotes-transparent.png',
                        height: 100,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text(
                            kAppName,
                            style: TextStyle(
                                fontFamily: 'Raleway', fontSize: 24.0),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: kGlobalOuterPadding,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Contributors',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () async {
                    if (await canLaunch('https://github.com/Nandanrmenon')) {
                      await launch(
                        'https://github.com/Nandanrmenon',
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch';
                    }
                  },
                  child: ListTile(
                    title: Text('Nandan Menon (nahnah)'),
                    subtitle: Text('Lead Dev & app design'),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () async {
                    if (await canLaunch('https://github.com/suranjum')) {
                      await launch(
                        'https://github.com/suranjum',
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch';
                    }
                  },
                  child: ListTile(
                    title: Text('Rajesh Menon (suranjum)'),
                    subtitle: Text('Lead Dev'),
                  ),
                ),
                Padding(
                  padding: kGlobalOuterPadding,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Links',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () async {
                    if (await canLaunch('https://t.me/srawlapp')) {
                      await launch(
                        'https://t.me/srawlapp',
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch';
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          darkModeOn ? Colors.black54 : Colors.grey[100],
                      foregroundColor: darkModeOn ? Colors.white : Colors.grey,
                      child: Icon(LineIcons.telegram),
                    ),
                    title: Text('Telegram Channel'),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () async {
                    if (await canLaunch(
                        'https://github.com/rsoft-in/scrawl/issues/new')) {
                      await launch(
                        'https://github.com/rsoft-in/scrawl/issues/new',
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch';
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          darkModeOn ? Colors.black54 : Colors.grey[100],
                      foregroundColor: darkModeOn ? Colors.white : Colors.grey,
                      child: Icon(LineIcons.bug),
                    ),
                    title: Text('Report Bug'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
