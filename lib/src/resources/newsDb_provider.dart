import 'dart:io';

import 'package:fluttercourse/src/models/item_model.dart';
import 'package:fluttercourse/src/resources/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NewsDbProvider implements Source, Cache {
  late Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = documentsDirectory.path + 'items.db';
    db = await openDatabase(path, version: 1, onCreate: (Database newDb, int version) {
      newDb.execute('''
      CREATE TABLE Items
       (
         id INTEGER PRIMARY KEY,
         type TEXT,
         by TEXT,
         time INTEGER,
         text TEXT, 
         parent INTEGER,
         kids BLOB,
         dead INTEGER,
         deleted INTEGER,
         url TEXT, 
         score INTEGER,
         title TEXT,
         descendants INTEGER
       )
      ''');
    });
  }

  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert('Items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clear() {
    return db.delete('Items');
  }

  @override
  Future<List<int>> fetchTopIds() {
    return Future.value([1]);
  }
}

final newsDbProvider = NewsDbProvider();
