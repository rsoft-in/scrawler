import 'package:bnotes/mobile/material/note_material.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../helpers/dbhelper.dart';
import '../../models/notes.dart';
import '../../widgets/scrawl_color_dot.dart';
import '../../widgets/scrawl_empty.dart';

class FolderPageMaterial extends StatefulWidget {
  final String folderName;
  const FolderPageMaterial({super.key, required this.folderName});

  @override
  State<FolderPageMaterial> createState() => _FolderPageMaterialState();
}

class _FolderPageMaterialState extends State<FolderPageMaterial> {
  DBHelper dbHelper = DBHelper.instance;

  Future<List<Notes>> fetchNotesByFolder() async {
    return await dbHelper.getNotesByFolder(widget.folderName, 'note_title');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
      ),
      body: FutureBuilder<List<Notes>>(
        future: fetchNotesByFolder(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: EmptyWidget(
                      text: 'Start writing something today...',
                      width: MediaQuery.of(context).size.width * 0.5,
                      asset: 'images/nothing_to_do.svg'),
                );
              } else {
                List<Notes> notes = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Symbols.note),
                    title: Text(notes[index].noteTitle),
                    subtitle: Text(
                      notes[index].noteText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    trailing: ScrawlColorDot(colorCode: notes[index].noteColor),
                    onTap: () => openNote(notes[index]),
                  ),
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
    );
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePageMaterial(note)));

    setState(() {});
  }
}
