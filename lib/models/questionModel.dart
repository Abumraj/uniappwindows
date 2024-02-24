class Question {
  int? id;
  int? courseId;
  int? chapterId;
  String? question;
  String? imageUrl;
  String? option1;
  String? solution;
  String? option2;
  String? option3;
  String? option4;
  int? isPublished;

  Question(
      {this.id,
      this.courseId,
      this.chapterId,
      this.question,
      this.imageUrl,
      this.option1,
      this.solution,
      this.option2,
      this.option3,
      this.option4,
      this.isPublished});

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        courseId: json["courseId"],
        chapterId: json["chapterId"],
        question: json["question"],
        imageUrl: json["imageUrl"],
        option1: json["option1"],
        // solution: (json['solution']).toString(),
        option2: json["option2"],
        option3: json["option3"],
        option4: json["option4"],
        isPublished: json["isPublished"],
      );
}
