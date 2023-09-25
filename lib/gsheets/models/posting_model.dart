import 'dart:convert';

class PostingModel {
  int? id;
  int? userId;
  String? username;
  String? day;
  String? date;
  String? todayPlans;
  String? blocker;
  String? createDate;
  String? updateDate;

  PostingModel({
    this.id,
    this.userId,
    this.day,
    this.date,
    this.username,
    this.todayPlans,
    this.blocker,
    this.createDate,
    this.updateDate,
  });

  PostingModel.fromJson(Map<String, dynamic> json)
      : id = jsonDecode(json['id']),
        userId = jsonDecode(json['user_id']),
        username = json['username'],
        day = json['day'],
        date = json['date'],
        todayPlans = json['today_plans'],
        blocker = json['blocker'],
        createDate = json['createDate'],
        updateDate = json['updateDate'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['day'] = day;
    data['date'] = date;
    data['username'] = username;
    data['today_plans'] = todayPlans;
    data['blocker'] = blocker;
    data['createDate'] = createDate;
    data['updateDate'] = createDate;
    return data;
  }

  PostingModel copyWith(
      {int? id,
      int? userId,
      String? username,
      String? day,
      String? date,
      String? todayPlans,
      String? blocker,
      String? createDate,
      String? updateDate}) {
    return PostingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      day: day ?? this.day,
      date: date ?? this.date,
      todayPlans: todayPlans ?? this.todayPlans,
      blocker: blocker ?? this.blocker,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}
