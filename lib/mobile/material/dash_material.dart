import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/mobile/material/note_material.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_color_dot.dart';
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

  Future<List<Notes>> fetchNotesFav() async {
    return await dbHelper.getNotesFavorite();
  }

  Future<List<Notes>> fetchNotesAll() async {
    return await dbHelper.getNotesAll('', 'note_title');
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<List<Notes>> favNotesBuilder = FutureBuilder<List<Notes>>(
      future: fetchNotesFav(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data!.isNotEmpty) {
              List<Notes> notes = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                      '${notes[index].noteTitle} ${notes[index].noteFavorite}'),
                  subtitle: Text(
                    notes[index].noteText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: ScrawlColorDot(colorCode: notes[index].noteColor),
                  onTap: () => openNote(notes[index]),
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

    FutureBuilder<List<Notes>> allNotesBuilder = FutureBuilder<List<Notes>>(
      future: fetchNotesAll(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data!.isNotEmpty) {
              List<Notes> notes = snapshot.data!;
              notes.sort((a, b) => a.noteLabel.compareTo(b.noteLabel));
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Symbols.note),
                  title: Text(
                      '${notes[index].noteTitle} ${notes[index].noteFavorite}'),
                  subtitle: Text(
                    notes[index].noteText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: ScrawlColorDot(colorCode: notes[index].noteColor),
                  onTap: () => openNote(notes[index]),
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

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
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
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text('Favorites'),
              ),
              Tab(
                child: Text('All Notes'),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          favNotesBuilder,
          allNotesBuilder,
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => openNote(Notes.empty()),
          child: const Icon(Symbols.add),
        ),
      ),
    );
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePageMaterial(note)));

    setState(() {});
  }
}