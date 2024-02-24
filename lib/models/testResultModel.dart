class TestResult {
  int? id;
  String? fullName;
  String? imageUrl;
  String? matricNo;
  int? score;

  TestResult(
      {this.id, this.fullName, this.imageUrl, this.matricNo, this.score});
  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      matricNo: json['matricNo'],
      score: json['score'],
    );
  }
}
