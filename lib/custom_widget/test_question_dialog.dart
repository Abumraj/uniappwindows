import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/questionModel.dart';
import 'package:ulms/services/api_repository_implement.dart';

class TestQuestionDialog extends StatefulWidget {
  final int chapterId;
  final Question? question;
  const TestQuestionDialog({Key? key, required this.chapterId, this.question})
      : super(key: key);

  @override
  State<TestQuestionDialog> createState() => _TestQuestionDialogState();
}

class _TestQuestionDialogState extends State<TestQuestionDialog> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  ScrollController scrollController = ScrollController();
  final TextEditingController _questionTextController = TextEditingController();
  final TextEditingController _imageTextController = TextEditingController();
  final TextEditingController _answerTextController = TextEditingController();
  final TextEditingController _option2TextController = TextEditingController();
  final TextEditingController _option3TextController = TextEditingController();
  final TextEditingController _option4TextController = TextEditingController();
  int isPublished = 0;
  bool isLoading = false;
  bool isImageQuestion = false;
  @override
  void initState() {
    if (widget.question != null) {
      _questionTextController.text = widget.question!.question.toString();
      _imageTextController.text = widget.question!.imageUrl.toString();
      _answerTextController.text = widget.question!.option1.toString();
      _option2TextController.text = widget.question!.option2.toString();
      _option3TextController.text = widget.question!.option3.toString();
      _option4TextController.text = widget.question!.option4.toString();
      widget.question!.imageUrl != null
          ? isImageQuestion = true
          : isImageQuestion = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(
          child: Text(
              widget.question == null ? "Create Question" : "Update Question")),
      content: isLoading
          ? const SizedBox(child: ProgressRing())
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
                  Checkbox(
                      checked: isImageQuestion,
                      content: const Text("Image Question?"),
                      onChanged: (v) {
                        setState(() {
                          isImageQuestion = v!;
                        });
                      }),
                  isImageQuestion
                      ? const TextBox()
                      : TextBox(
                          controller: _questionTextController,
                          // placeholder: "E.g Chapter one",
                          //header: "Question",
                          minLines: 5,
                          maxLines: 20,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _answerTextController,
                    placeholder: "Input correct option here",
                    //header: "Correct Answer",
                    minLines: 2,
                    maxLines: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _option2TextController,
                    placeholder: "Option here",
                    //header: "Option2",
                    minLines: 2,
                    maxLines: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _option3TextController,
                    placeholder: "Option here",
                    //header: "Option3",
                    minLines: 2,
                    maxLines: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    controller: _option4TextController,
                    placeholder: "Option here",
                    //header: "Option4",
                    minLines: 2,
                    maxLines: 10,
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
                      }),
                  Text(
                    "For germane questions, Input only Question and Answer",
                    style: context.textTheme.bodyText2,
                  )
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
            child: Text(widget.question == null ? "Create" : "Update"),
            onPressed: () async {
              var data;
              if (widget.question != null) {
                data = {
                  "id": widget.question!.id,
                  "testId": widget.chapterId,
                  "question": _questionTextController.text,
                  "imageUrl": _imageTextController.text,
                  "answer": _answerTextController.text,
                  "isPublished": isPublished,
                  "option2": _option2TextController.text,
                  "option3": _option3TextController.text,
                  "option4": _option4TextController.text,
                };
              } else {
                data = {
                  "testId": widget.chapterId,
                  "question": _questionTextController.text,
                  "imageUrl": _imageTextController.text,
                  "answer": _answerTextController.text,
                  "isPublished": isPublished,
                  "option2": _option2TextController.text,
                  "option3": _option3TextController.text,
                  "option4": _option4TextController.text,
                };
              }
              setState(() {
                isLoading = true;
              });
              await _apiRepositoryImplmentation
                  .saveTestQuestion(data)
                  .then((result) {
                print(data);
                print(result);
                String message = '';
                if (result == 'Test question updated successfully') {
                  setState(() {
                    message = "Test question updated successfully";
                    isLoading = false;
                  });
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return ThemeHelper()
                            .alartDialog("Hurray", message, context);
                      }));
                }
                if (result == 'Test question added successfully') {
                  setState(() {
                    message = "Test question added successfully";
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
            }),
      ],
    );
  }
}
