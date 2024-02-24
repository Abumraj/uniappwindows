class TestChapter {
  int? chapterId;
  int? courseId;
  int? marks;
  String? chapterName;
  String? chapterDescription;
  int? isStarted;
  String? lecturer;
  int? quesNum;
  int? quesTime;
  var startTime;
  var endTime;
  int? isPublished;

  TestChapter(
      {this.chapterId,
      this.courseId,
      this.chapterName,
      this.chapterDescription,
      this.marks,
      this.quesNum,
      this.quesTime,
      this.startTime,
      this.endTime,
      this.isPublished,
      this.lecturer,
      this.isStarted});

  factory TestChapter.fromJson(Map<String, dynamic> json) {
    return TestChapter(
      chapterId: json['chapterId'],
      courseId: json['courseId'],
      marks: json['marks'],
      chapterName: json['chapterName'],
      chapterDescription: json['chapterDescrip'],
      quesNum: json['quesNum'],
      quesTime: json['quesTime'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isPublished: json['isPublished'],
      lecturer: json['lecturer'],
      isStarted: json['isStarted'],
    );
  }
}
