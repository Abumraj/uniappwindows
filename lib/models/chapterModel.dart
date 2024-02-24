class Chapter {
  int? chapterId;
  int? chapterOrderId;
  int? courseId;
  String? chapterDescrip;
  String? userId;
  String? chapterName;
  int? quesNum;
  int? quesTime;
  int? isPublished;

  Chapter(
      {this.chapterId,
      this.courseId,
      this.chapterName,
      this.chapterOrderId,
      this.chapterDescrip,
      this.quesNum,
      this.userId,
      this.quesTime,
      this.isPublished});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
        chapterId: json['chapterId'],
        chapterOrderId: json['chapterOrderId'],
        courseId: json['courseId'],
        chapterDescrip: json['chapterDescrip'],
        chapterName: json['chapterName'],
        userId: json['userId'],
        quesNum: int.parse(json['quesNum']),
        quesTime: int.parse(json['quesTime']),
        isPublished: int.parse(json['isPublished']));
  }
}
