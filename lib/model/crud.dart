class Note {
  String title;
  String? desc;
  int? id;

  Note({
    this.id,
    required this.title,
    required this.desc,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> note = <String, dynamic>{};
    note['title'] = title;
    note['desc'] = desc;
    return note;
  }
}
