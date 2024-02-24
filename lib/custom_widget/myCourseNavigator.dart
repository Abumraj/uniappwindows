import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/screens/chapter.dart';
import 'package:ulms/screens/my_courses.dart';
import 'package:ulms/screens/question.dart';
import 'package:ulms/screens/video.dart';

class ObjRouteParameter {
  final int? courseId;
  final int? chapterId;
  final String? role;
  final String? coursecode;
  final String? lecturer;
  ObjRouteParameter(
      {this.role,
      this.coursecode,
      this.lecturer,
      this.chapterId,
      this.courseId});
}

class MyCourseNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ObjRouteParameter param;
  const MyCourseNavigator(
      {super.key, required this.navigatorKey, required this.param});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/course",

      // ignore: prefer_const_literals_to_create_immutables
      // pages: [
      //   const ChapterPage()
      // ],
      onGenerateRoute: (RouteSettings routeSettings) {
        // final args;
        if (routeSettings.arguments != null) {
          final args = routeSettings.arguments as ObjRouteParameter;
          return FluentPageRoute(builder: (context) {
            return getPage(routeSettings.name, args);
          });
        }
        return FluentPageRoute(builder: (context) {
          return const MyCourses();
        });
      },
    );
  }

  Widget getPage(String? url, ObjRouteParameter? objRouteParameter) {
    switch (url) {
      case "/course/chapter":
        return ChapterPage(
          courseId: objRouteParameter!.courseId!,
          role: objRouteParameter.role!,
          coursecode: objRouteParameter.coursecode,
        );
      case "/course/chapter/question":
        return Questions(
          chapterId: objRouteParameter!.chapterId!,
          courseId: objRouteParameter.courseId!,
          chapterName: objRouteParameter.role,
          coursecode: objRouteParameter.coursecode,
        );
      case "/course/chapter/video":
        return VideoInfo(
          chapterId: objRouteParameter!.courseId!,
          chapterName: objRouteParameter.role,
        );

      default:
        return const MyCourses();
    }
  }
}
