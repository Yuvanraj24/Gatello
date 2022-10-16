import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUpdate {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

    Future <String> getName(String uid) async {
    final db = await database;
    List<Map<String,Object?>>? list = await db?.rawQuery("SELECT * FROM Gatello WHERE uid='${uid}'");
    print(list);
    String name = "";
    list?.forEach((element) {
      name = element["name"].toString();
      print(element["name"]);
    });
    return name;
  }

  writeDb(String name, String uid, String phone) async {
    final db = await database;
    var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM Gatello");
    Object? id = table?.first["id"];
    print("ID:${id}");

    var raw = await db!.rawInsert(
        "INSERT Into Gatello (id,uid,name,phone)"
            " VALUES (?,?,?,?)",
        [id, "${uid}", "${name}", "${phone}"]);

    print("RAW:${raw}");
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Gatello.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Gatello ("
              "id INTEGER PRIMARY KEY,"
              "uid TEXT,"
              "name TEXT,"
              "phone TEXT"
              ")");
        });
  }



}
