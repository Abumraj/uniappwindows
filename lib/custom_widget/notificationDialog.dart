import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/services/api_repository_implement.dart';

class CourseEditDialog extends StatefulWidget {
  final String? title;
  const CourseEditDialog({Key? key, required this.title}) : super(key: key);

  @override
  State<CourseEditDialog> createState() => _CourseEditDialogState();
}

class _CourseEditDialogState extends State<CourseEditDialog> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _linkTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(
          child: Text(widget.title.toString() != "null"
              ? "${widget.title} Notification"
              : "Send Notification")),
      content: isLoading
          ? const ProgressRing()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextBox(
                                  controller: _emailTextController,
                                  maxLines: 2,
                                  //header: "Subject",
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextBox(
                                  controller: _passwordTextController,
                                  minLines: 5,
                                  maxLines: 10,
                                  //header: "Description",
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextBox(
                                  controller: _linkTextController,
                                  maxLines: 2,
                                  //header: "Link(Optional)",
                                  placeholder: "E.g www.unilorin.edu.ng",
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                // margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    // Get.to(ForgotPassword());
                                  },
                                  child: const Text(
                                    "Powered by: UniApp",
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        Button(
          autofocus: true,
          onPressed: () async {
            var data;
            // print(data);
            if (widget.title != null) {
              data = {
                "topicName": widget.title,
                "body": _passwordTextController.text,
                "title": "${widget.title}: ${_emailTextController.text}",
                "link": _linkTextController.text,
              };
            } else {
              data = {
                "body": _passwordTextController.text,
                "title": "${widget.title}: ${_emailTextController.text}",
                "link": _linkTextController.text,
              };
            }
            setState(() {
              isLoading = true;
            });
            await _apiRepositoryImplmentation
                .sendNotification(data)
                .then((result) {
              String message = '';
              if (result == 'Notification sent successfully') {
                setState(() {
                  message = "Notification sent successfully";
                  isLoading = false;
                });
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ThemeHelper()
                          .alartDialog("Hurray", message, context);
                    }));
              }
              if (result == 'An error occurred') {
                setState(() {
                  message = "An error occurred";
                  isLoading = false;
                });
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ThemeHelper()
                          .alartDialog("Oops", message, context);
                    }));
              }
            });
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
