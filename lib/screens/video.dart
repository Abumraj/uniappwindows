import 'package:fluent_ui/fluent_ui.dart';

import 'package:get/get.dart';
import 'package:ulms/custom_widget/videoUploader.dart';

class VideoInfo extends StatefulWidget {
  final int? chapterId;
  final String? chapterName;
  const VideoInfo({super.key, this.chapterId, this.chapterName});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
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
              "${widget.chapterName}: Videos",
              style: context.textTheme.titleLarge,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                child: const Text("Upload"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return VideoUploader(
                          chapterId: widget.chapterId!,
                        );
                      }));
                }),
          ),
        ],
      ),

      // content: ,
    );
  }
}
