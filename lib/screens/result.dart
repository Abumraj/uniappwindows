import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class TestResultByTest extends StatefulWidget {
  const TestResultByTest({super.key});

  @override
  State<TestResultByTest> createState() => _TestResultByTestState();
}

class _TestResultByTestState extends State<TestResultByTest> {
  // final tableController = PagedDataTableController<String, TestResult>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Result"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
