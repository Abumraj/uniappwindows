import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/services/api_repository_implement.dart';

class EditDialog extends StatefulWidget {
  final String title;
  final String chatLink;
  final int courseId;
  const EditDialog(
      {Key? key,
      required this.title,
      required this.chatLink,
      required this.courseId})
      : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  final TextEditingController _emailTextController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    _emailTextController.text = widget.chatLink;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
        title: Center(child: Text(widget.title)),
        content: isLoading
            ? const ProgressRing()
            : TextBox(
                controller: _emailTextController,
                maxLines: 2,
                placeholder: "Chat Link",
              ),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          Button(
            autofocus: true,
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _apiRepositoryImplmentation
                  .editCourse(widget.courseId, _emailTextController.text)
                  .then((value) {
                setState(() {
                  isLoading = false;
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return ThemeHelper()
                            .alartDialog(widget.title, value, context);
                      }));
                });
              });
            },
            child: const Text('Send'),
          ),
        ]);
  }
}
