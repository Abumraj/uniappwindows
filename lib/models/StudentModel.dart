class Students {
  int? id;
  String? fullName;
  String? imageUrl;
  String? matricNo;
  String? department;
  int? level;
  int? isPublished;

  Students(
      {this.id,
      this.fullName,
      this.imageUrl,
      this.matricNo,
      this.department,
      this.level,
      this.isPublished});
  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      id: json['id'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      matricNo: json['matricNo'],
      department: json['department'],
      level: json['level'],
      isPublished: json['isPublished'],
    );
  }
}
