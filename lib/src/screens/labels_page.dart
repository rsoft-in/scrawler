import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/label.dart';
import 'package:scrawler/src/providers/labels_api_provider.dart';
import 'package:scrawler/src/widgets/scrawl_empty.dart';

import '../helpers/globals.dart' as globals;

class LabelsPage extends StatefulWidget {
  const LabelsPage({super.key});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  Future<LabelsResult> getLabels() async {
    final response = await LabelsApiProvider.fecthLabels(json.encode({
      "user_id": globals.user.userId,
    }));
    return response;
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
              child: FutureBuilder<LabelsResult>(
                future: getLabels(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      if (snapshot.data!.error.isNotEmpty) {
                        return Center(
                          child: Text('problem_loading_data'),
                        );
                      } else {
                        if (snapshot.data!.labels.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                EmptyWidget(
                                  text: 'no_labels',
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                ),
                                kVSpace,
                                FilledButton.tonal(
                                  onPressed: () {},
                                  child: Text(
                                    'add'.tr(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.labels.length,
                          itemBuilder: (context, index) => CheckboxListTile(
                            value: false,
                            onChanged: (value) {},
                            title: Text(snapshot.data!.labels[index].labelName),
                          ),
                        );
                      }
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
