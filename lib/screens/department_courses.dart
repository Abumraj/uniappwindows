import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:ulms/custom_widget/appbar.dart';
import 'package:ulms/custom_widget/course_assign_widget.dart';
import 'package:ulms/models/courseModel.dart';
import '../custom_widget/notificationDialog.dart';
import '../custom_widget/theme_helper.dart';
import '../services/api_repository_implement.dart';

enum MenuItem {
  lecturer,
  edit,
  notification,
}

class DepartmentCourses extends StatefulWidget {
  const DepartmentCourses({Key? key}) : super(key: key);

  @override
  State<DepartmentCourses> createState() => _DepartmentCoursesState();
}

class _DepartmentCoursesState extends State<DepartmentCourses> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  List<Courses> courses = [];
  _getParameter() async {
    await _apiRepositoryImplmentation.getDepartCourses().then((value) {
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

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: material.DataTable(
           
            horizontalMargin: 15,
            dividerThickness: 1.5,
            columnSpacing: 37,
            showBottomBorder: true,
            columns: const [
              material.DataColumn(label: Text("S/N")),
              material.DataColumn(label: Text("Title")),
              material.DataColumn(label: Text("Coursecode")),
              material.DataColumn(label: Text("Unit")),
              material.DataColumn(label: Text("type")),
              material.DataColumn(label: Text("type")),
              material.DataColumn(label: Text("Semester")),
              material.DataColumn(label: Text("Level")),
              material.DataColumn(label: Text("ChatLink")),
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
                        Text(course.type!),
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
                        Text(course.courseChatLink!),
                      ),
                      material.DataCell(material.PopupMenuButton<MenuItem>(
                        onSelected: (MenuItem value) {
                          switch (value) {
                            case MenuItem.lecturer:
                              return;
                              break;
                            default:
                          }
                        },
                        itemBuilder: ((context) => const [
                              material.PopupMenuItem(
                                  child: Text("Assign Lecturer")),
                              material.PopupMenuDivider(),
                              material.PopupMenuItem(
                                  child: Text("Edit Course")),
                              material.PopupMenuDivider(),
                              material.PopupMenuItem(
                                  child: Text("Send Notification")),
                            ]),
                      ))
                    ]))
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(FluentIcons.back),
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                )),
            const Spacer(),
            const Text(
              'All Courses',
              style: TextStyle(fontSize: 25),
            ),
            const Spacer()
          ],
        ),
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
                        material.DataColumn(label: Text("type")),
                        material.DataColumn(label: Text("type")),
                        material.DataColumn(label: Text("Semester")),
                        material.DataColumn(label: Text("Level")),
                        material.DataColumn(label: Text("ChatLink")),
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
                                  Text(course.type!),
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      course.courseChatLink!,
                                      style: const TextStyle(
                                        fontSize: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                material.DataCell(
                                    material.PopupMenuButton<MenuItem>(
                                  onSelected: (MenuItem value) {
                                    switch (value) {
                                      case MenuItem.lecturer:
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return AssignCourse(
                                                courseId: course.courseId!,
                                              );
                                            }));

                                        break;
                                      case MenuItem.edit:
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return CourseAssignWidget(
                                                title: course.coursecode!,
                                                courseId: course.courseId!,
                                                isHod: true,
                                              );
                                            }));
                                        break;
                                      case MenuItem.notification:
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return CourseEditDialog(
                                                title:
                                                    "${course.coursecode} NOTIFICATION",
                                              );
                                            }));

                                        break;
                                      default:
                                    }
                                  },
                                  itemBuilder: ((context) => const [
                                        material.PopupMenuItem(
                                            value: MenuItem.lecturer,
                                            child: Text("Assign Lecturer")),
                                        material.PopupMenuDivider(),
                                        material.PopupMenuItem(
                                            value: MenuItem.edit,
                                            child:
                                                Text("View Course Lecturer")),
                                        material.PopupMenuDivider(),
                                        material.PopupMenuItem(
                                            value: MenuItem.notification,
                                            child: Text("Send Notification")),
                                      ]),
                                ))
                              ]))
                          .toList())
                ],
              ));
  }
}
