import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';

import '../../gsheets/worksheets/posting_worksheet.dart';

class UserInfoProvider extends ChangeNotifier {
  List<PostingModel>? userPosting;
  PostingModel? todayPosting;
  fetchUserPostingById({required int userId}) async {
    userPosting = null;
    todayPosting = null;
    final results = await PostingWSheet.getAllPostingById(userId: userId);
    userPosting = results.reversed.toList();
    final todayDate = DateFormat('d MMM yyyy').format(DateTime.now());
    final todayPost =
        results.where((post) => post.date!.contains(todayDate)).toList();
    todayPosting = todayPost.isEmpty ? null : todayPost.first;
    notifyListeners();
  }
}
