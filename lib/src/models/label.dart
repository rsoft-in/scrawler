class Label {
  String labelId;
  String labelName;
  bool selected;

  Label(this.labelId, this.labelName, this.selected);

  Label.fromJson(Map<String, dynamic> json)
      : labelId = json['label_id'],
        labelName = json['label_name'],
        selected = false;

  Map<String, dynamic> toJson() =>
      {'label_id': labelId, 'label_name': labelName};
}

class LabelsData {
  List<Label> labels;
  int records;
  String error;

  LabelsData(this.labels, this.records, this.error);
}
