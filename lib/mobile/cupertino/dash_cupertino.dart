import 'package:bnotes/mobile/cupertino/note_cupertino.dart';
import 'package:flutter/cupertino.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../models/label.dart';
import '../../models/notes.dart';
import '../../widgets/scrawl_empty.dart';

class DashCupertino extends StatefulWidget {
  const DashCupertino({super.key});

  @override
  State<DashCupertino> createState() => _DashCupertinoState();
}

class _DashCupertinoState extends State<DashCupertino> {
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
                itemBuilder: (context, index) => CupertinoListTile(
                  title: Text(notes[index].noteTitle),
                  subtitle: Text(
                    notes[index].noteText,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    openNote(notes[index]);
                  },
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
              child: CupertinoActivityIndicator(),
            );
          default:
            return Container();
        }
      },
    );
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(kAppName),
          trailing: CupertinoButton(
              child: const Icon(CupertinoIcons.add, size: 18),
              onPressed: () => openNote(Notes.empty())),
        ),
        child: notesBuilder);
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => NotePageCupertino(note)));
    setState(() {});
  }
}
