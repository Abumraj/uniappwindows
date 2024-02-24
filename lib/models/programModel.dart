class School {
  int? id;
  String? schoolName;
  String? schoolUrl;
  String? schoolChannel;

  School({this.id, this.schoolName, this.schoolChannel, this.schoolUrl});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      schoolName: json['schoolName'],
      schoolUrl: json['schoolUrl'],
      schoolChannel: json['schoolImageUrl'],
    );
  }
}
