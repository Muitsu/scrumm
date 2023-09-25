import 'dart:convert';

class UsersModel {
  int? id;
  String name;
  String email;
  String phoneNo;

  UsersModel(
      {this.id,
      required this.name,
      required this.email,
      required this.phoneNo});

  UsersModel.fromJson(Map<String, dynamic> json)
      : id = jsonDecode(json['id']),
        name = json['name'],
        email = json['email'],
        phoneNo = json['phone_number'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNo;
    return data;
  }

  UsersModel copyWith({int? id, String? name, String? email, String? phoneNo}) {
    return UsersModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phoneNo: phoneNo ?? this.phoneNo);
  }
}
