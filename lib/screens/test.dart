import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:ulms/custom_widget/myCourseNavigator.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/courseModel.dart';
import 'package:ulms/services/api_repository_implement.dart';

enum MenuItem {
  lecturer,
}

class CourseTest extends StatefulWidget {
  const CourseTest({Key? key}) : super(key: key);

  @override
  State<CourseTest> createState() => _CourseTestState();
}

class _CourseTestState extends State<CourseTest> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  List<Courses> courses = [];
  _getParameter() async {
    await _apiRepositoryImplmentation.getRegCourse().then((value) {
      setState(() {
        courses = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _getParameter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const Center(
            child: Text(
          'Test',
          style: TextStyle(fontSize: 25),
        )),
        content: isLoading
            ? ThemeHelper().progressBar2()
            : ListView(
                children: [
                  material.DataTable(
                      horizontalMargin: 15,
                      dividerThickness: 1.5,
                      columnSpacing: 37,
                      showBottomBorder: true,
                      columns: const [
                        material.DataColumn(label: Text("S/N")),
                        material.DataColumn(label: Text("Title")),
                        material.DataColumn(label: Text("Coursecode")),
                        material.DataColumn(label: Text("Unit")),
                        material.DataColumn(label: Text("Status")),
                        material.DataColumn(label: Text("Semester")),
                        material.DataColumn(label: Text("Level")),
                        material.DataColumn(label: Text("ChatLink")),
                        material.DataColumn(label: Text("Role")),
                        material.DataColumn(label: Text("Action")),
                      ],
                      rows: courses
                          .map((course) => material.DataRow(cells: [
                                material.DataCell(
                                  Text("${courses.indexOf(course) + 1}"),
                                ),
                                material.DataCell(
                                  Text(course.courseName!),
                                ),
                                material.DataCell(
                                  Text(course.coursecode!),
                                ),
                                material.DataCell(
                                  Text(course.unit.toString()),
                                ),
                                material.DataCell(
                                  Text(course.status.toString()),
                                ),
                                material.DataCell(
                                  Text(course.semester.toString() == "1"
                                      ? "First Semester"
                                      : "Second Semester"),
                                ),
                                material.DataCell(
                                  Text(course.level!),
                                ),
                                material.DataCell(
                                  Text(course.courseChatLink!,
                                      style: const TextStyle(fontSize: 2)),
                                ),
                                material.DataCell(ToggleButton(
                                  checked: true,
                                  onChanged: ((value) {}),
                                  child: Text(
                                    course.role.toString() == "lead-tutor"
                                        ? "Coordinator"
                                        : "Subordinate",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                                material.DataCell(
                                    material.PopupMenuButton<MenuItem>(
                                  onSelected: (MenuItem value) {
                                    switch (value) {
                                      case MenuItem.lecturer:
                                        Navigator.pushNamed(
                                            context, "/test/testChapter",
                                            arguments: ObjRouteParameter(
                                                courseId: course.courseId,
                                                coursecode: course.coursecode,
                                                role: course.role.toString()));
                                        break;

                                      default:
                                    }
                                  },
                                  itemBuilder: ((context) => const [
                                        material.PopupMenuItem(
                                            value: MenuItem.lecturer,
                                            child: Text("View Test")),
                                      ]),
                                ))
                              ]))
                          .toList())
                ],
              ));
  }
}
