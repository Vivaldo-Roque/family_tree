import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:family_tree/models/treemember.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'family.db'),
      version: 1,
    );
  }

  checkIfTableExists(String table) async{
    final db = await database;

    var res = await db.rawQuery('''
    
    SELECT * FROM sqlite_master WHERE name ='$table' and type='table';
    
    ''');

    if(res.length == 1)
      {
        return true;
      }
    else{
      return false;
    }

  }

  checkIfNameExists(String table, String name) async{
    final db = await database;

    var res = await db.rawQuery('''
    
    SELECT * FROM $table WHERE name ='$name';
    
    ''');

    if(res.length == 1)
    {
      return true;
    }
    else{
      return false;
    }

  }

  createNewTable(String familyName, TreeMember treeMember) async {
    final db = await database;

    String name = familyName;

    await db..execute('''
   CREATE TABLE IF NOT EXISTS $name (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   name TEXT,
   c INTEGER);
    ''')
     ..rawInsert('''
     REPLACE INTO $name (id, name, c)
      VALUES (?, ?, ?);
     ''', [treeMember.id, treeMember.name, treeMember.c]);
  }

  insertMember(TreeMember treeMember, String table) async {
    final db = await database;

    var res = await db.rawInsert('''
    INSERT INTO $table (name, c)
    VALUES (?, ?);
    ''', [treeMember.name, treeMember.c]);

    //print(res);
    return res;
  }

  removeMember(TreeMember treeMember, String table) async {
    final db = await database;

    var res = await db.delete(table, where: 'id = ?', whereArgs: [treeMember.id]);

    //print(res);
    return res;
  }

  getMembers(String table) async {
    final db = await database;
    var res = await db.query(table);
    //print(res);
    if (res.length == 0 || res.isEmpty)
    {
      return null;
    }
    return res;
  }

  Future<List<Map>> getFamilies() async {
    final db = await database;
    var res = await db.rawQuery('''
    SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_%';
    ''');
    //print(res);
    if (res.length == 0 || res.isEmpty)
    {
      return null;
    }
    return res;
  }

  cleanTable(String column) async {
    final db = await database;
    var res = await db.rawQuery('''
    delete from $column;
    ''');
    return res;
  }

  deleteTable(String table) async {
    final db = await database;
    var res = await db.rawQuery('''
    drop table if exists $table;
    ''');
    return res;
  }

  updateMember(String table, TreeMember treeMember) async{
    final db = await database;
    var res = await db.rawInsert('''
     REPLACE INTO $table (id, name, c)
      VALUES (?, ?, ?);
     ''', [treeMember.id, treeMember.name, treeMember.c]);

  }

  renameTable(String oldName, String newName) async{
    final db = await database;
    var res = await db.rawQuery('''
    ALTER TABLE $oldName RENAME TO $newName;
    ''');

  }

}
