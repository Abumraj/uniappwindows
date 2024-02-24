import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/studentModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:flutter/material.dart' as material;

class TestApproval extends StatefulWidget {
  final int? testId;
  final String? testName;
  final String? testLect;
  const TestApproval({super.key, this.testLect, this.testName, this.testId});

  @override
  State<TestApproval> createState() => _TestApprovalState();
}

class _TestApprovalState extends State<TestApproval> {
  final TextEditingController _searchController = TextEditingController();
  int search = 1;
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  List<Students> courseLcturer = [];
  List<Students> searchedStudent = [];
  List<bool> isLoading1 = [];
  List<Students> present = [];
  List<Students> absent = [];
  bool isLoading = true;
  _getLecturer() async {
    setState(() {
      searchedStudent = [];
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getRegisteredTestStudent(widget.testId!)
        .then((value) {
      setState(() {
        courseLcturer = value;
        courseLcturer.forEach((element) {
          isLoading1.add(false);
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    _getLecturer();
    super.initState();
  }

  Future _createEcelSheet() async {
    present = [];
    absent = [];
    courseLcturer.forEach((element) {
      present.addIf(element.isPublished.toString() == "1", element);
      absent.addIf(element.isPublished.toString() == "0", element);
    });
    try {
      var excel = Excel.createExcel();
      var sheet = excel['${widget.testName}(Present)'];
      var sheet1 = excel['${widget.testName}(Absent)'];
      excel.delete('Sheet1');

      sheet.cell(CellIndex.indexByString('A1')).value = 'Full Name';
      sheet.cell(CellIndex.indexByString('B1')).value = 'Matric Number';
      sheet.cell(CellIndex.indexByString('C1')).value = 'Department';
      sheet.cell(CellIndex.indexByString('D1')).value = 'Level';
      sheet1.cell(CellIndex.indexByString('A1')).value = 'Full Name';
      sheet1.cell(CellIndex.indexByString('B1')).value = 'Matric Number';
      sheet1.cell(CellIndex.indexByString('C1')).value = 'Department';
      sheet1.cell(CellIndex.indexByString('D1')).value = 'Level';
      for (var x = 2; x < present.length + 2; x++) {
        sheet.cell(CellIndex.indexByString('A$x')).value =
            present[x - 2].fullName;
        sheet.cell(CellIndex.indexByString('B$x')).value =
            present[x - 2].matricNo;
        sheet.cell(CellIndex.indexByString('C$x')).value =
            present[x - 2].department;
        sheet.cell(CellIndex.indexByString('D$x')).value = present[x - 2].level;
      }
      excel.save();

      for (var x = 2; x < absent.length + 2; x++) {
        sheet1.cell(CellIndex.indexByString('A$x')).value =
            absent[x - 2].fullName;
        sheet1.cell(CellIndex.indexByString('B$x')).value =
            absent[x - 2].matricNo;
        sheet1.cell(CellIndex.indexByString('C$x')).value =
            absent[x - 2].department;
        sheet1.cell(CellIndex.indexByString('D$x')).value = absent[x - 2].level;
      }
      var fileBytes = excel.save();
      var directory = await getDownloadsDirectory();
      var pathList = directory!.path.split('\\');
      pathList[pathList.length - 1] = 'Downloads';
      var downloadPath = pathList.join('\\');
      // print("this is the picture  $downloadPath");
      if (fileBytes != null) {
        p.join(downloadPath, 'UniApp', 'Attendance').createPath();
        File(p.join(downloadPath, 'UniApp', 'Attendance',
            '${widget.testName}(Attendance).xlsx'))
          ..create(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
    } catch (e) {
      return 'An error Occurred';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: Column(
          children: [
            Row(
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
                Text(
                  "Exam Hall Acess Approval",
                  style: context.textTheme.titleLarge,
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
                        _getLecturer();
                      }),
                ),
                widget.testLect!.toLowerCase() == 'you'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                            child: const Text("Export xlsx"),
                            onPressed: () {
                              _createEcelSheet().then((value) {
                                if (value == "An error Occurred") {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return ThemeHelper().alartDialog(
                                            "Ooops",
                                            "File in use. kindly close the excel file if currently opened",
                                            context);
                                      }));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return ThemeHelper().alartDialog(
                                            "Hurray!",
                                            "Result exported successfully",
                                            context);
                                      }));
                                }
                              });
                            }),
                      )
                    : Container()
              ],
            ),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: TextBox(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    controller: _searchController,
                    onChanged: (value) {
                      switch (search) {
                        case 1:
                          setState(() {
                            searchedStudent = courseLcturer
                                .where((element) => element.fullName!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                          break;
                        case 2:
                          setState(() {
                            searchedStudent = courseLcturer
                                .where((element) => element.matricNo!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                          break;
                        case 3:
                          setState(() {
                            searchedStudent = courseLcturer
                                .where((element) => element.department!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                          break;
                        case 4:
                          setState(() {
                            searchedStudent = courseLcturer
                                .where((element) => element.level!
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                          break;

                        default:
                      }
                    },
                    suffix: const Icon(FluentIcons.search),
                    prefix: Text(
                      "${searchedStudent.length} Search Results",
                      style: TextStyle(color: Colors.blue),
                    ),
                    placeholder: search == 1
                        ? "Search by student name"
                        : search == 2
                            ? "Search by Matric No."
                            : search == 3
                                ? "Search by Department."
                                : search == 4
                                    ? "Search by Level."
                                    : search == 5
                                        ? "Search Approved Students."
                                        : "Search Unapproved Students.",
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        checked: search == 1 ? true : false,
                        content: const Text("Name."),
                        onChanged: ((value) {
                          setState(() {
                            search = 1;
                          });
                        })),
                    Checkbox(
                        checked: search == 2 ? true : false,
                        content: const Text("Matric No."),
                        onChanged: ((value) {
                          setState(() {
                            search = 2;
                          });
                        })),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        checked: search == 3 ? true : false,
                        content: const Text("Department."),
                        onChanged: ((value) {
                          setState(() {
                            search = 3;
                          });
                        })),
                    Checkbox(
                        checked: search == 4 ? true : false,
                        content: const Text("Level."),
                        onChanged: ((value) {
                          setState(() {
                            search = 4;
                          });
                        })),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        checked: search == 5 ? true : false,
                        content: const Text("Approved."),
                        onChanged: ((value) {
                          setState(() {
                            search = 5;
                            if (search == 5) {
                              searchedStudent = courseLcturer
                                  .where((element) => element.isPublished == 1)
                                  .toList();
                            }
                          });
                        })),
                    Checkbox(
                        checked: search == 6 ? true : false,
                        content: const Text("Not Approved."),
                        onChanged: ((value) {
                          setState(() {
                            search = 6;
                            if (search == 6) {
                              searchedStudent = courseLcturer
                                  .where((element) => element.isPublished == 0)
                                  .toList();
                            }
                          });
                        })),
                  ],
                ),
              ],
            ),
          ],
        ),
        content: isLoading
            ? const Center(child: ProgressRing())
            : searchedStudent.isEmpty && _searchController.text.isNotEmpty
                ? const Center(
                    child: Text("No result found"),
                  )
                : searchedStudent.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 3),
                        itemCount: searchedStudent.length,
                        itemBuilder: (BuildContext context, int index) {
                          var courseLecture = searchedStudent[index];

                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ListTile(
                                      leading: CircleAvatar(
                                          child: Image(
                                        image: NetworkImage(
                                            courseLecture.imageUrl!),
                                      )
                                          // backgroundImage: ,
                                          ),
                                      title: Text(
                                        courseLecture.fullName!,
                                        // style: context.textTheme.titleMedium,
                                      ),
                                      subtitle: Text(
                                        courseLecture.matricNo!,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: isLoading1[index]
                                          ? const ProgressRing()
                                          : ToggleSwitch(
                                              checked:
                                                  courseLecture.isPublished == 0
                                                      ? false
                                                      : true,
                                              onChanged: ((value) async {
                                                var data = {
                                                  "testId": widget.testId,
                                                  "userId": courseLecture.id
                                                };
                                                setState(() {
                                                  isLoading1[index] = true;
                                                });
                                                await _apiRepositoryImplmentation
                                                    .isStudentApproved(data)
                                                    .then((result) {
                                                  print(result);

                                                  if (result == 'Published') {
                                                    setState(() {
                                                      courseLecture
                                                          .isPublished = 1;
                                                      isLoading1[index] = false;
                                                    });
                                                  } else if (result ==
                                                      'UnPublished') {
                                                    setState(() {
                                                      courseLecture
                                                          .isPublished = 0;
                                                      isLoading1[index] = false;
                                                    });
                                                  } else if (result ==
                                                      'impossible') {
                                                    setState(() {
                                                      isLoading1[index] = false;
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return ThemeHelper()
                                                              .alartDialog(
                                                                  'Oops',
                                                                  'You cannot UnPublish because this student has already done this test.',
                                                                  context);
                                                        }));
                                                  } else {
                                                    setState(() {
                                                      isLoading1[index] = false;
                                                    });
                                                    ThemeHelper().alartDialog(
                                                        'Oops',
                                                        'An error occurred',
                                                        context);
                                                  }
                                                });
                                              }),
                                            )),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text.rich(
                                          TextSpan(text: "Dept: ", children: [
                                        TextSpan(
                                          text: courseLecture.department,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ])),
                                      const Spacer(),
                                      Text.rich(
                                          TextSpan(text: "Level: ", children: [
                                        TextSpan(
                                          text: courseLecture.level.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 3),
                        itemCount: courseLcturer.length,
                        itemBuilder: (BuildContext context, int index) {
                          var courseLecture = courseLcturer[index];

                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      leading: const CircleAvatar(
                                        // foregroundImage: NetworkImage(courseLecture.imageUrl!),
                                        // backgroundImage: ,
                                        radius: 50,
                                      ),
                                      title: Text(
                                        courseLecture.fullName!,
                                        // style: context.textTheme.titleMedium,
                                      ),
                                      subtitle: Text(
                                        courseLecture.matricNo!,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: isLoading1[index]
                                          ? const ProgressRing()
                                          : ToggleSwitch(
                                              // style: ToggleSwitchThemeData(
                                              //     checkedThumbDecoration:
                                              //         Decoration()),
                                              checked:
                                                  courseLecture.isPublished == 0
                                                      ? false
                                                      : true,
                                              onChanged: ((value) async {
                                                var data = {
                                                  "testId": widget.testId,
                                                  "userId": courseLecture.id
                                                };
                                                setState(() {
                                                  isLoading1[index] = true;
                                                });
                                                await _apiRepositoryImplmentation
                                                    .isStudentApproved(data)
                                                    .then((result) {
                                                  if (result == 'Published') {
                                                    setState(() {
                                                      courseLecture
                                                          .isPublished = 1;
                                                      isLoading1[index] = false;
                                                    });
                                                  } else if (result ==
                                                      'UnPublished') {
                                                    setState(() {
                                                      courseLecture
                                                          .isPublished = 0;
                                                      isLoading1[index] = false;
                                                    });
                                                  } else if (result ==
                                                      'impossible') {
                                                    setState(() {
                                                      isLoading1[index] = false;
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return ThemeHelper()
                                                              .alartDialog(
                                                                  'Oops',
                                                                  'You cannot UnPublish because this student has already done this test.',
                                                                  context);
                                                        }));
                                                  } else {
                                                    setState(() {
                                                      isLoading1[index] = false;
                                                    });
                                                    ThemeHelper().alartDialog(
                                                        'Oops',
                                                        'An error occurred',
                                                        context);
                                                  }
                                                });
                                              }),
                                            )),
                                  Row(
                                    children: [
                                      Text.rich(
                                          TextSpan(text: "Dept: ", children: [
                                        TextSpan(
                                          text: courseLecture.department,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ])),
                                      const Spacer(),
                                      Text.rich(
                                          TextSpan(text: "Level: ", children: [
                                        TextSpan(
                                          text: courseLecture.level.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ));
  }
}
