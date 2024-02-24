import 'package:fluent_ui/fluent_ui.dart';
import 'package:ulms/models/notificationModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:url_launcher/url_launcher.dart';

class MyNotification extends StatefulWidget {
  MyNotification({Key? key}) : super(key: key);

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  List<NotificationFcm> courses = [];
  bool isLoading = true;

  _getParameter() async {
    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation.getMyNotification().then((value) {
      setState(() {
        courses = value;
        isLoading = false;
      });
    });
  }

  static void joinTelegramGroupChat(String message) async {
    try {
      if (await canLaunchUrl(Uri.parse(message))) {
        await launchUrl(Uri.parse(message), mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      print(e);
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
      header: const Center(
          child: Text(
        'Notification',
        style: TextStyle(fontSize: 25),
      )),
      content: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          NotificationFcm notify = courses[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 100,
            height: 80,
            child: ListTile(
                // isThreeLine: true,
                title: Text(
                  notify.title.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  children: [
                    Text(notify.body.toString()),
                  ],
                ),
                leading: notify.image.toString() != "null"
                    ? CircleAvatar(
                        foregroundImage: NetworkImage(notify.image!),
                        // radius: 60,
                      )
                    : const CircleAvatar(),
                trailing: Column(
                  children: [
                    notify.link.toString() != "null" && notify.link!.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              if (notify.link.toString() != "null") {}
                            },
                            child: Button(
                              onPressed: () {
                                // print(notify.link!.isEmpty);
                                joinTelegramGroupChat(notify.link!);
                              },
                              child: const Text(
                                "Read More",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))
                        : Container(),
                    Text(
                      DateTime.parse(
                        notify.time.toString(),
                      ).toLocal().toString(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
