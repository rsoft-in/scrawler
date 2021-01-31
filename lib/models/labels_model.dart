class Labels {
  final String labelId;
  final String labelName;

  Labels(this.labelId, this.labelName);

  Labels.fromJson(Map<String, dynamic> json)
      : labelId = json['label_id'],
        labelName = json['label_name'];

  Map<String, dynamic> toJson() => {
    'label_id': labelId,
    'label_name': labelName
  };
}