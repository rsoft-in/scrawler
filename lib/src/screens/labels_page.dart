import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:uuid/uuid.dart';

import '../helpers/constants.dart';
import '../helpers/globals.dart' as globals;
import '../models/label.dart';
import '../providers/labels_api_provider.dart';
import '../widgets/rs_toast.dart';

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
      if (mounted) RSToast.show(context, message: response.error);
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
      if (mounted) RSToast.show(context, message: response['error']);
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
        header: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FHeader.nested(
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
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
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
    );
  }

  void showAddDialog() {
    labelNameController.clear();
    showFDialog(
      context: context,
      builder: (context, style, animation) {
        return FDialog.raw(
          builder: (p0, p1) {
            return Padding(
              padding: kGlobalOuterPadding * 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  FTextField(
                    controller: labelNameController,
                    maxLength: 15,
                    hint: 'enter_label_name'.tr(),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: FButton(
                          onPress: () => saveLabel(),
                          child: Text('add'.tr()),
                        ),
                      ),
                      Expanded(
                        child: FButton(
                          style: FButtonStyle.outline(),
                          onPress: () => Navigator.pop(context),
                          child: Text(
                            'cancel'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
