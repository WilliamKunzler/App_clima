import 'package:clima/database/db.dart';
import 'package:clima/model/city.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertCity(City clima) async {
  Database db = await getDatabase();
  return db.insert('clima', clima.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map<String, dynamic>>> findall() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('clima');
  dados.forEach((clima) {
    print(clima);
  });
  return dados;
}

Future<int> deleteByID(int id) async {
  debugPrint("Deletando o ID: $id");
  Database db = await getDatabase();
  return db.delete('clima', where: "id = ?", whereArgs: [id]);
}

Future<List<Map<String, dynamic>>> selectData(String city) async {
  debugPrint("Procurando: $city");
  Database db = await getDatabase();
  List<Map<String, dynamic>> result =
      await db.query('clima', where: "city = ?", whereArgs: [city]);
  return result;
}
