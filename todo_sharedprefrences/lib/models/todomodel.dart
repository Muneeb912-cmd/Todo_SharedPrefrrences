import 'dart:convert';

List<todomodel> postModelFromJson(String str) =>
    List<todomodel>.from(json.decode(str).map((x) => todomodel.fromJson(x)));

String postModelToJson(List<todomodel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class todomodel {
  todomodel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
  });
  int id;
  String title;
  String date;
  String description;

  factory todomodel.fromJson(Map<String, dynamic> json) => todomodel(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      description: json['description']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "description": description,
      };
}
