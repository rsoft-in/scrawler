class NoteListItem {
  String value;
  String checked;

  NoteListItem(this.value, this.checked);

  NoteListItem.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        checked = json['checked'];
}
