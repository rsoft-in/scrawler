import 'package:bnotes/desktop/helpers/datahandler.dart';
import 'package:bnotes/helpers/utility.dart';
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

  void loadNotes() async {
    DataHandler.fetchNotes().then((value) {
      setState(() {
        notesList = value;
      });
    });
  }

  void saveNotes() async {
    var uuid = Uuid();

    setState(() {
      notesList.add(new Notes(
          uuid.v1(), Utility.getDateString(), 'Demo', 'Hello', '', 0, 1, ''));
    });

    DataHandler.storeNotes(notesList).then((value) {
      if (value)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated!'),
            duration: Duration(seconds: 2),
          ),
        );
    });
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
                  );
                })
            : Center(
                child: Text('No Notes'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          saveNotes();
        },
      ),
    );
  }
}
