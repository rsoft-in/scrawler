import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({super.key});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: kPaddingLarge,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'labels'.tr(),
                  style: TextStyle(fontSize: 22),
                ),
                kHSpace,
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Symbols.add),
                  label: Text('add'.tr()),
                ),
                Spacer(),
                CloseButton(
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text('Manage and Select Labels'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
