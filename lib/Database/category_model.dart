import 'dart:convert';

List<DbUpdateModel> dbUpdateFromJson(String str) => List<DbUpdateModel>.from(
    json.decode(str).map((x) => DbUpdateModel.fromJson(x)));

class DbUpdateModel {
  DbUpdateModel({this.id, this.name, this.total});

  int? id;
  String? name;
  int? total;

  factory DbUpdateModel.fromJson(Map<String, dynamic> json) => DbUpdateModel(
        id: json["_id"],
        name: json["name"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "total": total,
      };
}
