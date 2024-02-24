import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/custom_widget/custom_dashboard.dart';
import 'package:ulms/custom_widget/custom_route.dart';
import 'package:ulms/custom_widget/myCourseNavigator.dart';
import 'package:ulms/custom_widget/theme_helper.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
        appBar: ThemeHelper().appbar(),
        pane: NavigationPane(
            // leading: ToggleSwitch(checked: ),
            displayMode: PaneDisplayMode.compact,
            selected: index,
            onChanged: ((value) {
              setState(() {
                index = value;
              });
            }),
            items: [
              PaneItem(
                body: 
                
            MyDashboardRoute(navigatorKey: GlobalKey<NavigatorState>()),
                
                  icon: const Icon(
                    FluentIcons.dashboard_add,
                  ),
                  title: const Text(
                    "Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              PaneItem(
                body: 
                MyCourseNavigator(
              navigatorKey: GlobalKey<NavigatorState>(),
              param: ObjRouteParameter(),
            ),
                  icon: const Icon(
                    FluentIcons.book_answers,
                  ),
                  title: const Text("My Courses",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              PaneItem(
                body: 
            CustomNavigator(navigatorKey: GlobalKey<NavigatorState>()),
                
                  icon: const Icon(
                    FluentIcons.test_add,
                  ),
                  title: const Text("Test",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              // PaneItem(
              //     icon: const Icon(
              //       FluentIcons.account_management,
              //     ),
              //     title: const Text("My Profile",
              //         style: TextStyle(fontWeight: FontWeight.bold))),
              // PaneItem(
              //     icon: const Icon(
              //       FluentIcons.alert_solid,
              //     ),
              //     title: const Text("Notification",
              //         style: TextStyle(fontWeight: FontWeight.bold))),
            ]),);
        // content: NavigationBody(
        //   index: index,
        //   children: [
        //     MyDashboardRoute(navigatorKey: GlobalKey<NavigatorState>()),
        //     MyCourseNavigator(
        //       navigatorKey: GlobalKey<NavigatorState>(),
        //       param: ObjRouteParameter(),
        //     ),
        //     CustomNavigator(navigatorKey: GlobalKey<NavigatorState>()),
        //     const ProfileScreen(),
        //     MyNotification(),
        //     const ScaffoldPage(
        //       content: ListTile(
        //         title: Text("raji"),
        //         subtitle: Text("Ade goes to school"),
        //         leading: CircleAvatar(),
        //       ),
        //     ),
        //   ],
        // ));
  
  
  }
}
