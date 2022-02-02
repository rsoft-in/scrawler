class Notes {
  String noteId;
  String noteDate;
  String noteTitle;
  String noteText;
  String noteLabel;
  int noteArchived;
  int noteColor;
  String noteList;

  Notes(this.noteId, this.noteDate, this.noteTitle, this.noteText,
      this.noteLabel, this.noteArchived, this.noteColor, this.noteList);

  Notes.fromJson(Map<String, dynamic> json)
      : noteId = json['note_id'],
        noteDate = json['note_date'],
        noteTitle = json['note_title'],
        noteText = json['note_text'],
        noteLabel = json['note_label'],
        noteArchived = json['note_archived'],
        noteColor = json['note_color'],
        noteList = json['note_list'] ?? '';

  Map<String, dynamic> toJson() => {
        'note_id': noteId,
        'note_date': noteDate,
        'note_title': noteTitle,
        'note_text': noteText,
        'note_label': noteLabel,
        'note_archived': noteArchived,
        'note_color': noteColor,
        'note_list': noteList
      };
}
