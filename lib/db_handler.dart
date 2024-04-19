import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Model.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DbHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null || !_db!.isOpen) {
      await initDb();
    }
    return _db!;
  }

  Future<dynamic> initDb() async {
    if (kIsWeb) {
      return ('This app does not support web');
    }
    Directory documentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo.db");
    _db = await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute("CREATE TABLE todo (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "title TEXT, " +
        "description TEXT, " +
        "dateandtime TEXT null " +
        ")");
  }

  Future<TodoModel> insert(TodoModel row) async {
    var dbClient = await db;
    row.id = await dbClient.insert("todo", row.toMap());
    return row;
  }

  Future<List<TodoModel>> getTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query("todo");
    return List.generate(list.length, (index) {
      return TodoModel.fromMap(list[index]);
    });
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete("todo", where: "id = ?", whereArgs: [id]);
  }

  Future<int> update(TodoModel row) async {
    var dbClient = await db;
    return await dbClient
        .update("todo", row.toMap(), where: "id = ?", whereArgs: [row.id]);
  }
}
