import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/dbhelper.dart';
import '../../models/label.dart';

class LabelSelectMaterial extends StatefulWidget {
  final bool standalone;
  const LabelSelectMaterial({super.key, this.standalone = false});

  @override
  State<LabelSelectMaterial> createState() => _LabelSelectMaterialState();
}

class _LabelSelectMaterialState extends State<LabelSelectMaterial> {
  DBHelper dbHelper = DBHelper.instance;
  TextEditingController newLabelController = TextEditingController();

  Future<List<Label>> fetchLabels() async {
    return await dbHelper.getLabelsAll();
  }

  Future<void> saveLabel() async {
    var uid = const Uuid();
    await dbHelper.insertLabel(Label(uid.v1(), newLabelController.text, false));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.standalone ? 'Folders' : 'Select Folder'),
      ),
      body: FutureBuilder<List<Label>>(
        future: fetchLabels(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data!.isNotEmpty) {
                List<Label> labels = snapshot.data!;
                return ListView.builder(
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Symbols.folder),
                      title: Text(labels[index].labelName),
                      onTap: widget.standalone
                          ? null
                          : () =>
                              Navigator.pop(context, labels[index].labelName),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No Folders created yet!'),
                );
              }
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => labelDialog(),
        child: const Icon(Symbols.add),
      ),
    );
  }

  void labelDialog() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Padding(
                padding: kGlobalOuterPadding * 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Label',
                      style: TextStyle(fontSize: 18),
                    ),
                    kVSpace,
                    TextField(
                      keyboardType: TextInputType.name,
                      controller: newLabelController,
                      decoration:
                          const InputDecoration(hintText: 'Enter Label Name'),
                    ),
                    kVSpace,
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              saveLabel();
                              Navigator.pop(context);
                            },
                            child: const Text('Ok'),
                          ),
                        ),
                        kHSpace,
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}
