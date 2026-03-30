import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/src/model/note.dart';
import 'package:scrawler/src/providers/notes_provider.dart';
import 'package:scrawler/src/widgets/markdown_toolbar.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note; // If null, we are creating a new note
  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  bool isEditing = false;
  Note? _currentNote;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  // final _tagController = TextEditingController();
  String? _selectedImagePath;
  List<String> _selectedTags = [];

  UndoHistoryController undoHistoryController = UndoHistoryController();

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    if (widget.note != null) {
      isEditing = false;
      _titleController.text = _currentNote!.title;
      _contentController.text = _currentNote!.content;
      // _tagController.text = _currentNote!.tags.join(', ');
      _selectedImagePath = _currentNote!.imagePath;
      _selectedTags = widget.note?.tags ?? [];
    } else {
      // New Note: Force Edit Mode immediately
      isEditing = true;
      _titleController.text = "untitled".tr();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImagePath = image.path);
    }
  }

  void _saveNote() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      return;
    }

    final newNote = Note(
      id: _currentNote?.id,
      title: _titleController.text.isEmpty ? "Untitled" : _titleController.text,
      content: _contentController.text,
      tags: _selectedTags,
      imagePath: _selectedImagePath,
      modifiedAt: DateTime.now(),
    );
    //tags: _tagController.text.split(',').map((e) => e.trim()).toList(),

    final provider = Provider.of<NoteProvider>(context, listen: false);
    if (_currentNote == null) {
      provider.addNote(newNote);
    } else {
      provider.updateNote(newNote);
    }
    setState(() {
      _currentNote = newNote;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent the default back behavior initially
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (isEditing) {
          _saveNote();
        }

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            isEditing
                ? _currentNote == null
                      ? "new_note".tr()
                      : "edit_note".tr()
                : _currentNote?.title ?? '',
          ),
          actions: [
            if (isEditing)
              IconButton(icon: const Icon(Symbols.check), onPressed: _saveNote),
            if (isEditing)
              IconButton(
                icon: const Icon(Symbols.close),
                onPressed: () => setState(() => isEditing = false),
              ),
            if (!isEditing)
              IconButton(
                onPressed: () => setState(() => isEditing = !isEditing),
                icon: Icon(Symbols.edit),
              ),
          ],
        ),
        body: isEditing
            ? Column(
                mainAxisSize: .max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Icon(Symbols.label, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children: [
                              ..._selectedTags.map(
                                (tag) => Chip(
                                  label: Text(
                                    tag,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  onDeleted: isEditing
                                      ? () {
                                          setState(
                                            () => _selectedTags.remove(tag),
                                          );
                                        }
                                      : null,
                                ),
                              ),
                              if (isEditing)
                                ActionChip(
                                  label: const Icon(Symbols.add, size: 16),
                                  onPressed: _showTagSelector,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: "Title",
                              border: InputBorder.none,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // TextField(
                          //   controller: _tagController,
                          //   decoration: const InputDecoration(
                          //     hintText: "Tags (comma separated)",
                          //     border: InputBorder.none,
                          //   ),
                          // ),
                          if (_selectedImagePath != null)
                            Stack(
                              children: [
                                Image.file(
                                  File(_selectedImagePath!),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: const CircleAvatar(
                                      child: Icon(Symbols.close, size: 16),
                                    ),
                                    onPressed: () => setState(
                                      () => _selectedImagePath = null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          TextButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Symbols.image),
                            label: Text("add_image".tr()),
                          ),
                          TextField(
                            controller: _contentController,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: "start_typing".tr(),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: MarkdownToolbar(
                        controller: _contentController,
                        undoController: undoHistoryController,
                        onChange: () {},
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Symbols.label, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Wrap(
                                  spacing: 8,
                                  children: [
                                    ..._selectedTags.map(
                                      (tag) => Chip(
                                        label: Text(
                                          tag,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        onDeleted: isEditing
                                            ? () {
                                                setState(
                                                  () =>
                                                      _selectedTags.remove(tag),
                                                );
                                              }
                                            : null,
                                      ),
                                    ),
                                    if (isEditing)
                                      ActionChip(
                                        label: const Icon(
                                          Symbols.add,
                                          size: 16,
                                        ),
                                        onPressed: _showTagSelector,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_currentNote!.imagePath != null)
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image.file(
                                File(_currentNote!.imagePath!),
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (_currentNote!.imagePath != null)
                            SizedBox(height: 10),
                          Expanded(
                            child: Markdown(
                              padding: EdgeInsets.zero,
                              data: _currentNote!.content,
                              selectable: true,
                              softLineBreak: true,
                              onTapLink: (text, href, title) =>
                                  _urlLauncher(href!),
                              styleSheet: MarkdownStyleSheet(
                                h1: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                h2: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                h3: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                checkbox: TextStyle(fontSize: 18),
                                horizontalRuleDecoration: BoxDecoration(
                                  border: Border.all(width: 0.1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _showTagSelector() async {
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final allTagsFromDB = provider.allDistinctTags;

    // Track selections locally in the dialog
    List<String> tempSelectedTags = List.from(_selectedTags);
    final TextEditingController newTagController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Combine DB tags with any newly typed tags not yet in the DB
            List<String> displayTags = {
              ...allTagsFromDB,
              ...tempSelectedTags,
            }.toList()..sort();

            return AlertDialog(
              title: Text("tags".tr()),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Quick Add TextField ---
                    TextField(
                      controller: newTagController,
                      decoration: InputDecoration(
                        hintText: "add_new_tag".tr(),
                        suffixIcon: IconButton(
                          icon: const Icon(Symbols.add_circle),
                          onPressed: () {
                            final newTag = newTagController.text.trim();
                            if (newTag.isNotEmpty &&
                                !tempSelectedTags.contains(newTag)) {
                              setDialogState(() {
                                tempSelectedTags.add(newTag);
                                newTagController.clear();
                              });
                            }
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        final newTag = value.trim();
                        if (newTag.isNotEmpty &&
                            !tempSelectedTags.contains(newTag)) {
                          setDialogState(() {
                            tempSelectedTags.add(newTag);
                            newTagController.clear();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Scrollable list of existing/new tags ---
                    Flexible(
                      child: displayTags.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "no_tags_yet".tr(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView(
                              shrinkWrap: true,
                              children: displayTags.map((tag) {
                                return CheckboxListTile(
                                  title: Text(tag),
                                  value: tempSelectedTags.contains(tag),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (bool? checked) {
                                    setDialogState(() {
                                      if (checked == true) {
                                        tempSelectedTags.add(tag);
                                      } else {
                                        tempSelectedTags.remove(tag);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("cancel".tr()),
                ),
                FilledButton(
                  // Using FilledButton for a primary "Confirm" action
                  onPressed: () {
                    setState(() => _selectedTags = tempSelectedTags);
                    Navigator.pop(context);
                  },
                  child: Text("confirm".tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _urlLauncher(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('${"could_not_launch".tr()} $url');
    }
  }
}
