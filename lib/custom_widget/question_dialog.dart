import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/questionModel.dart';
import 'package:ulms/services/api_repository_implement.dart';

class QuestionDialog extends StatefulWidget {
  final int chapterId;
  final int courseId;
  final Question? question;

  const QuestionDialog(
      {super.key,
      required this.chapterId,
      this.question,
      required this.courseId});

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  ScrollController scrollController = ScrollController();
  TextEditingController _questionTextController = TextEditingController();
  TextEditingController _imageTextController = TextEditingController();
  TextEditingController _answerTextController = TextEditingController();
  TextEditingController _option2TextController = TextEditingController();
  TextEditingController _option3TextController = TextEditingController();
  TextEditingController _option4TextController = TextEditingController();
  TextEditingController _solutionTextController = TextEditingController();
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
      _solutionTextController.text = widget.question!.solution.toString();
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
                  TextBox(
                    controller: _solutionTextController,
                    placeholder: "Input Solution  here",
                    //header: "Solution",
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
                    "For germane questions, Input only question, answer and solution(if any)",
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
                  "chapterId": widget.chapterId,
                  "courseId": widget.courseId,
                  "question": _questionTextController.text,
                  "imageUrl": _imageTextController.text,
                  "answer": _answerTextController.text,
                  "isPublished": isPublished,
                  "option2": _option2TextController.text,
                  "option3": _option3TextController.text,
                  "option4": _option4TextController.text,
                  "solution": _solutionTextController.text,
                };
              } else {
                data = {
                  "chapterId": widget.chapterId,
                  "courseId": widget.courseId,
                  "question": _questionTextController.text,
                  "imageUrl": _imageTextController.text,
                  "answer": _answerTextController.text,
                  "isPublished": isPublished,
                  "option2": _option2TextController.text,
                  "option3": _option3TextController.text,
                  "option4": _option4TextController.text,
                  "solution": _solutionTextController.text,
                };
              }
              setState(() {
                isLoading = true;
              });
              await _apiRepositoryImplmentation
                  .saveQuestion(data)
                  .then((result) {
                String message = '';
                if (result == 'Question updated successfully') {
                  setState(() {
                    message = "Question updated successfully";
                    isLoading = false;
                  });
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return ThemeHelper()
                            .alartDialog("Hurray", message, context);
                      }));
                }
                if (result == 'Question added successfully') {
                  setState(() {
                    message = "Question Created successfully";
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
