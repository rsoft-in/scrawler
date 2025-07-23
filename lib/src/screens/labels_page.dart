import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:uuid/uuid.dart';

import '../helpers/constants.dart';
import '../helpers/globals.dart' as globals;
import '../models/label.dart';
import '../providers/labels_api_provider.dart';
import '../widgets/scrawl_snackbar.dart';

class LabelsPage extends StatefulWidget {
  final String selectedLabels;
  final bool? assignMode;
  const LabelsPage(
      {super.key, required this.selectedLabels, this.assignMode = false});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  List<String> selectedLabels = [];
  List<Label> labels = [];
  bool isLoading = false;
  TextEditingController labelNameController = TextEditingController();

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

  Future<void> saveLabel() async {
    final uuid = Uuid().v1();
    final response = await LabelsApiProvider.updateLabels(json.encode(
      {
        'is_new': true,
        'id': uuid,
        'user_id': globals.user.userId,
        'name': labelNameController.text
      },
    ));
    if (response['status']) {
      if (mounted) Navigator.pop(context);
      getLabels();
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  void generateLabelString() {
    selectedLabels.clear();
    for (var label in labels) {
      if (label.selected) {
        selectedLabels.add(label.labelName);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedLabels = widget.selectedLabels.split(',');
    getLabels();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          generateLabelString();
          Navigator.pop(context, selectedLabels.join(','));
        }
      },
      child: FScaffold(
        header: FHeader.nested(
          title: Text('labels'.tr()),
          prefixes: [
            FHeaderAction.back(
              onPress: () async {
                generateLabelString();
                Navigator.pop(context, selectedLabels.join(','));
              },
            ),
          ],
          suffixes: [
            FHeaderAction(
              onPress: () => showAddDialog(),
              icon: Icon(FIcons.plus),
            ),
          ],
        ),
        child: Padding(
          padding: kPaddingLarge,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.assignMode ?? false)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('select_labels'.tr()),
                      ),
                    ...List.generate(
                      labels.length,
                      (index) => (widget.assignMode ?? false)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: FCheckbox(
                                value: labels[index].selected,
                                label: Text(labels[index].labelName),
                                onChange: (value) {
                                  setState(() {
                                    labels[index].selected = value;
                                  });
                                },
                              ),
                            )
                          : FItem(
                              title: Text(labels[index].labelName),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // floatingActionButton: isSmallDevice
        //     ? FloatingActionButton(
        //         onPressed: () => showAddDialog(),
        //         child: Icon(Symbols.add),
        //       )
        //     : null,
      ),
    );
  }

  void showAddDialog() {
    labelNameController.clear();
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
                    controller: labelNameController,
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
                          onPressed: () => saveLabel(),
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
