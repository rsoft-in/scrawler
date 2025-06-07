class Notes {
  String noteId;
  String noteDate;
  String noteTitle;
  String noteText;
  String noteLabel;
  bool noteArchived;
  int noteColor;
  String noteImage;
  bool noteFavorite;

  Notes(
      this.noteId,
      this.noteDate,
      this.noteTitle,
      this.noteText,
      this.noteLabel,
      this.noteArchived,
      this.noteColor,
      this.noteImage,
      this.noteFavorite);

  Notes.empty() : this('', '', 'Untitled', '', '', false, 0, '', false);

  Notes.fromJson(Map<String, dynamic> json)
      : noteId = json['note_id'],
        noteDate = json['note_date'],
        noteTitle = json['note_title'],
        noteText = json['note_text'],
        noteLabel = json['note_label'],
        noteArchived = json['note_archived'] == 1,
        noteColor = int.parse('${json['note_color']}'),
        noteImage = json['note_image'] ?? '',
        noteFavorite = (json['note_favorite'] ?? 0) == 1;

  Map<String, dynamic> toJson() => {
        'note_id': noteId,
        'note_date': noteDate,
        'note_title': noteTitle,
        'note_text': noteText,
        'note_label': noteLabel,
        'note_archived': noteArchived ? 1 : 0,
        'note_color': noteColor,
        'note_image': noteImage,
        'note_favorite': noteFavorite ? 1 : 0
      };
}

class NotesResult {
  List<Notes> notes;
  int rows;
  String error;

  NotesResult(this.notes, this.rows, this.error);
}
