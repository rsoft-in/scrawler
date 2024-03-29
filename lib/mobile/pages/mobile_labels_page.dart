import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../models/label.dart';

class MobileLabelsPage extends StatefulWidget {
  final String preselect;
  const MobileLabelsPage({super.key, required this.preselect});

  @override
  State<MobileLabelsPage> createState() => _MobileLabelsPageState();
}

class _MobileLabelsPageState extends State<MobileLabelsPage> {
  final dbHelper = DBHelper.instance;
  List<Label> labelsList = [];

  TextEditingController newLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllLabels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: const Icon(Icons.arrow_back)),
        title: const Text('Select or Manage Labels'),
      ),
      body: Padding(
        padding: kGlobalOuterPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              controller: newLabelController,
              decoration: const InputDecoration(
                hintText: 'Enter New Label...',
              ),
              onSubmitted: (value) => setState(() => saveLabel(value)),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: labelsList.length,
                itemBuilder: (context, index) => CheckboxListTile(
                  key: Key('$index'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  value: labelsList[index].selected,
                  onChanged: (value) {
                    setState(() {
                      labelsList[index].selected = !labelsList[index].selected;
                    });
                  },
                  title: Text(labelsList[index].labelName),
                ),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final Label item = labelsList.removeAt(oldIndex);
                    labelsList.insert(newIndex, item);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              child: const Text('Ok'),
              onPressed: () {
                var selectedLabels = [];
                for (var element in labelsList) {
                  if (element.selected) {
                    selectedLabels.add(element.labelName);
                  }
                }
                Navigator.pop(context, selectedLabels.join(','));
              },
            ),
            kHSpace,
            OutlinedButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, null)),
          ],
        ),
      ),
    );
  }

  void getAllLabels() async {
    labelsList = await dbHelper.getLabelsAll();
    setState(() {
      for (var i = 0; i < labelsList.length; i++) {
        if (widget.preselect.contains(labelsList[i].labelName)) {
          labelsList[i].selected = true;
        }
      }
    });
  }

  void saveLabel(String labelName) async {
    var uuid = const Uuid();
    var newId = uuid.v1();
    Label newLabel = Label(newId, labelName, true);
    final result = await dbHelper.insertLabel(newLabel);
    if (result) {
      setState(() {
        labelsList.add(newLabel);
        newLabelController.text = "";
      });
    }
  }
}
