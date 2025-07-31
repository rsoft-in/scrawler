import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FHeader.nested(
          prefixes: [
            FHeaderAction.back(onPress: () => Navigator.pop(context)),
          ],
          title: Text('security'.tr()),
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
