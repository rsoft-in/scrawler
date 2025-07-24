import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FHeader.nested(
          prefixes: [
            FHeaderAction.back(onPress: () => Navigator.pop(context)),
          ],
          title: Text('about'.tr()),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
