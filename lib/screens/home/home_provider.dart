import 'package:flutter/material.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';
import 'package:scrumm/gsheets/worksheets/user_worksheet.dart';

import '../../gsheets/worksheets/posting_worksheet.dart';

class HomeProvider extends ChangeNotifier {
  List<PostingModel>? postings;
  String totalUser = '0';
  String totalPost = '0';
  int currentPage = 0;

  fetchTodayPosting() async {
    final totPost = await PostingWSheet.getTodayPosting();
    final totUser = await UsersWSheet.getAllUser();
    postings = totPost;
    totalUser = totUser.length.toString();
    totalPost = totPost.length.toString();
    notifyListeners();
  }

  changePage(BuildContext context, {required int index}) async {
    currentPage = index;
    bool canPop = Navigator.canPop(context);
    if (canPop) {
      Navigator.pop(context);
    }
    notifyListeners();
  }
}
