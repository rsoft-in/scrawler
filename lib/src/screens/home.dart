import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/model/note.dart';
import 'package:scrawler/src/providers/notes_provider.dart';
import 'package:scrawler/src/screens/note_edit.dart';
import 'package:scrawler/src/widgets/rs_badge.dart';
import 'package:scrawler/src/widgets/rs_empty_placeholder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kAppName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Symbols.settings))],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          if (provider.notes.isEmpty) {
            return const Center(
              child: EmptyWidget(text: 'No Notes yet!', width: 250),
            );
          }

          return CustomScrollView(
            slivers: [
              // --- Horizontal Recent Notes ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "recently_updated".tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: provider.recentNotes.length,
                    itemBuilder: (context, index) {
                      final note = provider.recentNotes[index];
                      return GestureDetector(
                        onTap: () => _openEditor(context, note),
                        child: RecentNoteCard(note: note),
                      );
                    },
                  ),
                ),
              ),

              // --- Vertical All Notes ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    "all_notes".tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final note = provider.notes[index];
                  return NoteListTile(
                    note: note,
                    onTap: () => _openEditor(context, note),
                    onLongPress: () => _showNoteOptions(context, note),
                  );
                }, childCount: provider.notes.length),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, null), // Pass null for new note
        child: const Icon(Symbols.add),
      ),
    );
  }

  void _openEditor(BuildContext context, Note? note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditorPage(note: note)),
    );
  }

  void _showNoteOptions(BuildContext context, Note note) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            ListTile(
              leading: Icon(Symbols.delete, color: Colors.redAccent),
              title: Text(
                'delete'.tr(),
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, note);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Note note) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('yes'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('no'.tr()),
          ),
        ],
        title: Text('confirm'.tr()),
        content: Text('delete_text'.tr()),
      ),
    );
    if (result) {
      if (context.mounted) {
        context.read<NoteProvider>().deleteNote(note.id ?? 0);
      }
    }
  }
}

class RecentNoteCard extends StatelessWidget {
  final Note note;
  const RecentNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.imagePath != null)
              Image.file(
                File(note.imagePath!),
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 80,
                width: double.infinity,
                color: kPrimaryColor.withAlpha(50),
                child: const Icon(Symbols.notes, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  RSBadge(text: note.tags.join(', ')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteListTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteListTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      title: Text(
        note.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Text(
            DateFormat('MMM dd, yyyy').format(note.modifiedAt),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(width: 4),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: note.tags
                    .map(
                      (t) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: RSBadge(text: t),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(Symbols.chevron_right),
    );
  }
}
