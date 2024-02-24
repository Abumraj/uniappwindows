import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:badges/badges.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/paginatedResult.dart';
import 'package:ulms/models/testResultModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:flutter/material.dart' as material;

class SingleTestResultPage extends StatefulWidget {
  final int? testId;
  final String? testName;
  final String? testType;
  final String? testLect;
  const SingleTestResultPage(
      {super.key, this.testId, this.testLect, this.testName, this.testType});

  @override
  State<SingleTestResultPage> createState() => _SingleTestResultPageState();
}

class _SingleTestResultPageState extends State<SingleTestResultPage> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  List<TestResult> courses = [];
  PaginatedResult? _paginatedResult;
  int currentPage = 1;
  int? lastPage;

  _getParameter() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getTestResult(widget.testId!, currentPage)
        .then((value) {
      // print(value);
      setState(() {
        _paginatedResult = value;
        courses = _paginatedResult!.testResult;
        currentPage = _paginatedResult!.pagination.currentPage!;
        lastPage = _paginatedResult!.pagination.lastPage!;
        isLoading = false;
      });
    });
  }

  Future _createEcelSheet() async {
    try {
      var excel = Excel.createExcel();
      var sheet = excel['${widget.testName}(${widget.testType})'];
      excel.delete('Sheet1');

      sheet.cell(CellIndex.indexByString('A1')).value = 'Full Name';
      sheet.cell(CellIndex.indexByString('B1')).value = 'Matric Number';
      sheet.cell(CellIndex.indexByString('C1')).value = 'Score';
      for (var x = 2; x < courses.length + 2; x++) {
        sheet.cell(CellIndex.indexByString('A$x')).value =
            courses[x - 2].fullName;
        sheet.cell(CellIndex.indexByString('B$x')).value =
            courses[x - 2].matricNo;
        sheet.cell(CellIndex.indexByString('C$x')).value = courses[x - 2].score;
      }
      var fileBytes = excel.save();
      var directory = await getDownloadsDirectory();
      var pathList = directory!.path.split('\\');
      pathList[pathList.length - 1] = 'Downloads';
      var downloadPath = pathList.join('\\');
      // print("this is the picture  $downloadPath");
      if (fileBytes != null) {
        p.join(downloadPath, 'UniApp', 'Exam').createPath();
        File(p.join(downloadPath, 'UniApp', 'Exam',
            '${widget.testName}(${widget.testType}).xlsx'))
          ..create(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
    } catch (e) {
      return 'An error Occurred';
    }
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
              "${widget.testName}(${widget.testType})",
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
                                  return ThemeHelper().alartDialog("Hurray!",
                                      "Result exported successfully", context);
                                }));
                          }
                        });
                      }),
                )
              : Container()
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
                      material.DataColumn(label: Text("Full Name")),
                      material.DataColumn(label: Text("Matric number")),
                      material.DataColumn(label: Text("Score")),
                    ],
                    rows: courses
                        .map((course) => material.DataRow(cells: [
                              material.DataCell(
                                Text("${courses.indexOf(course) + 1}"),
                              ),
                              material.DataCell(
                                Text(course.fullName!),
                              ),
                              material.DataCell(
                                Text(
                                  course.matricNo!,
                                ),
                              ),
                              material.DataCell(
                                Badge(
                                  badgeContent: Text("${course.score}",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  badgeStyle: BadgeStyle(
                                      badgeColor: Colors.blue,
                                      elevation: 4,
                                      shape: BadgeShape.twitter),
                                ),
                                // Text(course.quesNum.toString()),
                              ),
                            ]))
                        .toList())
              ],
            ),
    );
  }
}
