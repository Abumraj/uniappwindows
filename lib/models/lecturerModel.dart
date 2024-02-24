class Lecturer {
  String? title;
  String? fullName;
  String? imageUrl;
  String? email;
  String? matricNo;
  int? phoneNo;
  String? department;
  String? sex;

  Lecturer(
      {this.department,
      this.fullName,
      this.email,
      this.matricNo,
      this.imageUrl,
      this.phoneNo,
      this.sex,
      this.title});

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      matricNo: json['matricNo'],
      department: json['department'],
      sex: json['sex'],
      phoneNo: json['phoneNo'],
      title: json['title'],
      email: json['email'],
    );
  }
}
