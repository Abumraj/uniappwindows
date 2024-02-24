import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_case/file_case.dart';
import 'package:flutter/material.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:dio/dio.dart' as d;
import 'package:fluent_ui/fluent_ui.dart' as f;

class VideoUploader extends StatefulWidget {
  final int chapterId;
  final int? videoId;
  final String? videoUrl;

  const VideoUploader({
    Key? key,
    required this.chapterId,
    this.videoId,
    this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoUploader> createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  final TextEditingController _videoNameTextController =
      TextEditingController();

  final TextEditingController _descriptionTextController =
      TextEditingController();
  bool isLoaing = false;
  String message = '';
  int is_published = 0;
  bool preview = false;
  final firstController = FileCaseController(
      filePickerOptions: FilePickerOptions(
        withData: true,
        withReadStream: true,
        type: FileType.video,
        //  allowedExtensions:[],
      ),
      tag: 'controller4');
  Player player = Player(id: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Video"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: isLoaing
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ThemeHelper().progressBar2(),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(message)
                    ],
                  )
                : ListView(
                    scrollDirection: Axis.vertical,
                    semanticChildCount: 14,
                    children: [
                        const SizedBox(
                          height: 20,
                        ),
                        f.TextBox(
                          controller: _videoNameTextController,
                          placeholder: "E.g Video name here",
                          //header: "Video name",
                          minLines: 1,
                          maxLines: 5,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        f.TextBox(
                          controller: _descriptionTextController,
                          placeholder: "video description here",
                          //header: "Video Description",
                          minLines: 3,
                          maxLines: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: !preview
                                ? FileCase(
                                    tag: firstController.tag,
                                  )
                                : AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Video(
                                      player: player,
                                    ))),
                        FileUploadButton(tag: firstController.tag),
                        const SizedBox(
                          height: 20,
                        ),
                        f.ToggleSwitch(
                            checked: is_published == 1 ? true : false,
                            onChanged: (value) {
                              if (is_published == 0) {
                                setState(() {
                                  is_published = 1;
                                });
                              } else {
                                setState(() {
                                  is_published = 0;
                                });
                              }
                            },
                            content: const Text("isPublished")),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    preview = false;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  if (preview == false) {
                                    setState(() {
                                      player.open(
                                          Media.file(
                                            File(firstController
                                                .files.single.path!),
                                          ),
                                          autoStart: false);
                                      preview = true;
                                    });
                                  } else {
                                    player.dispose();
                                    var pickedFile = firstController.files;
                                    if (pickedFile.isNotEmpty) {
                                      setState(() {
                                        isLoaing = true;
                                        message = 'Processing File';
                                      });
                                      final formData = d.FormData.fromMap({
                                        'videoFile':
                                            await d.MultipartFile.fromFile(
                                                pickedFile.single.path!,
                                                filename:
                                                    pickedFile.single.name),
                                        'videoName':
                                            _videoNameTextController.text,
                                        'videoDescript':
                                            _descriptionTextController.text,
                                        'videoSize': pickedFile.single.size,
                                      });
                                      // print(" ${File(fileBytes).path}.xlsx");
                                      setState(() {
                                        message = 'Uploading File';
                                      });
                                      _apiRepositoryImplmentation
                                          .uploadVideo(formData)
                                          .then((value) {
                                        if (value ==
                                            'Video uploaded successfully') {
                                          setState(() {
                                            isLoaing = false;
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return ThemeHelper().alartDialog(
                                                      "Hurray",
                                                      "Video uploaded successfully",
                                                      context);
                                                }));
                                          });
                                        } else {
                                          setState(() {
                                            isLoaing = false;

                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return ThemeHelper()
                                                      .alartDialog(
                                                          "Oops",
                                                          "An Error Occurred",
                                                          context);
                                                }));
                                          });
                                        }
                                      });
                                    }
                                  }
                                },
                                child: Text(preview ? "Upload" : "Preview")),
                          ],
                        )
                      ])),
      ),
    );
  }
}
