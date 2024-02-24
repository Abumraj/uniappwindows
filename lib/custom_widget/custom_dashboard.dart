import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ulms/screens/dashboard.dart';
import 'package:ulms/screens/department_courses.dart';

class MyDashboardRoute extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyDashboardRoute({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/test",
      onGenerateRoute: (RouteSettings routeSettings) {
        return FluentPageRoute(builder: (context) {
          return getPage(routeSettings.name);
        });
      },
    );
  }
}

Widget getPage(String? url) {
  switch (url) {
    case "/departmentCourse":
      return const DepartmentCourses();

    default:
      return const Dashboard();
  }
}
