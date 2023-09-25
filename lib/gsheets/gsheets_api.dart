import 'package:gsheets/gsheets.dart';
import 'package:scrumm/gsheets/worksheets/posting_worksheet.dart';
import 'package:scrumm/gsheets/worksheets/user_worksheet.dart';
import 'dart:developer' as dev;

import 'gsheets_constant.dart';

class GsheetsAPI {
  // Singleton instance
  static final GsheetsAPI _instance = GsheetsAPI._internal();
  factory GsheetsAPI() => _instance;
  GsheetsAPI._internal();

  static final _gsheets = GSheets(GsheetsConstants.credentials);
  static Spreadsheet? spreadsheet;

  static Future init({required String spreadsheetId}) async {
    spreadsheet = await _gsheets.spreadsheet(spreadsheetId);
    /*-------------------------CREATE/RETRIEVE SHEET--------------------------------*/
    await UsersWSheet.create();
    await PostingWSheet.create();
    //Add yours here
  }

  static Future<Worksheet> getWorkSheet({required String title}) async {
    //if worksheet not exist it will create worksheet
    try {
      return await spreadsheet!.addWorksheet(title);
    } catch (e) {
      return spreadsheet!.worksheetByTitle(title)!;
    }
  }

  static String initErr =
      'Worksheet not initialized: add await on init() function';
  static Future<bool> insert(List<Map<String, dynamic>> listJson,
      {required Worksheet? worksheet}) async {
    if (worksheet == null) {
      dev.log(initErr);
      return false;
    }
    return await worksheet.values.map.appendRows(listJson);
  }

  static Future<int> getRowCount({required Worksheet? worksheet}) async {
    if (worksheet == null) {
      dev.log(initErr);
      return 0;
    }
    final lastRow = await worksheet.values.lastRow();
    int result = lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
    return result + 1;
  }

  static Future<Map<String, String>?> getDataById(int id,
      {required Worksheet? worksheet}) async {
    if (worksheet == null) {
      dev.log(initErr);
      return null;
    }
    final json = await worksheet.values.map.rowByKey(id, fromColumn: 1);
    return json;
  }

  static Future<List<Map<String, String>>> getAllData(
      {required Worksheet? worksheet}) async {
    if (worksheet == null) {
      dev.log(initErr);
      return [];
    }
    final json = await worksheet.values.map.allRows();
    return json ?? [];
  }

  static Future<bool> update(int id, Map<String, dynamic> json,
      {required Worksheet? worksheet}) async {
    if (worksheet == null) {
      dev.log(initErr);
      return false;
    }
    return worksheet.values.map.insertRowByKey(id, json);
  }

  static Future<bool> deleteById(int id,
      {required Worksheet? worksheet}) async {
    if (worksheet == null) {
      dev.log(initErr);
      return false;
    }
    int index = await worksheet.values.rowIndexOf(id);
    if (index == -1) return false;
    return worksheet.deleteRow(index);
  }
}
