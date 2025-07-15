import 'dart:convert';

List<QuotesModel> dbUpdateFromJson(String str) => List<QuotesModel>.from(json.decode(str).map((x) => QuotesModel.fromJson(x)));

class QuotesModel {
  QuotesModel({this.id, this.categoryId, this.quote, this.liked});
  int? id;
  int? categoryId;
  String? quote;
  int? liked;

  factory QuotesModel.fromJson(Map<String, dynamic> json) => QuotesModel(
        id: json["_id"],
        categoryId: json["category_id"],
        quote: json["quote"],
        liked: json["liked"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_id": categoryId,
        "quote": quote,
        "liked": liked,
      };
}
