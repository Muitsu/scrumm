import 'package:flutter/material.dart';
import 'package:scrumm/gsheets/models/user_model.dart';
import 'package:scrumm/gsheets/worksheets/user_worksheet.dart';
import 'dart:developer' as dev;

class MemberProvider extends ChangeNotifier {
  List<UsersModel>? allUser;
  fetchAllMembers() async {
    try {
      final users = await UsersWSheet.getAllUser();
      allUser = users;
    } catch (e) {
      dev.log(e.toString());
      allUser = [];
    }
    notifyListeners();
  }
}
