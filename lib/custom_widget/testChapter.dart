import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/testModel.dart';
import 'package:ulms/services/api_repository_implement.dart';

class TestChapterDialog extends StatefulWidget {
  final int courseId;
  final TestChapter? test;
  const TestChapterDialog({Key? key, required this.courseId, this.test})
      : super(key: key);

  @override
  State<TestChapterDialog> createState() => _TestChapterDialogState();
}

class _TestChapterDialogState extends State<TestChapterDialog> {
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  final TextEditingController _nameTextController = TextEditingController();

  final TextEditingController _questionTimeTextController =
      TextEditingController();
  final TextEditingController _questionNumberTextController =
      TextEditingController();
  final TextEditingController _markTextController = TextEditingController();
  m.TimeOfDay? startTime;
  m.TimeOfDay? endTime;
  int isPublished = 0;
  String? lectId;
  DateTime? _date;
  bool isLoading = false;
  @override
  void initState() {
    isPublished = 0;
    if (widget.test != null) {
      _nameTextController.text = widget.test!.chapterName!;
      lectId = widget.test!.chapterDescription!;
      _questionNumberTextController.text = widget.test!.quesNum!.toString();
      _questionTimeTextController.text = widget.test!.quesTime!.toString();
      _markTextController.text = widget.test!.marks!.toString();
      _date = DateTime.parse(widget.test!.startTime);
      startTime =
          m.TimeOfDay.fromDateTime(DateTime.parse(widget.test!.startTime));
      endTime = m.TimeOfDay.fromDateTime(DateTime.parse(widget.test!.endTime!));
      isPublished = widget.test!.isPublished!;
    }
    super.initState();
  }

  _pickDate() async {
    var date = await m.showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2300));

    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }

  Future<m.TimeOfDay?> _pickTime() {
    return m.showTimePicker(
      context: context,
      initialTime: m.TimeOfDay.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(
          child: Text(widget.test == null ? "Create Test" : "Update Test")),
      content: isLoading
          ? const ProgressRing()
          : Scrollbar(
              controller: scrollController,
              child: ListView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _nameTextController,
                    placeholder: "E.g GNS111-TEST",
                    //header: "Test name",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checked: lectId == "Assessment" ? true : false,
                        onChanged: (v) {
                          setState(() {
                            lectId = "Assessment";
                          });
                        },
                        content: Text("Assessment",
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 10)),
                      ),
                      const Spacer(),
                      Checkbox(
                        checked: lectId == "Test" ? true : false,
                        onChanged: (v) {
                          setState(() {
                            lectId = "Test";
                          });
                        },
                        content: Text("Test",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Checkbox(
                        checked: lectId == "Make-Up" ? true : false,
                        onChanged: (v) {
                          setState(() {
                            lectId = "Make-Up";
                          });
                        },
                        content: Text("Make-Up",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Checkbox(
                        checked: lectId == "Exam" ? true : false,
                        onChanged: (v) {
                          setState(() {
                            lectId = "Exam";
                          });
                        },
                        content: Text(
                          "Exam",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _questionNumberTextController,
                    placeholder:
                        "Number of test questions to take at a time. E.g 20",
                    //header: "Question No.",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _questionTimeTextController,
                    placeholder: "Test Time in Minutes. E.g 15",
                    //header: "Test time",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _markTextController,
                    placeholder: "E.g 1",
                    //header: "Test Total Mark",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                      onPressed: (() {
                        _pickDate();
                      }),
                      child: _date == null
                          ? const Text("Select Test Start Date")
                          : Text(
                              "${_date!.day}/${_date!.month}/${_date!.year}",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Button(
                        onPressed: (() {
                          _pickTime().then((value) {
                            setState(() {
                              startTime = value;
                            });
                          });
                        }),
                        child: startTime == null
                            ? const Text("select Start Time")
                            : Text("Start Time: ${startTime!.format(context)}",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold))),
                    const Spacer(),
                    Button(
                        onPressed: (() {
                          _pickTime().then((value) {
                            setState(() {
                              endTime = value;
                            });
                          });
                        }),
                        child: endTime == null
                            ? const Text("select End Time")
                            : Text("End Time: ${endTime!.format(context)}",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold))),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Checkbox(
                      checked: isPublished == 0 ? false : true,
                      content: const Text("isPublished"),
                      onChanged: (v) {
                        if (isPublished == 0) {
                          setState(() {
                            isPublished = 1;
                          });
                        } else {
                          setState(() {
                            isPublished = 0;
                          });
                        }
                      })
                ],
              ),
            ),
      actions: [
        Button(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            }),
        Button(
            child: Text(widget.test == null ? "Create" : "Update"),
            onPressed: () async {
              if (lectId == null) {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ThemeHelper().alartDialog(
                          "Oops", "You must select Test type.", context);
                    }));
              } else {
                var school;
                if (widget.test != null) {
                  school = {
                    "testId": widget.test!.chapterId!,
                    "courseId": widget.courseId,
                    "chapterDescrip": lectId,
                    "chapterName": _nameTextController.text,
                    "mark": _markTextController.text,
                    "isPublished": isPublished,
                    "startTime": DateTime(_date!.year, _date!.month, _date!.day,
                            startTime!.hour, startTime!.minute)
                        .toString(),
                    "endTime": DateTime(_date!.year, _date!.month, _date!.day,
                            endTime!.hour, endTime!.minute)
                        .toString(),
                    "quesNum": int.parse(_questionNumberTextController.text),
                    "quesTime": int.parse(_questionTimeTextController.text)
                  };
                } else {
                  school = {
                    "courseId": widget.courseId,
                    "chapterDescrip": lectId,
                    "chapterName": _nameTextController.text,
                    "mark": _markTextController.text,
                    "isPublished": isPublished,
                    "startTime": DateTime(_date!.year, _date!.month, _date!.day,
                            startTime!.hour, startTime!.minute)
                        .toString(),
                    "endTime": DateTime(_date!.year, _date!.month, _date!.day,
                            endTime!.hour, endTime!.minute)
                        .toString(),
                    "quesNum": int.parse(_questionNumberTextController.text),
                    "quesTime": int.parse(_questionTimeTextController.text)
                  };
                }
                setState(() {
                  isLoading = true;
                });
                await _apiRepositoryImplmentation
                    .saveTest(school)
                    .then((result) {
                  print(result);
                  String message = '';
                  if (result == 'Test updated successfully') {
                    setState(() {
                      message = "Test updated successfully";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Hurray", message, context);
                        }));
                  } else if (result == 'Test added successfully') {
                    setState(() {
                      message = "Test Created successfully";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Hurray", message, context);
                        }));
                  } else if (result == 'Test not created') {
                    setState(() {
                      message =
                          "Make-up Test not created. You can only create make-up for existing Test that has ended. To create one, make sure you use the same name for both test and make-up. This way the system will automatically register the affected students for the make-up.  ";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Hurray", message, context);
                        }));
                  } else if (result == 'Make-up test created successfully') {
                    setState(() {
                      message = "Make-up test created successfully";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Hurray", message, context);
                        }));
                  } else {
                    setState(() {
                      message = "An Error Occured";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Oops", result, context);
                        }));
                  }
                });
              }
            }),
      ],
    );
  }
}
