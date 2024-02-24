class NotificationFcm {
  int? id;
  String? title;
  String? image;
  String? body;
  String? link;
  String? time;

  NotificationFcm(
      {this.id, this.body, this.link, this.time, this.image, this.title});

  factory NotificationFcm.fromJson(Map<String, dynamic> json) {
    return NotificationFcm(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      body: json['body'],
      link: json['link'],
      time: json['time'],
    );
  }
}
