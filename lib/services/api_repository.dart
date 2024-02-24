import 'package:ulms/models/courseModel.dart';
import 'package:ulms/models/course_lecturer_model.dart';
import 'package:ulms/models/lecturerModel.dart';
import 'package:ulms/models/studentModel.dart';
import 'package:ulms/models/notificationModel.dart';
import 'package:ulms/models/paginatedResult.dart';
import 'package:ulms/models/testModel.dart';
import '../models/chapterModel.dart';
import '../models/questionModel.dart';

abstract class ApiRepository {
  //  Future<List<Department>> getDepartment(int facultyId);
  Future<List<Courses>> getDepartCourses();
  Future<List<Chapter>> getChapter(int courseId, String role);
  Future<List<TestChapter>> getTestChapter(int courseId);
  Future<dynamic> deleteChapter(int chapterId);
  Future<dynamic> deleteTestChapter(int chapterId);
  Future<dynamic> deleteQuestion(int questionId);
  Future<dynamic> deleteTestQuestion(int questionId);
  Future<List<Question>> getQuestions(int chapterId);
  Future<List<NotificationFcm>> getDepartmentNotification();
  Future<List<Question>> getTestQuestions(int chapterId);
  Future<List<Courses>> getRegCourse();
  Future<List<NotificationFcm>> getMyNotification();
  Future<dynamic> getDashboard();
  Future<Lecturer> getMyDetails();
  Future<List<CourseLecturer>> getLecturerAssigned();
  Future<List<CourseLecturer>> getcourseLecturers(int $courseId);
  Future<PaginatedResult> getTestResult(int testId, int currentPage);
  Future<List<Students>> getRegisteredTestStudent(int testId);
  Future<dynamic> editCourse(
    int courseId,
    String courseChatLink,
  );
  Future<dynamic> assignAndUnAssign(data);
  Future<dynamic> uploadQuestion(data);
  Future<dynamic> sendNotification(data);
  Future<dynamic> uploadVideo(data);
  Future<dynamic> uploadTestQuestion(data);
  Future<dynamic> isChapterPublished(data);
  Future<dynamic> isStudentApproved(data);
  Future<dynamic> isTestChapterPublished(data);
  Future<dynamic> isTestStarted(data);
  Future<dynamic> isQuestionPublished(data);
  Future<dynamic> isTestQuestionPublished(data);
  Future<dynamic> saveChapter(data);
  Future<dynamic> saveQuestion(data);
  Future<dynamic> saveTestQuestion(data);
  Future<dynamic> saveTest(data);
}
