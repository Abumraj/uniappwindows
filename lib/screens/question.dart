import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ulms/custom_widget/file_picker_ui.dart';
import 'package:ulms/custom_widget/question_dialog.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/questionModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:flutter/material.dart' as material;

class Questions extends StatefulWidget {
  final int? chapterId;
  final int? courseId;
  final String? chapterName;
  final String? coursecode;
  const Questions(
      {Key? key,
      this.chapterId,
      this.courseId,
      this.chapterName,
      this.coursecode})
      : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  List<Question> courses = [];
  List<bool> isLoading1 = [];
  _getParameter() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getQuestions(widget.chapterId!)
        .then((value) {
      setState(() {
        courses = value;
        courses.forEach((element) {
          isLoading1.add(false);
        });
        isLoading = false;
      });
    });
  }

  _deleteQuestion(questionId) async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation.deleteQuestion(questionId).then((value) {
      print(value);
      setState(() {
        if (value == 'Question deleted successfully') {
          _getParameter();
          isLoading = false;
          showDialog(
              context: context,
              builder: ((context) {
                return ThemeHelper().alartDialog(
                    "Hurray", "Question deleted successfully", context);
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

  Future _createEcelSheet() async {
    try {
      var excel = Excel.createExcel();
      var sheet = excel['${widget.chapterName}'];
      excel.delete('Sheet1');

      sheet.cell(CellIndex.indexByString('A1')).value = 'question';
      sheet.cell(CellIndex.indexByString('B1')).value =
          'Option1(Correct Answer)';
      sheet.cell(CellIndex.indexByString('C1')).value = 'option2';
      sheet.cell(CellIndex.indexByString('D1')).value = 'option3';
      sheet.cell(CellIndex.indexByString('E1')).value = 'option4';
      sheet.cell(CellIndex.indexByString('F1')).value = 'solution';
      var fileBytes = excel.save();
      var directory = await getDownloadsDirectory();
      var pathList = directory!.path.split('\\');
      pathList[pathList.length - 1] = 'Downloads';
      var downloadPath = pathList.join('\\');
      // print("this is the picture  $downloadPath");
      if (fileBytes != null) {
        p
            .join(downloadPath, 'UniApp', '${widget.coursecode}', 'Practice')
            .createPath();
        File(p.join(downloadPath, 'UniApp', '${widget.coursecode}', 'Practice',
            '${widget.chapterName}.xlsx'))
          ..create(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
    } catch (e) {
      return 'An error Occurred';
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == courses.length) {
      return material.TextButton(
        style: material.TextButton.styleFrom(
          backgroundColor: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
        ),
        child: const Text("Exit", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
    Question question = courses[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(TextSpan(
                  text: "${courses.indexOf(question) + 1}.  ",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: question.question!,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    )
                  ])),
              Text(
                question.option1.toString() != "null"
                    ? question.option1.toString()
                    : "",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              Text(
                question.option2.toString() != "null"
                    ? question.option2.toString()
                    : "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              Text(
                question.option3.toString() != "null"
                    ? question.option3.toString()
                    : "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              Text(
                question.option4.toString() != "null"
                    ? question.option4.toString()
                    : "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: "Solution: ",
                      style: TextStyle(color: Colors.purple)),
                  TextSpan(
                      text: question.solution.toString() != "null"
                          ? question.solution.toString()
                          : "",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.blue))
                ]),
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  isLoading1[courses.indexOf(question)]
                      ? const SizedBox(child: ProgressRing())
                      : ToggleSwitch(
                          checked: question.isPublished == 1 ? true : false,
                          content: Text(
                            question.isPublished == 1
                                ? "Published"
                                : "UnPublished",
                            style: TextStyle(
                                color: question.isPublished == 1
                                    ? Colors.blue
                                    : Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: ((value) async {
                            var data = {
                              "questionId": question.id,
                            };

                            setState(() {
                              isLoading1[courses.indexOf(question)] = true;
                            });
                            await _apiRepositoryImplmentation
                                .isQuestionPublished(data)
                                .then((result) {
                              if (result == "UnPublished") {
                                setState(() {
                                  question.isPublished = 0;
                                  isLoading1[courses.indexOf(question)] = false;
                                });
                              }
                              if (result == "Published") {
                                setState(() {
                                  question.isPublished = 1;
                                  isLoading1[courses.indexOf(question)] = false;
                                });
                              }
                            });
                          }),
                        ),
                  const Spacer(),
                  material.TextButton(
                      onPressed: (() {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: ((context) {
                              return QuestionDialog(
                                courseId: widget.courseId!,
                                chapterId: widget.chapterId!,
                                question: question,
                              );
                            }));
                      }),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                  const Spacer(),
                  material.TextButton(
                      onPressed: (() {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title:
                                    const Text('Delete Question permanently?'),
                                content: const Text(
                                  'If you delete this Question, you won\'t be able to recover it. Do you want to delete it?',
                                ),
                                actions: [
                                  Button(
                                    autofocus: true,
                                    onPressed: () {
                                      _deleteQuestion(question.id);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Button(
                                    child: const Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            });
                      }),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                "${widget.chapterName}: Questions",
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
                  child: const Text("Upload"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return FileUploaderUi(
                              chapterId: widget.chapterId!,
                              courseId: widget.courseId!,
                              chapterName: widget.chapterName!);
                        }));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  child: const Text("Download  SampleSheet"),
                  onPressed: () {
                    _createEcelSheet().then((value) {
                      if (value.toString() == 'An error Occurred') {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return ThemeHelper().alartDialog(
                                    "Hurray",
                                    "The process cannot access the file because it is being used by another process ",
                                    context);
                              }));
                        });
                      } else {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return ThemeHelper().alartDialog(
                                    "Hurray",
                                    "Sample Excel file has been successfully downloaded. Check 'Downloads/${widget.coursecode}/practice'",
                                    context);
                              }));
                        });
                      }
                    });
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
                          return QuestionDialog(
                            courseId: widget.courseId!,
                            chapterId: widget.chapterId!,
                          );
                        }));
                  }),
            ),
          ],
        ),
        content: isLoading
            ? ThemeHelper().progressBar2()
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: courses.length + 1,
                itemBuilder: _buildItem,
              ));
  }
}
