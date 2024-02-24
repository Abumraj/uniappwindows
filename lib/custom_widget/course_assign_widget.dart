import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:ulms/models/course_lecturer_model.dart';
import 'package:ulms/services/constant.dart';
import '../services/api_repository_implement.dart';

class CourseAssignWidget extends StatefulWidget {
  final String title;
  final int courseId;
  final bool isHod;
  const CourseAssignWidget(
      {Key? key,
      required this.title,
      required this.courseId,
      required this.isHod})
      : super(key: key);
  @override
  State<CourseAssignWidget> createState() => _CourseAssignWidgetState();
}

class _CourseAssignWidgetState extends State<CourseAssignWidget> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  List<CourseLecturer> courseLcturer = [];
  List<bool> isAssigned = [];
  List<bool> isLoading1 = [];
  bool isLoading = true;
  _getLecturer() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation
        .getcourseLecturers(widget.courseId)
        .then((value) {
      setState(() {
        courseLcturer = value;
        // print(courseLcturer.first.fullName);
        courseLcturer.forEach((element) {
          isAssigned.add(true);
          isLoading1.add(false);
        });
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _getLecturer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(
        child: Text(
          "${widget.title} Lecturers",
          style: context.textTheme.headlineSmall,
        ),
      ),
      content: isLoading
          ? const Center(child: ProgressRing())
          : courseLcturer.isEmpty
              ? const Center(
                  child:
                      Text("You have not assigned any lecturer to this course"),
                )
              : ListView.builder(
                  itemCount: courseLcturer.length,
                  itemBuilder: (BuildContext context, int index) {
                    CourseLecturer courseLecture = courseLcturer[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        borderRadius: BorderRadius.circular(15),
                        child: ListTile(
                            leading: const CircleAvatar(
                                // foregroundImage: NetworkImage(courseLecture.imageUrl!),
                                // backgroundImage: ,
                                ),
                            title: Text(
                              "${courseLecture.title!} ${courseLecture.fullName}",
                              // style: context.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              courseLecture.role.toString() == "lead-tutor"
                                  ? "Coordinator"
                                  : courseLecture.role.toString() == "examiner"
                                      ? "Examiner"
                                      : "Subordinate",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: !widget.isHod
                                ? Checkbox(
                                    // style: const CheckboxThemeData(checkedIconColor: ,
                                    checked: true,
                                    onChanged: ((value) {}))
                                : ToggleSwitch(
                                    checked: isAssigned[index],
                                    onChanged: ((value) async {
                                      var data = {
                                        "course_id": widget.courseId,
                                        courseLecture.role.toString() ==
                                                "lead-tutor"
                                            ? "lead_tutor"
                                            : courseLecture.role.toString() ==
                                                    "examiner"
                                                ? "Examiner"
                                                : "tutor": courseLecture.id
                                      };
                                      setState(() {
                                        isLoading1[index] = true;
                                      });
                                      await _apiRepositoryImplmentation
                                          .assignAndUnAssign(data)
                                          .then((result) {
                                        setState(() {
                                          isAssigned[index] = value;
                                          isLoading1[index] = false;
                                        });
                                      });
                                    }),
                                    content: isLoading1[index]
                                        ? const ProgressRing()
                                        : const Text(""),
                                  )),
                      ),
                    );
                  }),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
