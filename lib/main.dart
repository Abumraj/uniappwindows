import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/screens/chapter.dart';
import 'package:ulms/screens/department_courses.dart';
import 'package:ulms/screens/home.dart';
import 'package:ulms/screens/my_courses.dart';
import 'package:ulms/screens/program.dart';
import 'package:ulms/screens/question.dart';
import 'package:ulms/screens/question_view.dart';
import 'package:ulms/screens/single-test_result_page.dart';
import 'package:ulms/screens/test.dart';
import 'package:ulms/screens/testChapter.dart';
import 'package:ulms/screens/test_approval.dart';
import 'package:ulms/screens/video.dart';
import 'package:ulms/services/constant.dart';
import 'package:dart_vlc/dart_vlc.dart';

late FlutterSecureStorage saveLocal;
void main() async {
  DartVLC.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  bool? isLloggedIn = false;
  saveLocal = const FlutterSecureStorage();
  await Constants.getUerLoggedInSharedPreference().then(
    (value) {
      isLloggedIn = value;
    },
  );
  runApp(MyApp(
    isLoggedIn: isLloggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'UniApp',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(accentColor: Colors.blue, activeColor: Colors.blue),
      themeMode: ThemeMode.light,
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   accentColor: Colors.blue,
      // ),
      home: isLoggedIn == true ? const MyHomePage() : const ProgramSelection(),
      routes: <String, WidgetBuilder>{
        '/test': (BuildContext context) => const CourseTest(),
        '/test/testChapter': (BuildContext context) => const TestChapterPage(),
        '/course/chapter': (BuildContext context) => const ChapterPage(),
        '/course/chapter/question': (BuildContext context) => const Questions(),
        '/course/testChapter/testQuestion': (BuildContext context) =>
            const QuestionView(),
        '/course/testChapter/testResult': (BuildContext context) =>
            const SingleTestResultPage(),
        '/course/testChapter/testApproval': (BuildContext context) =>
            const TestApproval(),
        '/course/chapter/video': (BuildContext context) => const VideoInfo(),
        '/course': (BuildContext context) => const MyCourses(),
        '/departmentCourse': (BuildContext context) =>
            const DepartmentCourses(),
      },
    );
  }
}
