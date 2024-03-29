import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/widgets/scrawl_appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileAboutPage extends StatefulWidget {
  const MobileAboutPage({super.key});

  @override
  State<MobileAboutPage> createState() => _MobileAboutPageState();
}

class _MobileAboutPageState extends State<MobileAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: ScrawlAppBar(
          middle: const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/scrawler-desktop.png',
              height: 100,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              kAppName,
              style: TextStyle(fontSize: 32.0),
            ),
            const Text(
              'v.1.5.1 (tomato)',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 30.0,
            ),
            FilledButton(
              onPressed: () => _launchUrl(kWebsiteUrl),
              child: const Text('Website'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            OutlinedButton(
              onPressed: () => _launchUrl(kGithubUrl),
              child: const Text('Source Code'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
