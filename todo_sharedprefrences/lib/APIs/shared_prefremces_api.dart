import 'dart:convert';

import 'package:todo_sharedprefrences/models/todomodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key = 'todo_list';

class shared_pref_api {
  //get list Method
  Future<List<todomodel>> getList() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final jsonString = sf.getString(key) ?? '[]';
    final jsonDecoded = json.decode(jsonString) as List;

    return jsonDecoded
        .map(
          (e) => todomodel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  //save list
  void saveList(List<todomodel> todos) async {
    final stringJson = json.encode(todos);
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setString(key, stringJson);
  }

  //update List
  void updateList(List<todomodel> todos, int id, String title, String date,
      String description) async {
    for (var i in todos) {
      if (i.id == id) {
        i.title = title;
        i.date = date;
        i.description = description;
      }
    }
    saveList(todos);    
  }
}
