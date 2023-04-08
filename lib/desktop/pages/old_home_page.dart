import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/common/utility.dart';
import 'package:bnotes/desktop/helpers/localdatahandler.dart';
import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Notes> notesList = [];
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
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
    var uuid = const Uuid();
    setState(() {
      notesList.add(Notes(uuid.v1(), Utility.getDateString(),
          _noteTitleController.text, _noteTextController.text, '', false, 0, ''));
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
          const SnackBar(
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
        child: notesList.isNotEmpty
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
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => <PopupMenuItem>[
                        PopupMenuItem(
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
                          child: const Text(kLabelEdit),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          onTap: () => Future<void>.delayed(
                              const Duration(microseconds: 1000), () {
                            confirmDelete(index);
                          }),
                          child: const Text(kLabelDelete),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert_outlined),
                      tooltip: kLabelOptions,
                    ),
                    onTap: () {},
                  );
                })
            : const Center(
                child: Text(kLabelNoNotes),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Iconsax.add),
        onPressed: () {
          clearEditControllers();
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
                    constraints: const BoxConstraints(maxHeight: 500, maxWidth: 800),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (isNewNote) {
                                    addNote();
                                  } else {
                                    print(index);
                                    if (index != null) updateNote(index);
                                  }
                                }
                              },
                              icon: const Icon(Icons.check_outlined),
                            ),
                            kHSpace,
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _noteTitleController,
                          decoration: const InputDecoration(
                            hintText: kLabelTitle,
                            // label: Text('Title'),
                            // isCollapsed: true,
                            fillColor: Colors.transparent,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
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
                            decoration: const InputDecoration(
                              hintText: 'Content',
                              fillColor: Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
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
            title: const Text(kLabelDelete),
            content: const Text(kLabelConfirmDelete),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteNote(index);
                  },
                  child: const Text(kLabelActionYes)),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(kLabelActionNo))
            ],
          );
        });
  }
}
