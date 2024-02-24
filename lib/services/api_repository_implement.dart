import 'package:get/get.dart';
import 'package:ulms/models/course_lecturer_model.dart';
import 'package:ulms/models/lecturerModel.dart';
import 'package:ulms/models/studentModel.dart';
import 'package:ulms/models/notificationModel.dart';
import 'package:ulms/models/paginatedResult.dart';
import 'package:ulms/models/paginationModel.dart';
import 'package:ulms/models/questionModel.dart';
import 'package:ulms/models/courseModel.dart';
import 'package:ulms/models/chapterModel.dart';
import 'package:ulms/models/testModel.dart';
import 'package:ulms/models/testResultModel.dart';
import 'package:ulms/services/abstract_service.dart';
import 'package:ulms/services/api_repository.dart';
import 'package:ulms/services/service_implementation.dart';

class ApiRepositoryImplmentation extends ApiRepository {
  late HttpService _httpService = Get.put(ServiceImplementation());

  ApiRepositoryImplmentation() {
    _httpService = Get.put(ServiceImplementation());
    _httpService.init();
  }

  @override
  Future<List<Chapter>> getChapter(courseId, role) async {
    try {
      final response =
          await _httpService.getRequest("/chapter/$courseId,$role");
      List<Chapter> list = parsChapter(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future saveChapter(data) async {
    try {
      final response = await _httpService.postRequest('/saveChapter', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future deleteChapter(int chapterId) async {
    try {
      final response =
          await _httpService.getRequest("/deleteChapter/$chapterId");

      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future deleteTestChapter(int chapterId) async {
    try {
      final response = await _httpService.getRequest("/deleteTest/$chapterId");

      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future<List<TestChapter>> getTestChapter(int courseId) async {
    try {
      final response = await _httpService.getRequest("/testChapter/$courseId");
      List<TestChapter> list = parsTestChapter(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future getDashboard() async {
    try {
      final response = await _httpService.getRequest("/dashboard");
      return response.data;
    } catch (e) {
      return e;
    }
  }

  @override
  Future<List<Courses>> getDepartCourses() async {
    try {
      final response = await _httpService.getRequest("/departmentalCourse");
      List<Courses> list = parseCourses(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  static List<Courses> parseCourses(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Courses>((json) => Courses.fromJson(json)).toList();
  }

  static List<Chapter> parsChapter(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Chapter>((json) => Chapter.fromJson(json)).toList();
  }

  static List<NotificationFcm> parseNotification(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<NotificationFcm>((json) => NotificationFcm.fromJson(json))
        .toList();
  }

  static List<TestChapter> parsTestChapter(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<TestChapter>((json) => TestChapter.fromJson(json))
        .toList();
  }

  static List<Question> parsQuestion(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  static List<TestResult> parseTestResult(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<TestResult>((json) => TestResult.fromJson(json)).toList();
  }

  static List<CourseLecturer> parseCourseLecturer(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<CourseLecturer>((json) => CourseLecturer.fromJson(json))
        .toList();
  }

  static List<Students> parseStudents(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Students>((json) => Students.fromJson(json)).toList();
  }

  static Pagination parsePage(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Pagination>((json) => Pagination.fromJson(json));
  }

  @override
  Future<List<Question>> getQuestions(int chapterId) async {
    try {
      final response = await _httpService.getRequest("/question/$chapterId");
      List<Question> list = parsQuestion(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Courses>> getRegCourse() async {
    try {
      final response = await _httpService.getRequest("/course");
      List<Courses> list = parseCourses(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Question>> getTestQuestions(int chapterId) async {
    try {
      final response =
          await _httpService.getRequest("/testQuestion/$chapterId");
      List<Question> list = parsQuestion(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future editCourse(courseId, courseChatLink) async {
    try {
      final response = await _httpService.postRequest(
        '/save-course',
        {
          "courseId": courseId,
          "chatLink": courseChatLink,
        },
      );
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future<List<CourseLecturer>> getLecturerAssigned() async {
    try {
      final response = await _httpService.getRequest("/departmentalLecturers");
      List<CourseLecturer> list = parseCourseLecturer(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<CourseLecturer>> getcourseLecturers(int courseId) async {
    try {
      final response = await _httpService.getRequest(
        "/courseLecturers/$courseId",
      );
      List<CourseLecturer> list = parseCourseLecturer(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future assignAndUnAssign(data) async {
    try {
      final response =
          await _httpService.postRequest('/courseManagement', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future isChapterPublished(data) async {
    try {
      final response =
          await _httpService.postRequest('/isChapterPublished', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future saveQuestion(data) async {
    try {
      final response = await _httpService.postRequest('/saveQuestion', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future saveTestQuestion(data) async {
    try {
      final response =
          await _httpService.postRequest('/saveTestQuestion', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future saveTest(data) async {
    try {
      final response = await _httpService.postRequest('/saveTest', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future deleteQuestion(int questionId) async {
    try {
      final response =
          await _httpService.getRequest("/deleteQuestion/$questionId");

      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future deleteTestQuestion(int questionId) async {
    try {
      final response =
          await _httpService.getRequest("/deleteTestQuestion/$questionId");

      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future isQuestionPublished(data) async {
    try {
      final response =
          await _httpService.postRequest('/isQuestionPublished', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future isTestChapterPublished(data) async {
    try {
      final response =
          await _httpService.postRequest('/isTestChapterPublished', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future isTestStarted(data) async {
    try {
      final response = await _httpService.postRequest('/isTestStarted', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future isTestQuestionPublished(data) async {
    try {
      final response =
          await _httpService.postRequest('/isTestQuestionPublished', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future<List<Students>> getRegisteredTestStudent(testId) async {
    try {
      final response =
          await _httpService.getRequest("/registeredTestStudent/$testId");
      List<Students> list = parseStudents(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future isStudentApproved(data) async {
    try {
      final response = await _httpService.postRequest('/testApproval', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future uploadQuestion(data) async {
    try {
      final response = await _httpService.postRequest('/uploadQuestion', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future uploadTestQuestion(data) async {
    try {
      final response =
          await _httpService.postRequest('/uploadTestQuestion', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future<PaginatedResult> getTestResult(int testId, int currentPage) async {
    try {
      final response =
          await _httpService.getRequest("/result/$testId?page=$currentPage");
      Pagination meta = Pagination(
          currentPage: response.data["meta"]["current_page"],
          lastPage: response.data["meta"]["last_page"]);
      List<TestResult> list = parseTestResult(response.data["data"][0]);
      return PaginatedResult(pagination: meta, testResult: list);
    } catch (e) {
      return PaginatedResult(
          pagination: Pagination(currentPage: 0, lastPage: 0), testResult: []);
    }
  }

  @override
  Future uploadVideo(data) async {
    try {
      final response = await _httpService.postRequest('/uploadVideo', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future sendNotification(data) async {
    try {
      final response =
          await _httpService.postRequest('/sendNotification', data);
      return response.data;
    } catch (e) {
      return "An error Ocurred";
    }
  }

  @override
  Future<List<NotificationFcm>> getDepartmentNotification() async {
    try {
      final response = await _httpService.getRequest("/departmentNotification");
      List<NotificationFcm> list = parseNotification(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<NotificationFcm>> getMyNotification() async {
    try {
      final response = await _httpService.getRequest("/myNotification");
      List<NotificationFcm> list = parseNotification(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Lecturer> getMyDetails() async {
    try {
      final response = await _httpService.getRequest("/myDetails");
      Lecturer list = Lecturer.fromJson(response.data);
      return list;
    } catch (e) {
      return Lecturer();
    }
  }
}
