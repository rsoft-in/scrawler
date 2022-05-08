import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/constants.dart';
import 'package:bnotes/desktop/helpers/localdatahandler.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Notes> notesList = [];
  TextEditingController _noteTitleController = TextEditingController();
  TextEditingController _noteTextController = TextEditingController();
  bool isNewNote = false;
  final _formKey = GlobalKey<FormState>();

  void loadNotes() async {
    LocalDataHandler.fetchNotes().then((value) {
      setState(() {
        notesList = value;
      });
    });
  }

  void addNote() {
    var uuid = Uuid();
    setState(() {
      notesList.add(new Notes(uuid.v1(), Utility.getDateString(),
          _noteTitleController.text, _noteTextController.text, '', 0, 0, ''));
    });
    saveNotes();
    Navigator.pop(context);
  }

  void updateNote(int index) {
    setState(() {
      notesList[index].noteTitle = _noteTitleController.text;
      notesList[index].noteText = _noteTextController.text;
    });
    saveNotes();
    Navigator.pop(context);
  }

  void deleteNote(int index) async {
    setState(() {
      notesList.removeAt(index);
    });
    saveNotes();
  }

  void saveNotes() async {
    LocalDataHandler.storeNotes(notesList).then((value) {
      if (value) {
        clearEditControllers();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kLabelUpdated),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void clearEditControllers() {
    isNewNote = true;
    _noteTitleController.clear();
    _noteTextController.clear();
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: notesList.length > 0
            ? ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  Notes note = notesList[index];
                  return ListTile(
                    title: Text(note.noteTitle),
                    subtitle: Text(
                      note.noteText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.delete_outlined),
                    //   onPressed: () => confirmDelete(index),
                    // ),
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => <PopupMenuItem>[
                        PopupMenuItem(
                          child: Text(kLabelEdit),
                          value: 'edit',
                          onTap: () => Future<void>.delayed(
                              const Duration(microseconds: 1000), () {
                            setState(() {
                              isNewNote = false;
                              _noteTitleController.text = note.noteTitle;
                              _noteTextController.text = note.noteText;
                            });
                            editNote(index);
                          }),
                        ),
                        PopupMenuItem(
                          child: Text(kLabelDelete),
                          value: 'delete',
                          onTap: () => Future<void>.delayed(
                              const Duration(microseconds: 1000), () {
                            confirmDelete(index);
                          }),
                        ),
                      ],
                      icon: Icon(Icons.more_vert_outlined),
                    ),
                    onTap: () {},
                  );
                })
            : Center(
                child: Text(kLabelNoNotes),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          isNewNote = true;
          editNote(null);
        },
      ),
    );
  }

  void editNote(int? index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: kGlobalOuterPadding,
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 500, maxWidth: 800),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (isNewNote)
                                    addNote();
                                  else {
                                    print(index);
                                    if (index != null) updateNote(index);
                                  }
                                }
                              },
                              icon: Icon(Icons.check_outlined),
                            ),
                            kHSpace,
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.clear),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _noteTitleController,
                          decoration: InputDecoration(
                            hintText: '$kLabelTitle*',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return kLabelMandatory;
                            }
                            return null;
                          },
                        ),
                        kVSpace,
                        Expanded(
                          child: TextFormField(
                            controller: _noteTextController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: kLabelTypeSomething,
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void confirmDelete(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(kLabelDelete),
            content: Text(kLabelConfirmDelete),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteNote(index);
                  },
                  child: Text(kLabelActionYes)),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(kLabelActionNo))
            ],
          );
        });
  }
}
