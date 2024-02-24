import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:ulms/custom_widget/myCourseNavigator.dart';
import 'package:ulms/models/courseModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import '../custom_widget/course_assign_widget.dart';
import '../custom_widget/course_edit_dialog.dart';
import '../custom_widget/theme_helper.dart';

enum MenuItem {
  lecturer,
  edit,
  notification,
}

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
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
          'My Courses',
          style: TextStyle(fontSize: 25),
        )),
        content: isLoading
            ? ThemeHelper().progressBar2()
            : ListView(
                children: [
                  material.DataTable(
                      // dataRowColor: material.MaterialStateProperty.resolveWith<Color?>(
                      //     (Set<material.MaterialState> states) {
                      //   if (states.contains(material.MaterialState.selected)) {
                      //     return material.Colors.purple.withOpacity(0.3);
                      //   }
                      //   return null; // Use the default value.
                      // }),
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
                                    style: const TextStyle(
                                          fontSize: 1,
                                          overflow: TextOverflow.visible)),
                                ),
                                material.DataCell(ToggleButton(
                                  checked: true,
                                  onChanged: ((value) {}),
                                  child: Text(
                                    course.role.toString() == "lead-tutor"
                                        ? "Coordinator"
                                        : course.role.toString() == "examiner"
                                            ? "Examiner"
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
                                        showDialog(
                                            useRootNavigator: false,
                                            context: context,
                                            builder: ((context) {
                                              return CourseAssignWidget(
                                                title: course.coursecode!,
                                                courseId: course.courseId!,
                                                isHod: false,
                                              );
                                            }));

                                        break;
                                      case MenuItem.edit:
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return EditDialog(
                                                courseId: course.courseId!,
                                                title:
                                                    "Change ${course.coursecode} chat Link",
                                                chatLink:
                                                    course.courseChatLink!,
                                              );
                                            }));
                                        setState(() {
                                          _getParameter();
                                        });
                                        // _getParameter();
                                        break;
                                      case MenuItem.notification:
                                        Navigator.pushNamed(
                                          context,
                                          '/course/chapter',
                                          arguments: ObjRouteParameter(
                                              courseId: course.courseId!,
                                              coursecode: course.coursecode,
                                              role: course.role),
                                        );

                                        break;
                                      default:
                                    }
                                  },
                                  itemBuilder: ((context) => const [
                                        material.PopupMenuItem(
                                            value: MenuItem.edit,
                                            child: Text("Edit Course")),
                                        material.PopupMenuDivider(),
                                        material.PopupMenuItem(
                                            value: MenuItem.lecturer,
                                            child: Text("View Lecturers")),
                                        material.PopupMenuDivider(),
                                        material.PopupMenuItem(
                                            value: MenuItem.notification,
                                            child: Text("View Chapters")),
                                      ]),
                                ))
                              ]))
                          .toList())
                ],
              ));
  }
}
