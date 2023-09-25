import 'package:flutter/material.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';
import 'package:scrumm/gsheets/models/user_model.dart';
import 'package:scrumm/gsheets/worksheets/posting_worksheet.dart';
import 'package:scrumm/gsheets/worksheets/user_worksheet.dart';

class ManagePostProvider extends ChangeNotifier {
  PostingModel? posting;
  List<UsersModel>? allUser;
  List<UsersModel>? userEnable;
  List<UsersModel>? userDisable;

  setPosting({required PostingModel post}) async {
    if (posting != null) resetPost();
    posting = post;
    notifyListeners();
  }

  getAlluser() async {
    userDisable = [];
    userEnable = [];
    final users = await UsersWSheet.getAllUser();
    final todayPosting = await PostingWSheet.getTodayPosting();
    allUser = users;

    userDisable = allUser!.where((user) {
      bool isContain = false;
      for (var post in todayPosting) {
        isContain = post.userId == user.id;
        if (isContain) {
          break;
        }
      }
      return isContain;
    }).toList();
    final tempEnable = allUser;
    tempEnable!.removeWhere(
      (user) {
        bool isContain = false;
        for (var post in todayPosting) {
          isContain = post.userId == user.id;
          if (isContain) {
            break;
          }
        }
        return isContain;
      },
    );

    if (tempEnable.isEmpty && userDisable!.isEmpty) {
      userEnable = allUser;
    } else if (tempEnable.length == allUser!.length &&
        userDisable!.length == allUser!.length) {
    } else {
      userEnable = tempEnable;
    }
    notifyListeners();
  }

  resetPost() {
    posting = null;
    notifyListeners();
  }
}
