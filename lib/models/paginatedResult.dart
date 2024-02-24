import 'package:ulms/models/paginationModel.dart';
import 'package:ulms/models/testResultModel.dart';

class PaginatedResult {
  Pagination pagination;
  List<TestResult> testResult;
  PaginatedResult({required this.pagination, required this.testResult});
}
