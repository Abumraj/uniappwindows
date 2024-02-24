import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:ulms/services/api_repository_implement.dart';
import 'package:ulms/services/constant.dart';

import '../custom_widget/theme_helper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  String? userType;
  var school;
  _getParameter() async {
    Constants.getUserRoleSharedPreference().then((value) {
      setState(() {
        userType = value;
      });
    });
    await _apiRepositoryImplmentation.getDashboard().then((value) {
      setState(() {
        school = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    isLoading = true;
    _getParameter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const Center(
            child: Text(
          'Dashboard',
          style: TextStyle(fontSize: 25),
        )),
        content: isLoading
            ? ThemeHelper().progressBar2()
            : Column(
                children: [
                  userType == "Director"
                      ? Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                    backgroundColor: material.Colors.blue,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Icon(
                                            FluentIcons.people,
                                            size: 40,
                                          ),
                                        ),
                                        Text(school['lecturers'].toString() ==
                                                'null'
                                            ? "0 Lecturer"
                                            : "${school['lecturers'].toString()}  Lecturers")
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                    backgroundColor: material.Colors.blue,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Icon(
                                            FluentIcons.people,
                                            size: 40,
                                          ),
                                        ),
                                        Text(school['Students'].toString() ==
                                                'null'
                                            ? "0 Student"
                                            : "${school['Students'].toString()}  Students")
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                    backgroundColor: material.Colors.blue,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Icon(
                                            FluentIcons.people,
                                            size: 40,
                                          ),
                                        ),
                                        Text(school['courses'].toString() ==
                                                'null'
                                            ? "0 Course"
                                            : "${school['courses'].toString()}  Courses")
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  height: 150,
                                  width: 170,
                                  child: Card(
                                    backgroundColor: material.Colors.blue,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Icon(
                                            FluentIcons.people,
                                            size: 40,
                                          ),
                                        ),
                                        Text(school['My Courses'].toString() ==
                                                'null'
                                            ? "0 My Course"
                                            : "${school['My Courses'].toString()}  My Courses")
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  height: 150,
                                  width: 150,
                                  child: const Card(
                                    backgroundColor: material.Colors.blue,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Icon(
                                            FluentIcons.people,
                                            size: 40,
                                          ),
                                        ),
                                        Text("0  Notifications")
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(15.0),
                                    height: 150,
                                    width: 200,
                                    child: GestureDetector(
                                      onTap: (() {
                                        Navigator.pushNamed(
                                            context, '/departmentCourse');
                                      }),
                                      child: const Card(
                                        backgroundColor: material.Colors.blue,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(
                                                FluentIcons.people,
                                                size: 40,
                                              ),
                                            ),
                                            Text("All Courses")
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15.0),
                              height: 150,
                              width: 150,
                              child: Card(
                                backgroundColor: material.Colors.blue,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Icon(
                                        FluentIcons.people,
                                        size: 40,
                                      ),
                                    ),
                                    Text(school['test'].toString() == 'null'
                                        ? "0 Test"
                                        : "${school['courses'].toString()}  Tests")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15.0),
                              height: 150,
                              width: 150,
                              child: Card(
                                backgroundColor: material.Colors.blue,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Icon(
                                        FluentIcons.people,
                                        size: 40,
                                      ),
                                    ),
                                    Text(school['My Courses'].toString() ==
                                            'null'
                                        ? "0 My Course"
                                        : "${school['My Courses'].toString()}  My Courses")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  const Spacer(),
                ],
              ));
  }
}
