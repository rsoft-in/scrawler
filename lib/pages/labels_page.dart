import 'dart:async';

import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/my_flutter_app_icons.dart';
import 'package:bnotes/models/labels_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LabelsPage extends StatefulWidget {
  final String noteid;
  final String notelabel;

  const LabelsPage({Key key, this.noteid, this.notelabel}) : super(key: key);
  @override
  _LabelsPageState createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbHelper = DatabaseHelper.instance;
  StreamController<List<Labels>> _labelsController;
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
      Navigator.pop(context, true);
    });
  }

  Future showTip() async {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Labels'),
        actions: [
          FlatButton(
            child: Text('DONE'),
            onPressed: () => _assignLabel(),
          ),
        ],
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
                      decoration: InputDecoration.collapsed(
                          hintText: 'Add a new Label'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(MyFlutterApp.add),
                    color: Theme.of(context).accentColor,
                    onPressed: () => _saveLabel(),
                  ),
                ],
              ),
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
                      return Text(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var label = snapshot.data[index];
                          return Dismissible(
                            background: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.red.shade300,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Icon(MyFlutterApp.delete),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.red.shade300,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: Icon(MyFlutterApp.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            key: Key(label.labelId),
                            onDismissed: (direction) {
                              setState(() {
                                _deleteLabel(label.labelId);
                                snapshot.data.removeAt(index);
                              });
                            },
                            child: CheckboxListTile(
                              value: _selectedLabels.contains(label.labelName),
                              title: Text(label.labelName),
                              onChanged: (value) {
                                _onLabelSelected(value, label.labelName);
                              },
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
    );
  }
}
