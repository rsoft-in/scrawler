import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/mobile/material/note_material.dart';
import 'package:bnotes/models/label.dart';
import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../widgets/scrawl_empty.dart';

class DashMaterial extends StatefulWidget {
  const DashMaterial({Key? key}) : super(key: key);

  @override
  State<DashMaterial> createState() => _DashMaterialState();
}

class _DashMaterialState extends State<DashMaterial> {
  DBHelper dbHelper = DBHelper.instance;

  Future<List<Label>> fetchLabels() async {
    return await dbHelper.getLabelsAll();
  }

  Future<List<Notes>> fetchNotes() async {
    return await dbHelper.getNotesAll('', 'note_title');
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<List<Notes>> notesBuilder = FutureBuilder<List<Notes>>(
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
              return Center(
                child: EmptyWidget(
                    text: 'Start writing something today...',
                    width: MediaQuery.of(context).size.width * 0.5,
                    asset: 'images/nothing_to_do.svg'),
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
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            kAppName,
            style: TextStyle(fontFamily: 'Inter'),
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
        body: notesBuilder,
        floatingActionButton: FloatingActionButton(
          onPressed: () => openNote(Notes.empty()),
          child: const Icon(Symbols.add),
        ),
      );
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePageMaterial(note)));

    setState(() {});
  }
}
