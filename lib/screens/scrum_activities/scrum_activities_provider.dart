import 'package:flutter/material.dart';

import '../../gsheets/models/user_model.dart';
import '../../gsheets/worksheets/posting_worksheet.dart';
import '../../gsheets/worksheets/user_worksheet.dart';

class ScrumActivitiesProvider extends ChangeNotifier {
  List<UsersModel>? allUser;
  List<UsersModel>? userEnable;
  List<UsersModel>? userDisable;

  fetchAllUsers() async {
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
}
