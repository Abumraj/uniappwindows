import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/course_lecturer_model.dart';
import 'package:ulms/services/api_repository_implement.dart';

class AssignCourse extends StatefulWidget {
  final int courseId;
  const AssignCourse({super.key, required this.courseId});

  @override
  State<AssignCourse> createState() => _AssignCourseState();
}

class _AssignCourseState extends State<AssignCourse> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  List<CourseLecturer> courseLcturer = [];
  List<ComboBoxItem<String>> roleList = <ComboBoxItem<String>>[];
  bool isLoading = true;
  List<bool> isAssigned = [];
  List<bool> isLoading1 = [];
  var _findex;
  _getLecturer() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation.getLecturerAssigned().then((value) {
      setState(() {
        courseLcturer = value;
        print(value);
        courseLcturer.forEach((element) {
          isAssigned.add(false);
          isLoading1.add(false);
        });
        _findex = []..length = courseLcturer.length;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    roleList = getRoleDropDown();
    _getLecturer();
    super.initState();
  }

  List<ComboBoxItem<String>> getRoleDropDown() {
    List<ComboBoxItem<String>> items = [
      const ComboBoxItem(
        value: "lead_tutor",
        child: Text(
          "Coordinator",
          style: TextStyle(fontSize: 10),
        ),
        // onTap: () {},
      ),
      const ComboBoxItem(
        value: "tutor",
        child: Text(
          "Subordinate",
          style: TextStyle(fontSize: 10),
        ),
        // onTap: () {},
      ),
      const ComboBoxItem(
        value: "examiner",
        child: Text(
          "Examiner",
          style: TextStyle(fontSize: 10),
        ),
        // onTap: () {},
      ),
    ];

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(
        child: Text(
          "Assign Lecturers",
          style: context.textTheme.headlineSmall,
        ),
      ),
      content: isLoading
          ? const Center(child: ProgressRing())
          : ListView.builder(
              itemCount: courseLcturer.length,
              itemBuilder: (BuildContext context, int index) {
                CourseLecturer courseLecture = courseLcturer[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            // isThreeLine: true,
                            leading: const CircleAvatar(
                                // foregroundImage: NetworkImage(courseLecture.imageUrl!),
                                // backgroundImage: ,
                                ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${courseLecture.title!} ${courseLecture.fullName}",
                                // style: context.textTheme.titleMedium,
                              ),
                            ),
                            // subtitle: const Text(""),
                            trailing: isLoading1[index]
                                ? const SizedBox(child: ProgressRing())
                                : ToggleSwitch(
                                    checked: isAssigned[index],
                                    onChanged: ((value) async {
                                      if (_findex[index].toString() == "null") {
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return ThemeHelper().alartDialog(
                                                  "Oops",
                                                  "Kindly select Lecturer's role",
                                                  context);
                                            }));
                                      } else {
                                        var data = {
                                          "course_id": widget.courseId,
                                          _findex[index]: courseLecture.id
                                        };
                                        print(data);
                                        setState(() {
                                          isLoading1[index] = true;
                                        });
                                        await _apiRepositoryImplmentation
                                            .assignAndUnAssign(data)
                                            .then((result) {
                                          if (result ==
                                              "Lecturer UnAssigned Successfully") {
                                            setState(() {
                                              isAssigned[index] = false;
                                              isLoading1[index] = false;
                                            });
                                          }
                                          if (result ==
                                              "Lecturer Assigned Successfully") {
                                            setState(() {
                                              isAssigned[index] = true;
                                              isLoading1[index] = false;
                                            });
                                          }
                                        });
                                      }
                                    }),
                                    // content: isLoading1[index]
                                    //     ? const SizedBox(child: ProgressRing())
                                    //     : const Text(""),
                                  )),
                        ComboBox(
                          placeholder: const Text("select role"),
                          autofocus: true,
                          // isExpanded: true,
                          // itemHeight: 15,
                          iconSize: 8,
                          items: roleList,
                          value: _findex[index],
                          onChanged: ((value) {
                            setState(() {
                              _findex[index] = value;
                            });
                          }),
                   popupColor       : Colors.successPrimaryColor,
                        ),
                      ],
                    ),
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
