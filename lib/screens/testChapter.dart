import 'package:badges/badges.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:ulms/custom_widget/myCourseNavigator.dart';
import 'package:ulms/custom_widget/notificationDialog.dart';
import 'package:ulms/custom_widget/testChapter.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/testModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:flutter/material.dart' as material;

enum MenuItem { lecturer, edit, notification, video, question, result }

class TestChapterPage extends StatefulWidget {
  final int? courseId;
  final String? coursecode;
  final String? role;
  const TestChapterPage({Key? key, this.courseId, this.coursecode, this.role})
      : super(key: key);

  @override
  State<TestChapterPage> createState() => _TestChapterPageState();
}

class _TestChapterPageState extends State<TestChapterPage> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  List<TestChapter> courses = [];
  List<bool> isLoading1 = [];
  List<bool> isLoading2 = [];
  final List _date = [];
  _getParameter() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getTestChapter(widget.courseId!)
        .then((value) {
      // print(value);
      setState(() {
        courses = value;
        courses.forEach((element) {
          isLoading1.add(false);
          isLoading2.add(false);
          var start = DateTime.parse(element.startTime);
          _date.add(start);
        });
        isLoading = false;
      });
    });
  }

  _deleteChapter(chapterId) async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .deleteTestChapter(chapterId)
        .then((value) {
      setState(() {
        if (value == 'Test deleted successfully') {
          _getParameter();
          isLoading = false;
          showDialog(
              context: context,
              builder: ((context) {
                return ThemeHelper().alartDialog(
                    "Hurray", "Test deleted successfully", context);
              }));
        } else {
          isLoading = false;

          showDialog(
              context: context,
              builder: ((context) {
                return ThemeHelper()
                    .alartDialog("Oops", "An Error Occured", context);
              }));
        }
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
      header: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Test",
              style: context.textTheme.titleLarge,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button(
                child: material.Icon(
                  material.Icons.refresh_sharp,
                  color: Colors.green,
                  size: 24.0,
                  // semanticLabel: 'Text to announce in accessibility modes',
                ),
                onPressed: () {
                  _getParameter();
                }),
          ),
          if (widget.role!.toLowerCase() != "examiner")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  child: const Text("Create"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return TestChapterDialog(
                            courseId: widget.courseId!,
                          );
                        }));
                  }),
            ),
        ],
      ),
      content: isLoading
          ? ThemeHelper().progressBar2()
          : ListView(
              children: [
                material.DataTable(
                    horizontalMargin: 10,
                    dividerThickness: 1.5,
                    columnSpacing: 15,
                    showBottomBorder: true,
                    columns: const [
                      material.DataColumn(label: Text("S/N")),
                      material.DataColumn(label: Text("Start")),
                      material.DataColumn(label: Text("Name")),
                      material.DataColumn(label: Text("Type")),
                      material.DataColumn(label: Text("Test No.")),
                      material.DataColumn(label: Text("Test Time")),
                      material.DataColumn(label: Text("Mark")),
                      material.DataColumn(label: Text("CreatedBy")),
                      material.DataColumn(label: Text("Start Time")),
                      material.DataColumn(label: Text("End Time")),
                      material.DataColumn(label: Text("Published")),
                      material.DataColumn(label: Text("Action")),
                    ],
                    rows: courses
                        .map((course) => material.DataRow(cells: [
                              material.DataCell(
                                Text("${courses.indexOf(course) + 1}"),
                              ),
                              material.DataCell(isLoading2[
                                      courses.indexOf(course)]
                                  ? const SizedBox(child: ProgressRing())
                                  : ToggleSwitch(
                                      checked:
                                          course.isStarted == 1 ? true : false,
                                      onChanged: ((value) async {
                                        if (course.lecturer!.toLowerCase() ==
                                            "you") {
                                          var data = {
                                            "testId": course.chapterId,
                                          };
                                          setState(() {
                                            isLoading2[
                                                courses.indexOf(course)] = true;
                                          });
                                          await _apiRepositoryImplmentation
                                              .isTestStarted(data)
                                              .then((result) {
                                            if (result == "UnPublished") {
                                              setState(() {
                                                course.isStarted = 0;
                                                isLoading2[courses
                                                    .indexOf(course)] = false;
                                              });
                                            }
                                            if (result == "Published") {
                                              setState(() {
                                                course.isStarted = 1;
                                                isLoading2[courses
                                                    .indexOf(course)] = false;
                                              });
                                            }
                                          });
                                        }
                                      }),
                                    )),
                              material.DataCell(
                                Text(course.chapterName!),
                              ),
                              material.DataCell(
                                Text(course.chapterDescription!,
                                    style: TextStyle(
                                        color: course.chapterDescription ==
                                                "Assessment"
                                            ? Colors.yellow
                                            : course.chapterDescription ==
                                                    "Test"
                                                ? Colors.blue
                                                : course.chapterDescription ==
                                                        "Make-Up"
                                                    ? Colors.red
                                                    : Colors.green,
                                        fontWeight: FontWeight.bold)),
                              ),
                              material.DataCell(
                                Badge(
                                  badgeContent: Text("${course.quesNum}",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  badgeStyle: BadgeStyle(
                                      badgeColor: Colors.blue,
                                      elevation: 4,
                                      shape: BadgeShape.twitter),
                                ),
                                // Text(course.quesNum.toString()),
                              ),
                              material.DataCell(
                                  // Badge(
                                  //   badgeContent: Text(
                                  //       "${course.quesTime} mins",
                                  //       style: const TextStyle(
                                  //           color: Colors.white)),
                                  //   position: BadgePosition.center(),
                                  //   badgeStyle: BadgeStyle(
                                  //       badgeColor: Colors.blue,
                                  //       elevation: 4,
                                  //       shape: BadgeShape.triangle),
                                  //   // child: const Text("mins"),
                                  // ),

                                  ToggleButton(
                                checked: true,
                                onChanged: ((value) {}),
                                child: Text("${course.quesTime} mins",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )

                                  // Text(course.quesTime.toString()),
                                  ),
                              material.DataCell(
                                Badge(
                                  badgeContent: Text("${course.marks}",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  badgeStyle: BadgeStyle(
                                      badgeColor: Colors.blue,
                                      elevation: 4,
                                      shape: BadgeShape.twitter),
                                ),
                                // Text(course.marks.toString()),
                              ),
                              material.DataCell(Text.rich(
                                TextSpan(
                                  text: course.lecturer.toString(),
                                  // children: [
                                  //   TextSpan(
                                  //     text: course.lecturer.toString(),
                                  //   )
                                  // ]
                                ),
                              )),
                              material.DataCell(Column(
                                children: [
                                  Text(
                                      "${DateTime.parse(course.startTime).day}-${DateTime.parse(course.startTime).month}-${DateTime.parse(course.startTime).year}"),
                                  ToggleButton(
                                      checked: true,
                                      child: Text(
                                          material.TimeOfDay.fromDateTime(
                                                  DateTime.parse(
                                                      course.startTime))
                                              .format(context)),
                                      onChanged: (v) {})
                                ],
                              )),
                              material.DataCell(Column(
                                children: [
                                  Text(
                                      "${DateTime.parse(course.endTime).day}-${DateTime.parse(course.endTime).month}-${DateTime.parse(course.endTime).year}"),
                                  ToggleButton(
                                      checked: true,
                                      child: Text(
                                          material.TimeOfDay.fromDateTime(
                                                  DateTime.parse(
                                                      course.endTime))
                                              .format(context)),
                                      onChanged: (v) {})
                                ],
                              )),
                              material.DataCell(
                                  isLoading1[courses.indexOf(course)]
                                      ? const SizedBox(child: ProgressRing())
                                      : ToggleSwitch(
                                          checked: course.isPublished == 1
                                              ? true
                                              : false,
                                          onChanged: ((value) async {
                                            if (course.lecturer!
                                                    .toLowerCase() ==
                                                "you") {
                                              var data = {
                                                "testId": course.chapterId,
                                              };
                                              setState(() {
                                                isLoading1[courses
                                                    .indexOf(course)] = true;
                                              });
                                              await _apiRepositoryImplmentation
                                                  .isTestChapterPublished(data)
                                                  .then((result) {
                                                if (result == "UnPublished") {
                                                  setState(() {
                                                    course.isPublished = 0;
                                                    isLoading1[courses.indexOf(
                                                        course)] = false;
                                                  });
                                                }
                                                if (result == "Published") {
                                                  setState(() {
                                                    course.isPublished = 1;
                                                    isLoading1[courses.indexOf(
                                                        course)] = false;
                                                  });
                                                }
                                              });
                                            }
                                          }),
                                        )),
                              material.DataCell(
                                  material.PopupMenuButton<MenuItem>(
                                onSelected: (MenuItem value) {
                                  switch (value) {
                                    case MenuItem.lecturer:
                                      _deleteChapter(course.chapterId);

                                      break;
                                    case MenuItem.edit:
                                      showDialog(
                                          useRootNavigator: false,
                                          context: context,
                                          builder: ((context) {
                                            return TestChapterDialog(
                                              courseId: widget.courseId!,
                                              test: course,
                                            );
                                          }));
                                      break;
                                    case MenuItem.notification:
                                      showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return CourseEditDialog(
                                              title:
                                                  "${widget.coursecode} NOTIFICATION",
                                            );
                                          }));

                                      break;
                                    case MenuItem.result:
                                      Navigator.pushNamed(context,
                                          '/course/testChapter/testResult',
                                          arguments: ObjRouteParameter(
                                              chapterId: course.chapterId,
                                              role: course.chapterDescription!,
                                              coursecode: widget.coursecode,
                                              lecturer: course.lecturer));
                                      break;
                                    case MenuItem.question:
                                      Navigator.pushNamed(context,
                                          '/course/testChapter/testQuestion',
                                          arguments: ObjRouteParameter(
                                              chapterId: course.chapterId,
                                              role: course.chapterName!,
                                              courseId: course.courseId,
                                              coursecode: widget.coursecode,
                                              lecturer: course.lecturer));
                                      break;
                                    case MenuItem.video:
                                      Navigator.pushNamed(context,
                                          '/course/testChapter/testApproval',
                                          arguments: ObjRouteParameter(
                                              courseId: course.chapterId!,
                                              lecturer: course.lecturer,
                                              coursecode: course.chapterName));
                                      break;

                                    default:
                                  }
                                },
                                itemBuilder: widget.role == "examiner" &&
                                        course.chapterDescription !=
                                            "Assessment"
                                    ? ((context) => const [
                                          material.PopupMenuItem(
                                              value: MenuItem.video,
                                              child: Text("Approve Students")),
                                        ])
                                    : (widget.role != "examiner" &&
                                                course.chapterDescription !=
                                                    "Assessment") ||
                                            course.lecturer!.toLowerCase() !=
                                                "you"
                                        ? ((context) => const [
                                              material.PopupMenuItem(
                                                  value: MenuItem.question,
                                                  child: Text("Test Question")),
                                              material.PopupMenuDivider(),
                                              material.PopupMenuItem(
                                                  value: MenuItem.video,
                                                  child:
                                                      Text("Approve Students")),
                                              material.PopupMenuDivider(),
                                              material.PopupMenuItem(
                                                  value: MenuItem.result,
                                                  child: Text("View Results")),
                                              material.PopupMenuDivider(),
                                              material.PopupMenuItem(
                                                  value: MenuItem.notification,
                                                  child: Text(
                                                      "Send Notification")),
                                            ])
                                        : course.lecturer!.toLowerCase() ==
                                                "you"
                                            ? ((context) => const [
                                                  material.PopupMenuItem(
                                                      value: MenuItem.edit,
                                                      child: Text("Edit")),
                                                  material.PopupMenuDivider(),
                                                  material.PopupMenuItem(
                                                      value: MenuItem.lecturer,
                                                      child: Text("Delete")),
                                                  material.PopupMenuDivider(),
                                                  material.PopupMenuItem(
                                                      value: MenuItem.question,
                                                      child: Text(
                                                          "Test Question")),
                                                  material.PopupMenuDivider(),
                                                  material.PopupMenuItem(
                                                      value: MenuItem.video,
                                                      child: Text(
                                                          "Approve Students")),
                                                  material.PopupMenuDivider(),
                                                  material.PopupMenuItem(
                                                      value: MenuItem.result,
                                                      child:
                                                          Text("View Results")),
                                                  material.PopupMenuDivider(),
                                                  material.PopupMenuItem(
                                                      value:
                                                          MenuItem.notification,
                                                      child: Text(
                                                          "Send Notification")),
                                                ])
                                            : ((context) => const [
                                                  // material.PopupMenuItem(
                                                  //     child:
                                                  //         Text("")),
                                                ]),
                              ))
                            ]))
                        .toList())
              ],
            ),
    );
  }
}
