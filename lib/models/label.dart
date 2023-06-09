class Label {
  String labelId;
  String labelName;

  Label(this.labelId, this.labelName);

  Label.fromJson(Map<String, dynamic> json)
      : labelId = json['label_id'],
        labelName = json['label_name'];

  Map<String, dynamic> toJson() =>
      {'label_id': labelId, 'label_name': labelName};
}

class LabelsData {
  List<Label> labels;
  int records;
  String error;

  LabelsData(this.labels,this.records, this.error);
}
