class CourseLecturer {
  int? id;
  String? fullName;
  String? imageUrl;
  String? title;
  String? role;

  CourseLecturer(
      {this.id, this.fullName, this.imageUrl, this.title, this.role});
  factory CourseLecturer.fromJson(Map<String, dynamic> json) {
    return CourseLecturer(
      id: json['id'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      role: json['role'],
    );
  }
}
