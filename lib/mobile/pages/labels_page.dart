import 'dart:async';

import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/models/labels_model.dart';
import 'package:bnotes/widgets/small_appbar.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LabelsPage extends StatefulWidget {
  final String noteid;
  final String notelabel;

  const LabelsPage({Key? key, required this.noteid, required this.notelabel})
      : super(key: key);
  @override
  _LabelsPageState createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbHelper = DatabaseHelper.instance;
  late StreamController<List<Labels>> _labelsController;
  TextEditingController _newLabelController = new TextEditingController();
  var uuid = Uuid();
  List _selectedLabels = [];

  loadLabels() async {
    final allRows = await dbHelper.getLabelsAll();
    _labelsController.add(allRows);
  }

  void _saveLabel() async {
    if (_newLabelController.text.isNotEmpty) {
      await dbHelper
          .insertLabel(new Labels(uuid.v1(), _newLabelController.text))
          .then((value) {
        setState(() {
          _newLabelController.text = "";
        });
        loadLabels();
      });
    }
  }

  void _deleteLabel(String labelId) async {
    await dbHelper.deleteLabel(labelId).then((value) {
      loadLabels();
    });
  }

  void _assignLabel() async {
    await dbHelper
        .updateNoteLabel(widget.noteid, _selectedLabels.join(","))
        .then((value) {
      Navigator.pop(context, _selectedLabels.join(","));
    });
  }

  Future showTip() async {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Tap on the Label to Assign to a Note'),
      duration: Duration(seconds: 5),
    ));
  }

  void _onLabelSelected(bool selected, String labelName) {
    if (selected) {
      setState(() {
        _selectedLabels.add(labelName);
      });
    } else {
      setState(() {
        _selectedLabels.remove(labelName);
      });
    }
  }

  @override
  void initState() {
    _labelsController = new StreamController<List<Labels>>();
    loadLabels();
    super.initState();
    if (widget.notelabel.isNotEmpty) {
      _selectedLabels = widget.notelabel.split(",");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   title: Text('Labels'),
        //   actions: [
        //     Visibility(
        //       visible: widget.noteid.isNotEmpty,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: OutlinedButton(
        //           child: Text('Done'),
        //           onPressed: () => _assignLabel(),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SAppBar(
            title: 'Labels',
            action: [
              Visibility(
                visible: widget.noteid.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    child: Text('Done'),
                    onPressed: () => _assignLabel(),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newLabelController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(hintText: 'Add Label'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      // color: kPrimaryColor,
                      onPressed: () => _saveLabel(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<List<Labels>>(
                    stream: _labelsController.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Labels>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var label = snapshot.data![index];
                            return Dismissible(
                              background: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 15.0),
                                        decoration: BoxDecoration(
                                          color: FlexColor.redDarkPrimary,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                        ),
                                        child:
                                            Icon(Icons.delete_outline_rounded),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 15.0),
                                        decoration: BoxDecoration(
                                          color: FlexColor.redDarkPrimary,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                        ),
                                        child:
                                            Icon(Icons.delete_outline_rounded),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              key: Key(label.labelId),
                              onDismissed: (direction) {
                                setState(() {
                                  _deleteLabel(label.labelId);
                                  snapshot.data!.removeAt(index);
                                });
                              },
                              child: widget.noteid.isNotEmpty
                                  ? CheckboxListTile(
                                      value: _selectedLabels
                                          .contains(label.labelName),
                                      title: Text(label.labelName),
                                      onChanged: (value) {
                                        _onLabelSelected(
                                            value!, label.labelName);
                                      },
                                    )
                                  : ListTile(
                                      title: Text(label.labelName),
                                    ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text('No notes yet!'),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, null);
    return true;
  }
}
