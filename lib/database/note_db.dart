import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../models/note_model.dart';

class NoteDb {
  static final NoteDb instance = NoteDb._init();

  NoteDb._init();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await _initDb("notes.db");
    return _db!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    var sql = '''
     CREATE TABLE $tableNotes(
       ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
       ${NoteFields.isImportant} BOOLEAN NOT NULL,
       ${NoteFields.number} INTEGER NOT NULL,
       ${NoteFields.title} TEXT NOT NULL,
       ${NoteFields.description} TEXT NOT NULL,
       ${NoteFields.time} TEXT NOT NULL
     )
   ''';
    await db.execute(sql);
  }

  Future<List<Note>> list() async {
    final db = await instance.db;

    const orderBy = '${NoteFields.time} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> create(Note note) async {
    final db = await instance.db;

    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

  Future<Note> get(int id) async {
    final db = await instance.db;

    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("ID ${id} not found");
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.db;

    return db
        .delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    final db = await instance.db;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }
}
