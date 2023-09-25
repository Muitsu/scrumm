import 'package:gsheets/gsheets.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import '../gsheets_api.dart';

class PostingWSheet {
  static String sheetName = 'Daily Scrum';
  static List<String> columnName = [
    'id',
    'user_id',
    'username',
    'day',
    'date',
    'today_plans',
    'blocker',
    'createDate',
    'updateDate',
  ];
  static Worksheet? worksheet;

  static Future create() async {
    try {
      worksheet = await GsheetsAPI.getWorkSheet(title: sheetName);
      worksheet!.values.insertRow(1, columnName);
    } catch (e) {
      dev.log('Failed Initialize $e');
    }
  }

  static Future<bool> insertPosting({required PostingModel posting}) async {
    final id = await GsheetsAPI.getRowCount(worksheet: worksheet);
    final currDate = DateTime.now();
    final currDay = DateFormat('EEEE').format(currDate);
    final date = DateFormat('d MMM yyyy').format(currDate);
    final postData = posting.copyWith(
      id: id,
      day: currDay,
      date: date,
      createDate: currDate.toString(),
      updateDate: currDate.toString(),
    );
    final listJson = [postData.toJson()];
    return await GsheetsAPI.insert(listJson, worksheet: worksheet);
  }

  static Future<PostingModel?> getPostingById({required int id}) async {
    final json = await GsheetsAPI.getDataById(id, worksheet: worksheet);
    if (json == null) dev.log('posting not found');
    return json == null ? null : PostingModel.fromJson(json);
  }

  static Future<List<PostingModel>> getAllPosting() async {
    final listJson = await GsheetsAPI.getAllData(worksheet: worksheet);
    return listJson.map(PostingModel.fromJson).toList();
  }

  static Future<List<PostingModel>> getAllPostingById(
      {required int userId}) async {
    final listJson = await GsheetsAPI.getAllData(worksheet: worksheet);
    final allPost = listJson.map(PostingModel.fromJson).toList();
    final filterPost = allPost.where((post) => post.userId == userId).toList();
    return filterPost;
  }

  static Future<List<PostingModel>> getTodayPosting() async {
    final listJson = await GsheetsAPI.getAllData(worksheet: worksheet);
    final allPost = listJson.map(PostingModel.fromJson).toList();
    final todayDate = DateFormat('d MMM yyyy').format(DateTime.now());
    final filterPost =
        allPost.where((post) => post.date!.contains(todayDate)).toList();
    return filterPost;
  }

  static Future<List<PostingModel>> getAllUserPosting(
      {required int userId}) async {
    final listJson = await GsheetsAPI.getAllData(worksheet: worksheet);
    final allPost = listJson.map(PostingModel.fromJson).toList();
    final todayDate = DateTime.now().toString().split(' ')[0];
    final filterPost = allPost
        .where(
            (post) => post.date!.contains(todayDate) && post.userId == userId)
        .toList();
    return filterPost;
  }

  static Future<bool> updatePosting({required PostingModel posting}) async {
    return await GsheetsAPI.update(posting.id!, posting.toJson(),
        worksheet: worksheet);
  }

  static Future<bool> deletePost({required PostingModel posting}) async {
    return await GsheetsAPI.deleteById(posting.id!, worksheet: worksheet);
  }
}
