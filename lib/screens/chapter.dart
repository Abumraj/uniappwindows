import 'package:badges/badges.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;
import 'package:ulms/custom_widget/chapter_dialog.dart';
import 'package:ulms/custom_widget/myCourseNavigator.dart';
import 'package:ulms/custom_widget/notificationDialog.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/chapterModel.dart';

import '../services/api_repository_implement.dart';

enum MenuItem {
  lecturer,
  edit,
  notification,
  video,
  question,
}

class ChapterPage extends StatefulWidget {
  final int? courseId;
  final String? role;
  final String? coursecode;
  const ChapterPage({Key? key, this.courseId, this.role, this.coursecode})
      : super(key: key);

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  List<Chapter> courses = [];
  List<bool> isLoading1 = [];
  _getParameter() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getChapter(widget.courseId!, widget.role!)
        .then((value) {
      // print(value);
      setState(() {
        courses = value;
        courses.forEach((element) {
          isLoading1.add(false);
        });
        isLoading = false;
      });
    });
  }

  _deleteChapter(chapterId) async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation.deleteChapter(chapterId).then((value) {
      print(value);
      setState(() {
        if (value == 'Chapter deleted successfully') {
          _getParameter();
          isLoading = false;
          showDialog(
              context: context,
              builder: ((context) {
                return ThemeHelper().alartDialog(
                    "Hurray", "Chapter deleted successfully", context);
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
                "Chapters",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  child: const Text("Create"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ChapterDialog(
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
                      horizontalMargin: 15,
                      dividerThickness: 1.5,
                      columnSpacing: 37,
                      showBottomBorder: true,
                      columns: const [
                        material.DataColumn(label: Text("S/N")),
                        material.DataColumn(label: Text("Name")),
                        material.DataColumn(label: Text("Description")),
                        material.DataColumn(label: Text("Quiz Number")),
                        material.DataColumn(label: Text("Quiz Time")),
                        material.DataColumn(label: Text("Lecturer")),
                        material.DataColumn(label: Text("isPublished")),
                        material.DataColumn(label: Text("Action")),
                      ],
                      rows: courses
                          .map((course) => material.DataRow(cells: [
                                material.DataCell(
                                  Text("${courses.indexOf(course) + 1}"),
                                ),
                                material.DataCell(
                                  Text(course.chapterName!),
                                ),
                                material.DataCell(
                                  Text(course.chapterDescrip!),
                                ),
                                material.DataCell(
                                  Badge(
                                    badgeContent: Text("${course.quesNum}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    badgeStyle: BadgeStyle(
                                        badgeColor: Colors.blue,
                                        elevation: 4,
                                        shape: BadgeShape.twitter),
                                  ),
                                ),
                                material.DataCell(
                                  Badge(
                                    badgeContent: Text("${course.quesTime}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    badgeStyle: BadgeStyle(
                                        badgeColor: Colors.blue,
                                        elevation: 4,
                                        shape: BadgeShape.twitter),
                                  ),
                                ),
                                material.DataCell(
                                  Text(course.userId.toString()),
                                ),
                                material.DataCell(
                                    isLoading1[courses.indexOf(course)]
                                        ? const SizedBox(child: ProgressRing())
                                        : ToggleSwitch(
                                            checked: course.isPublished == 1
                                                ? true
                                                : false,
                                            onChanged: ((value) async {
                                              var data = {
                                                "chapterId": course.chapterId,
                                              };
                                              print(data);
                                              setState(() {
                                                isLoading1[courses
                                                    .indexOf(course)] = true;
                                              });
                                              await _apiRepositoryImplmentation
                                                  .isChapterPublished(data)
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
                                              return ChapterDialog(
                                                courseId: widget.courseId!,
                                                chapter: course,
                                              );
                                            }));
                                        break;
                                      case MenuItem.notification:
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return CourseEditDialog(
                                                title: widget.coursecode,
                                              );
                                            }));
                                        break;
                                      case MenuItem.question:
                                        Navigator.pushNamed(
                                            context, '/course/chapter/question',
                                            arguments: ObjRouteParameter(
                                                chapterId: course.chapterId,
                                                courseId: course.courseId!,
                                                role: course.chapterName,
                                                coursecode: widget.coursecode));
                                        break;
                                      case MenuItem.video:
                                        Navigator.pushNamed(
                                            context, '/course/chapter/video',
                                            arguments: ObjRouteParameter(
                                                courseId: course.chapterId!,
                                                role: course.chapterName));
                                        break;

                                      default:
                                    }
                                  },
                                  itemBuilder: ((context) => const [
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
                                            child: Text("View Question")),
                                        material.PopupMenuDivider(),
                                        material.PopupMenuItem(
                                            value: MenuItem.video,
                                            child: Text("View Video")),
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
