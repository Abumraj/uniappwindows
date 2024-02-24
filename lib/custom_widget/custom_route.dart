import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/custom_widget/myCourseNavigator.dart';
import 'package:ulms/screens/question_view.dart';
import 'package:ulms/screens/single-test_result_page.dart';
import 'package:ulms/screens/test.dart';
import 'package:ulms/screens/testChapter.dart';
import 'package:ulms/screens/test_approval.dart';

class CustomNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const CustomNavigator({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/test",
      onGenerateRoute: (RouteSettings routeSettings) {
        // final args;
        if (routeSettings.arguments != null) {
          final args = routeSettings.arguments as ObjRouteParameter;
          return FluentPageRoute(builder: (context) {
            return getPage(routeSettings.name, args);
          });
        }
        return FluentPageRoute(builder: (context) {
          return const CourseTest();
        });
      },
    );
  }
}

Widget getPage(String? url, ObjRouteParameter? objRouteParameter) {
  switch (url) {
    case "/test/testChapter":
      return TestChapterPage(
          courseId: objRouteParameter!.courseId!,
          coursecode: objRouteParameter.coursecode,
          role: objRouteParameter.role);
    case "/course/testChapter/testQuestion":
      return QuestionView(
        chapterId: objRouteParameter!.chapterId!,
        chapterName: objRouteParameter.role,
        courseId: objRouteParameter.courseId,
        coursecode: objRouteParameter.coursecode,
        testLect: objRouteParameter.lecturer,
      );
    case "/course/testChapter/testApproval":
      return TestApproval(
        testId: objRouteParameter!.courseId!,
        testName: objRouteParameter.coursecode,
        testLect: objRouteParameter.lecturer,
      );
    case "/course/testChapter/testResult":
      return SingleTestResultPage(
        testId: objRouteParameter!.chapterId,
        testName: objRouteParameter.coursecode,
        testType: objRouteParameter.role,
        testLect: objRouteParameter.lecturer,
      );

    default:
      return const CourseTest();
  }
}
