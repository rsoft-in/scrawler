import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/mobile/mobile_note.dart';
import 'package:bnotes/models/label.dart';
import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MobileLanding extends StatefulWidget {
  const MobileLanding({Key? key}) : super(key: key);

  @override
  State<MobileLanding> createState() => _MobileLandingState();
}

class _MobileLandingState extends State<MobileLanding> {
  DBHelper dbHelper = DBHelper.instance;

  Future<List<Label>> fetchLabels() async {
    return await dbHelper.getLabelsAll();
  }

  Future<List<Notes>> fetchNotes() async {
    return await dbHelper.getNotesAll('', 'note_title');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kAppName,
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.person),
          ),
        ],
      ),
      body: FutureBuilder<List<Notes>>(
        future: fetchNotes(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data!.isNotEmpty) {
                List<Notes> notes = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(notes[index].noteTitle),
                  ),
                );
              } else {
                return const Center(
                  child: Text('Start writing something...!'),
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
        onPressed: () => openNote(Notes.empty()),
        child: const Icon(Symbols.add),
      ),
    );
  }

  void openNote(Notes note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileNotePage(note)),
    );
    setState(() {});
  }
}
