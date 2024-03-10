import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../helpers/dbhelper.dart';
import '../../models/notes.dart';
import 'note_material.dart';

class SearchPageMaterial extends StatefulWidget {
  const SearchPageMaterial({super.key});

  @override
  State<SearchPageMaterial> createState() => _SearchPageMaterialState();
}

class _SearchPageMaterialState extends State<SearchPageMaterial> {
  DBHelper dbHelper = DBHelper.instance;
  TextEditingController searchController = TextEditingController();

  Future<List<Notes>> searchResults() async {
    if (searchController.text.isNotEmpty) {
      return await dbHelper.getNotesAll(searchController.text, 'note_title');
    } else {
      List<Notes> notes = [];
      return notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: kGlobalOuterPadding,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                prefixIcon: const Icon(Symbols.search),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(kBorderRadius)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(kBorderRadius)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(kBorderRadius)),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            kVSpace,
            Expanded(
              child: FutureBuilder<List<Notes>>(
                future: searchResults(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No results found!'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(snapshot.data![index].noteTitle),
                            subtitle: Text(snapshot.data![index].noteLabel),
                            onTap: () => openNote(snapshot.data![index]),
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
            )
          ],
        ),
      ),
    );
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePageMaterial(note, null)));

    setState(() {});
  }
}
