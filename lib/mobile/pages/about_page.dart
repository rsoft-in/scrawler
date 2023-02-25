import 'package:bnotes/common/constants.dart';
import 'package:bnotes/widgets/small_appbar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    getAppInfo();
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SAppBar(
          title: 'About',
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
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
                      child: const Text(
                        kAppName,
                        style: TextStyle(fontFamily: 'Raleway', fontSize: 24.0),
                      )),
                ],
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {},
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Iconsax.cpu),
                ),
                title: const Text('App Version'),
                subtitle: Text(_packageInfo.version),
              ),
            ),
            const Padding(
              padding: kGlobalOuterPadding,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  'Contributors',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                await launchUrl(Uri.parse('https://github.com/Nandanrmenon'));
              },
              child: const ListTile(
                leading: CircleAvatar(
                  child: Icon(Iconsax.user),
                ),
                title: Text('Nandan Menon (nahnah)'),
                subtitle: Text('Lead Dev & app design'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                await launchUrl(
                  Uri.parse('https://github.com/suranjum'),
                );
              },
              child: const ListTile(
                leading: CircleAvatar(
                  child: Icon(Iconsax.user),
                ),
                title: Text('Rajesh Menon (suranjum)'),
                subtitle: Text('Lead Dev'),
              ),
            ),
            const Padding(
              padding: kGlobalOuterPadding,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  'Links',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                await launchUrl(
                  Uri.parse('https://t.me/srawlapp'),
                );
              },
              child: const ListTile(
                leading: CircleAvatar(
                  child: Icon(LineIcons.telegram),
                ),
                title: Text('Telegram Channel'),
                subtitle: Text('Latest news about \'scrawl\''),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                await launchUrl(
                  Uri.parse('https://paypal.me/nandanrmenon'),
                );
              },
              child: const ListTile(
                leading: CircleAvatar(
                  child: Icon(LineIcons.github),
                ),
                title: Text('Github'),
                subtitle: Text('Check out our source code'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                await launchUrl(
                  Uri.parse('https://github.com/rsoft-in/scrawl/issues/new'),
                );
              },
              child: const ListTile(
                leading: CircleAvatar(
                  child: Icon(LineIcons.bug),
                ),
                title: Text('Report Bug'),
                subtitle: Text('Found a bug? Report here.'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                await launchUrl(
                  Uri.parse('https://paypal.me/nandanrmenon'),
                );
              },
              child: const ListTile(
                leading: CircleAvatar(
                  child: Icon(LineIcons.donate),
                ),
                title: Text('Donate us!'),
                subtitle: Text('using PayPal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
