class Notes {
  final String noteId;
  final String noteDate;
  final String noteTitle;
  final String noteText;
  final String noteLabel;
  final int noteArchived;
  final int noteColor;

  Notes(this.noteId, this.noteDate, this.noteTitle, this.noteText,
      this.noteLabel, this.noteArchived, this.noteColor);

  Notes.fromJson(Map<String, dynamic> json)
      : noteId = json['note_id'],
        noteDate = json['note_date'],
        noteTitle = json['note_title'],
        noteText = json['note_text'],
        noteLabel = json['note_label'],
        noteArchived = json['note_archived'],
        noteColor = json['note_color'];

  Map<String, dynamic> toJson() => {
        'note_id': noteId,
        'note_date': noteDate,
        'note_title': noteTitle,
        'note_text': noteText,
        'note_label': noteLabel,
        'note_archived': noteArchived,
        'note_color': noteColor
      };
}
