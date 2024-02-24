class Pagination {
  int? currentPage;
  int? lastPage;
  Pagination({this.currentPage, this.lastPage});
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
    );
  }
}
