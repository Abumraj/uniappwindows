import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/programModel.dart';
import 'package:ulms/models/questionModel.dart';
import 'package:ulms/screens/login.dart';
import 'package:ulms/services/constant.dart';

class ProgramSelection extends StatefulWidget {
  const ProgramSelection({super.key});

  @override
  State<ProgramSelection> createState() => _ProgramSelectionState();
}

class _ProgramSelectionState extends State<ProgramSelection> {
  List<School> items = [];
  List<Question> questions = [];
  bool isLoading = false;
  Dio dio = Dio();

  _getPortal() async {
    setState(() {
      isLoading = true;
    });
    await _getSchool().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _getQuestionAndLoad() async {
    setState(() {
      isLoading = true;
    });
    await _getQuestion().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<List<School>> _getSchool() async {
    try {
      final response = await dio.get(
        "https://uniappdigitalsoluttions.com.ng/api/school",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }),
      );
      if (200 == response.statusCode) {
        items = parsedSchool(response.data);
        return items;
      } else {
        return response.data;
      }
    } catch (e) {
      print(e);
      return []; // return an empty list on exception/error
    }
  }

  Future _createEcelSheet() async {
    try {
      var excel = Excel.createExcel();
      var sheet = excel['Exam'];
      excel.delete('Sheet1');

      sheet.cell(CellIndex.indexByString('A1')).value = 'question';
      sheet.cell(CellIndex.indexByString('B1')).value =
          'Option1(Correct Answer)';
      sheet.cell(CellIndex.indexByString('C1')).value = 'option2';
      sheet.cell(CellIndex.indexByString('D1')).value = 'option3';
      sheet.cell(CellIndex.indexByString('E1')).value = 'option4';
      sheet.cell(CellIndex.indexByString('F1')).value = 'solution';
      for (var x = 0; x < questions.length - 1; x++) {
        sheet.cell(CellIndex.indexByString('A${x + 2}')).value =
            questions[x].question;
        sheet.cell(CellIndex.indexByString('B${x + 2}')).value =
            questions[x].option1;
        sheet.cell(CellIndex.indexByString('C${x + 2}')).value =
            questions[x].option2;
        sheet.cell(CellIndex.indexByString('D${x + 2}')).value =
            questions[x].option3;
        sheet.cell(CellIndex.indexByString('E${x + 2}')).value =
            questions[x].option4;
        sheet.cell(CellIndex.indexByString('F${x + 2}')).value =
            questions[x].solution;
      }
      var fileBytes = excel.save();
      var directory = await getDownloadsDirectory();
      var pathList = directory!.path.split('\\');
      pathList[pathList.length - 1] = 'Downloads';
      var downloadPath = pathList.join('\\');
      // print("this is the picture  $downloadPath");
      if (fileBytes != null) {
        p.join(downloadPath, 'UniApp', 'Gns111', 'Questions').createPath();
        File(p.join(downloadPath, 'UniApp', 'Gns111', 'Questions', 'Exam.xlsx'))
          ..create(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
    } catch (e) {
      return 'An error Occurred';
    }
  }
  // The Schwa _ə_ Sound - Endings British Pronunciation & Spelling Tips _ -er -ar -or -our -ure -re.mp4
  // Types of Phrases _ 7 Types _ English Grammar _ Syntax.mp4
  // Sentence Stress in English Pronunciation.mp4
  // -ED pronunciation - _t_ _d_ or _id__ (pronounce PERFECTLY every time!) (+ Free PDF & Quiz).mp4
  // Advanced English Grammar_ Clauses.mp4
  // How to Pronounce the Irregular Verbs in British Accent_ British English Pronunciation.mp4
  // Syllables and Word Stress - English Pronunciation Lesson.mp4
  // Silent Letters in English A to Z with ALL RULES _ British Accents and Pronunciation (1).mp4
  // Subject Verb Agreement _ English Lesson _ Common Grammar Mistakes.mp4
  // 4 Sentence Structures _ Easy Explanation _ Learn with Examples.mp4

  Future<List<Question>> _getQuestion() async {
    try {
      final response = await dio.get(
        "http://127.0.0.1:8000/api/question/21",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }),
      );
      if (200 == response.statusCode) {
        questions = parsedQuestion(response.data);
        print(questions);
        return questions;
      } else {
        return response.data;
      }
    } catch (e) {
      print(e);
      return []; // return an empty list on exception/error
    }
  }

  static List<School> parsedSchool(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<School>((json) => School.fromJson(json)).toList();
  }

  static List<Question> parsedQuestion(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  @override
  void initState() {
    // _getPortal();
    _getQuestionAndLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : items.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: 100,
                                child: MaterialButton(
                                    padding: const EdgeInsets.all(5.0),
                                    elevation: 3.0,
                                    height: 30,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          items[index].schoolName.toString(),
                                          textAlign: TextAlign.center,
                                          selectionColor: Colors.white,
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      Constants.saveUserSchoolSharedPreference(
                                          items[index].schoolUrl.toString());
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const Login(),
                                      ));
                                    }),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'Sign In'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          // _getPortal();
                          _createEcelSheet();
                        },
                      ),
                    ),
                  ));
  }
}
// Container(
//           color: Colors.white,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             dragStartBehavior: DragStartBehavior.down,
//             semanticChildCount: 4,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: 
//               )
//             ],
//           )),
    