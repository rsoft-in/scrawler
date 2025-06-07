enum NoteSort { title, titleDesc, newest, oldest }

class SortItem {
  NoteSort sortBy;
  String caption;

  SortItem(this.sortBy, this.caption);
}
