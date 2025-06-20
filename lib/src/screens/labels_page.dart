import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/label.dart';
import 'package:scrawler/src/providers/labels_api_provider.dart';
import 'package:scrawler/src/widgets/scrawl_snackbar.dart';

import '../helpers/globals.dart' as globals;

class LabelsPage extends StatefulWidget {
  final String selectedLabels;
  const LabelsPage({super.key, required this.selectedLabels});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  List<String> selectedLabels = [];
  List<Label> labels = [];
  bool isLoading = false;

  Future<void> getLabels() async {
    setState(() {
      isLoading = true;
    });
    final response = await LabelsApiProvider.fecthLabels(json.encode({
      "user_id": globals.user.userId,
    }));
    if (response.error.isEmpty) {
      setState(() {
        labels = response.labels;
        for (var i = 0; i < labels.length; i++) {
          if (selectedLabels
              .where((l) => l == labels[i].labelName)
              .isNotEmpty) {
            labels[i].selected = true;
          }
        }
      });
    } else {
      if (mounted) showSnackBar(context, response.error);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedLabels = widget.selectedLabels.split(',');
    getLabels();
  }

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
                  onPressed: () => showAddDialog(),
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
              child: ListView.builder(
                itemCount: labels.length,
                itemBuilder: (context, index) => CheckboxListTile(
                  value: labels[index].selected,
                  onChanged: (value) {
                    setState(() {
                      labels[index].selected = value!;
                    });
                  },
                  title: Text(labels[index].labelName),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Padding(
              padding: kGlobalOuterPadding * 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    maxLength: 15,
                    decoration: InputDecoration(
                      hintText: 'enter_label_name'.tr(),
                      counterText: '',
                    ),
                  ),
                  kVSpace,
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          child: Text('add'.tr()),
                        ),
                      ),
                      kHSpace,
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'cancel'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
