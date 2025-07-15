
import 'dart:math';

import 'package:app/Database/quotes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'category_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const databaseName = "quotes.db";
  static const databaseVersion = 1;
  static const dbUpdateTable = 'category';
  static const dbUpdateTable1 = 'quotes';
  Future<List<DbUpdateModel>> getDbUpdateList() async {
    try {
      Database db = await database;
      var queryResult = await db.rawQuery(
          'SELECT c._id,c.name,COUNT(q.category_id) as total FROM $dbUpdateTable c LEFT JOIN $dbUpdateTable1 q ON c._id=q.category_id GROUP BY c._id ORDER BY c.name ASC');
      return queryResult.map((e) => DbUpdateModel.fromJson(e)).toList();
    } catch (e) {
      print('Error executing query: $e');
      return []; // Return an empty list or handle the error appropriately
    }
  }

  Future<int> updateQuoteLikedStatus(int id, int liked) async {
    try {
      Database db = await database;
      return await db.update(
        dbUpdateTable1, // Use the quotes table name
        {'liked': liked},
        where: '_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating quote liked status: $e');
      return 0;
    }
  }

  Future<List<QuotesModel>> getLikedQuotes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'quotes', where: 'liked = ?', whereArgs: [1]);

    return List.generate(maps.length, (i) {
      return QuotesModel(
        id: maps[i]['id'],
        quote: maps[i]['quote'],
        liked: maps[i]['liked'],
      );
    }
    );
  }

  Future<List<QuotesModel>> getDbUpdateList1(int id) async {
    Database db = await database;
    var queryResult = await db.rawQuery('SELECT * FROM $dbUpdateTable1 where category_id = $id');
    return queryResult.map((e) => QuotesModel.fromJson(e)).toList();
  }

  Future<QuotesModel> getRandomQuote() async {
    final db = await database;
    final List<Map<String, dynamic>> quotes = await db.query(dbUpdateTable1);
    if (quotes.isEmpty);
    final randomIndex = Random().nextInt(quotes.length);
    return QuotesModel.fromJson(quotes[randomIndex]);
  }



  Future<List<QuotesModel>> getDbUpdateList2() async {
    Database db = await database;
    var queryResult = await db.rawQuery('SELECT * FROM $dbUpdateTable1 ORDER BY RANDOM() LIMIT 1');
    return queryResult.map((e) => QuotesModel.fromJson(e)).toList();
  }

  Future<int?> getTotalRecord(int id) async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $dbUpdateTable1 where category_id = $id'));
    return count;
  }

  Future<Database> get database async {
    _database ??= await initializedDB();
    return _database!;
  }

  Future<Database> initializedDB() async {
    String path = join(await getDatabasesPath(), databaseName);
    var notesDatabase = await openDatabase(path, version: databaseVersion, onCreate: null);
    return notesDatabase;
  }
}
