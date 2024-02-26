import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/mobile/material/note_material.dart';
import 'package:bnotes/models/label.dart';
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
  String selectedView = 'favorites';

  Future<List<Label>> fetchLabels() async {
    return await dbHelper.getLabelsAll();
  }

  Future<List<Notes>> fetchNotes() async {
    if (selectedView == 'favorites') {
      return await dbHelper.getNotesFavorite();
    } else {
      return await dbHelper.getNotesAll('', 'note_title');
    }
  }

  Future<List<Notes>> fetchNotesAll() async {
    return await dbHelper.getNotesAll('', 'note_date desc');
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<List<Notes>> favNotesBuilder = FutureBuilder<List<Notes>>(
      future: fetchNotes(),
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

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar.medium(
            title: const Text(kAppName),
            floating: false,
            actions: [
              IconButton(
                onPressed: () => openNote(Notes.empty()),
                icon: const Icon(Symbols.add),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.person),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      selectedView = 'favorites';
                    }),
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                          fontWeight: selectedView == 'favorites'
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      selectedView = 'all';
                    }),
                    child: Text(
                      'All',
                      style: TextStyle(
                          fontWeight: selectedView == 'all'
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: favNotesBuilder,
      ),
    );

    // return DefaultTabController(
    //   length: 2,
    //   initialIndex: 0,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text(
    //         kAppName,
    //         style: TextStyle(fontFamily: 'Inter'),
    //       ),
    //       actions: [
    //         IconButton(
    //           onPressed: () {},
    //           icon: const Icon(Symbols.search),
    //         ),
    //         IconButton(
    //           onPressed: () {},
    //           icon: const Icon(Symbols.person),
    //         ),
    //       ],
    //       bottom: const TabBar(tabs: [
    //         Tab(
    //           child: Text('Favorites'),
    //         ),
    //         Tab(
    //           child: Text('All Notes'),
    //         )
    //       ]),
    //     ),
    //     body: TabBarView(children: [
    //       favNotesBuilder,
    //       const Center(
    //         child: Text('All Notes'),
    //       )
    //     ]),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () => openNote(Notes.empty()),
    //       child: const Icon(Symbols.add),
    //     ),
    //   ),
    // );
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePageMaterial(note)));

    setState(() {});
  }
}
