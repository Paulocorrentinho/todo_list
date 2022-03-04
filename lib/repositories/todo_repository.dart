import 'dart:convert';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list2/models/todo.dart';

const todolistKey = 'todo_list';

class TodoRepository {

  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todolistKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;     //convert json para string
    return jsonDecoded.map((e) => Todo.fromjson(e)).toList();     //converte json para map e de map para lista
  }

  void saveTodoList(List<Todo> todos) {
    final String jsonString = json.encode(todos);     //converte a lista em json
    sharedPreferences.setString(todolistKey, jsonString);     //armazena a lista em json
  }

}