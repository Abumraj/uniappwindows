import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/chapterModel.dart';

import '../models/course_lecturer_model.dart';
import '../services/api_repository_implement.dart';

class ChapterDialog extends StatefulWidget {
  final Chapter? chapter;
  final int courseId;
  const ChapterDialog({super.key, this.chapter, required this.courseId});

  @override
  State<ChapterDialog> createState() => _ChapterDialogState();
}

class _ChapterDialogState extends State<ChapterDialog> {
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  final TextEditingController _nameTextController = TextEditingController();

  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _questionTimeTextController =
      TextEditingController();
  final TextEditingController _questionNumberTextController =
      TextEditingController();
  final TextEditingController _orderIdTextController = TextEditingController();
  final TextEditingController _courseIdTextController = TextEditingController();
  final TextEditingController _chapterIdTextController =
      TextEditingController();
  int isPublished = 0;
  String? lectId;

  List<CourseLecturer> courseLcturer = [];
  List<ComboBoxItem<String>> lecturerList = <ComboBoxItem<String>>[];
  _getLecturer() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getcourseLecturers(widget.courseId)
        .then((value) {
      setState(() {
        courseLcturer = value;

        lecturerList = getLecturerDropDown();
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _getLecturer();
    if (widget.chapter != null) {
      _nameTextController.text = widget.chapter!.chapterName!;
      _descriptionTextController.text = widget.chapter!.chapterDescrip!;
      _questionNumberTextController.text = widget.chapter!.quesNum!.toString();
      _questionTimeTextController.text = widget.chapter!.quesTime!.toString();
      _orderIdTextController.text = widget.chapter!.chapterOrderId!.toString();
      _courseIdTextController.text = widget.chapter!.courseId!.toString();
      _chapterIdTextController.text = widget.chapter!.chapterId!.toString();
    }
    isPublished = 0;
    super.initState();
  }

  List<ComboBoxItem<String>> getLecturerDropDown() {
    List<ComboBoxItem<String>> items = [];
    for (var i = 0; i < courseLcturer.length; i++) {
      items.insert(
        0,
        ComboBoxItem(
          value: courseLcturer[i].id.toString(),
          child: Text(
            "${courseLcturer[i].title} ${courseLcturer[i].fullName}",
            // style: const TextStyle(fontSize: 8),
          ),
          // onTap: () {},
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(
          child: Text(
              widget.chapter == null ? "Create Chapter" : "Update Chapter")),
      content: isLoading
          ? const ProgressRing()
          : Scrollbar(
              controller: scrollController,
              child: ListView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                semanticChildCount: 14,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _nameTextController,
                    placeholder: "E.g Chapter one",
                    // header: "Chapter Name",
                    // prefix: ,
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _descriptionTextController,
                    placeholder: "E.g Element of Concord",
                    // header: "Description",
                    minLines: 2,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _questionNumberTextController,
                    placeholder:
                        "Number of question to practice at a time. E.g 20",
                    // header: "Quiz Number",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _questionTimeTextController,
                    placeholder: "Practice Time in Minutes. E.g 15",
                    // header: "Quiz time",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _orderIdTextController,
                    placeholder: "Order id E.g 1",
                    // header: "Chapter Arrangement",
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ComboBox(
                    placeholder: const Text("Select Lecturer"),
                    // autofocus: true,
                    isExpanded: false,

                    // itemHeight: 15,
                    iconSize: 8,
                    items: lecturerList,
                    value: lectId,
                    onChanged: ((value) {
                      setState(() {
                        lectId = value;
                      });
                    }),
                    popupColor: Colors.successPrimaryColor,
                  ),
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
            child: Text(widget.chapter == null ? "Create" : "Update"),
            onPressed: () async {
              if (lectId == null) {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ThemeHelper().alartDialog("Oops",
                          "You must Assign Lecturer to this chapter.", context);
                    }));
              } else {
                var data;
                if (widget.chapter != null) {
                  data = {
                    "chapterId": int.parse(_chapterIdTextController.text),
                    "courseId": widget.courseId,
                    "chapterDescrip": _descriptionTextController.text,
                    "chapterName": _nameTextController.text,
                    "isPublished": isPublished,
                    "userId": lectId,
                    "quesNum": int.parse(_questionNumberTextController.text),
                    "quesTime": int.parse(_questionTimeTextController.text)
                  };
                } else {
                  data = {
                    "courseId": widget.courseId,
                    "chapterDescrip": _descriptionTextController.text,
                    "chapterName": _nameTextController.text,
                    'orderId': int.parse(_orderIdTextController.text),
                    "isPublished": isPublished,
                    "userId": lectId,
                    "quesNum": int.parse(_questionNumberTextController.text),
                    "quesTime": int.parse(_questionTimeTextController.text)
                  };
                }
                setState(() {
                  isLoading = true;
                });
                await _apiRepositoryImplmentation
                    .saveChapter(data)
                    .then((result) {
                  String message = '';
                  if (result == 'Chapter updated successfully') {
                    setState(() {
                      message = "Chapter updated successfully";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Hurray", message, context);
                        }));
                  }
                  if (result == 'Chapter added successfully') {
                    setState(() {
                      message = "Chapter Created successfully";
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return ThemeHelper()
                              .alartDialog("Hurray", message, context);
                        }));
                  }
                });
              }
            }),
      ],
    );
  }
}
