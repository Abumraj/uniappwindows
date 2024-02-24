class Courses {
  int? courseId;
  String? courseName;
  String? coursecode;
  int? semester;
  String? status;
  int? unit;
  String? level;
  String? type;
  String? role;
  String? courseChatLink;

  Courses(
      {this.courseId,
      this.courseName,
      this.coursecode,
      this.semester,
      this.status,
      this.unit,
      this.type,
      this.level,
      this.role,
      this.courseChatLink});

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      courseId: json['courseId'],
      courseName: json['courseName'],
      coursecode: json['coursecode'],
      semester: json['semester'],
      unit: json['unit'],
      level: json['level'],
      type: json['type'],
      role: json['role'],
      status: json['status'],
      courseChatLink: json['courseChatLink'],
    );
  }
}
