import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_case/file_case.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as d;
import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/services/api_repository_implement.dart';

class FileUploaderUi2 extends StatefulWidget {
  final int chapterId;
  final String chapterName;
  const FileUploaderUi2(
      {Key? key, required this.chapterId, required this.chapterName})
      : super(key: key);

  @override
  State<FileUploaderUi2> createState() => _FileUploaderUi2State();
}

class _FileUploaderUi2State extends State<FileUploaderUi2> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoaing = false;
  String message = '';
  int is_published = 0;
  final firstController = FileCaseController(
      filePickerOptions: FilePickerOptions(
        withData: true,
        withReadStream: true,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      ),
      tag: 'controller2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload your xlsx file"),
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FileCase(
                        tag: firstController.tag,
                      ),
                    ),
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
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              var fileBytes;
                              var pickedFile = firstController.files;
                              if (pickedFile.isNotEmpty) {
                                setState(() {
                                  isLoaing = true;
                                  message = 'Processing File';
                                });
                                var bytes = pickedFile.single.path;

                                var readByteAsync =
                                    File(bytes!).readAsBytesSync();
                                var excel = Excel.decodeBytes(readByteAsync);
                                for (var table in excel.tables.keys) {
                                  excel.tables[table]!
                                      .cell(CellIndex.indexByString('F1'))
                                      .value = 'test_id';
                                  excel.tables[table]!
                                      .cell(CellIndex.indexByString('G1'))
                                      .value = 'is_published';
                                  excel.tables[table]!
                                      .cell(CellIndex.indexByString('B1'))
                                      .value = 'answer';

                                  for (var x = 1;
                                      x < excel.tables[table]!.maxRows;
                                      x++) {
                                    excel.tables[table]!
                                        .cell(CellIndex.indexByString(
                                            'F${x + 1}'))
                                        .value = widget.chapterId;
                                    excel.tables[table]!
                                        .cell(CellIndex.indexByString(
                                            'G${x + 1}'))
                                        .value = is_published;
                                  }
                                  fileBytes = excel.save();

                                  var directory = await getDownloadsDirectory();
                                  var pathList = directory!.path.split('\\');
                                  pathList[pathList.length - 1] = 'Downloads';
                                  var downloadPath = pathList.join('\\');
                                  p
                                      .join(downloadPath, 'UniApp', 'AppFile')
                                      .createPath();
                                  var filePath = p.join(
                                      downloadPath,
                                      'UniApp',
                                      'AppFile',
                                      "${widget.chapterName}-modified.xlsx");
                                  File(filePath)
                                    ..create(recursive: true)
                                    ..writeAsBytesSync(fileBytes);
                                  final formData = d.FormData.fromMap({
                                    'questions': await d.MultipartFile.fromFile(
                                        filePath,
                                        filename:
                                            '${widget.chapterName}-modified.xlsx')
                                  });
                                  // print(" ${File(fileBytes).path}.xlsx");
                                  setState(() {
                                    message = 'Uploading File';
                                  });
                                  _apiRepositoryImplmentation
                                      .uploadTestQuestion(formData)
                                      .then((value) {
                                    if (value ==
                                        'Questions uploaded successfully') {
                                      setState(() {
                                        isLoaing = false;
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return ThemeHelper().alartDialog(
                                                  "Hurray",
                                                  "Questions uploaded successfully",
                                                  context);
                                            }));
                                      });
                                    } else {
                                      setState(() {
                                        isLoaing = false;
                                        var sheet = excel['Sheet1'];
                                        // excel.delete('Sheet1');

                                        sheet
                                            .cell(CellIndex.indexByString('A1'))
                                            .value = 'question';
                                        excel.delete(widget.chapterName);
                                        fileBytes = excel.save();

                                        File(filePath)
                                          ..create(recursive: true)
                                          ..writeAsBytesSync(fileBytes);

                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return ThemeHelper().alartDialog(
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
                            child: const Text("Upload")),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
