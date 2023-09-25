import 'package:gsheets/gsheets.dart';
import 'dart:developer' as dev;

import '../gsheets_api.dart';
import '../models/user_model.dart';

class UsersWSheet {
  static String sheetName = 'Users';
  static List<String> columnName = [
    'id',
    'name',
    'email',
    'phone_number',
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

  static Future<bool> insertUser({required UsersModel product}) async {
    final id = await GsheetsAPI.getRowCount(worksheet: worksheet);
    final listJson = [product.copyWith(id: id).toJson()];
    return await GsheetsAPI.insert(listJson, worksheet: worksheet);
  }

  static Future<UsersModel?> getUserById({required int id}) async {
    final json = await GsheetsAPI.getDataById(id, worksheet: worksheet);
    if (json == null) dev.log('user not found');
    return json == null ? null : UsersModel.fromJson(json);
  }

  static Future<List<UsersModel>> getAllUser() async {
    final listJson = await GsheetsAPI.getAllData(worksheet: worksheet);
    return listJson.map(UsersModel.fromJson).toList();
  }

  static Future<bool> updateUser(
      {required int id, required UsersModel user}) async {
    return await GsheetsAPI.update(id, user.toJson(), worksheet: worksheet);
  }

  static Future<bool> deleteUser({required int id}) async {
    return await GsheetsAPI.deleteById(id, worksheet: worksheet);
  }
}
