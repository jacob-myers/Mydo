import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mydo/classes/task.dart';
import 'package:flutter/widgets.dart';
import 'package:mydo/data/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://www.youtube.com/watch?v=noi6aYsP7Go

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String mydbDirectory = join(await getDatabasesPath(), "tasks.db");
    return await openDatabase(
      mydbDirectory,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY, 
        date INTEGER, 
        content TEXT, 
        category TEXT)
    ''');

    await db.execute('''
      CREATE TABLE historical_tasks(
        id INTEGER PRIMARY KEY,
        date INTEGER,
        content TEXT)
    ''');
  }

  // https://stackoverflow.com/questions/56248737/how-to-add-new-table-to-sqlite
  // To update from older database versions
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db.execute('''
      CREATE TABLE historical_tasks(
        id INTEGER PRIMARY KEY,
        date INTEGER,
        content TEXT)
    ''');
    }
  }

  Future<List<Task>> _getTasks({required String table, String? orderBy}) async {
    Database db = await instance.database;
    var tasks = await db.query(table, orderBy: orderBy);

    /*
    print(tasks);
    List<Task> taskList=[];
    tasks.forEach((task) {
      print(Task.fromMap(task));
      print(DateTime.fromMillisecondsSinceEpoch(int.parse(task['date'].toString())));
      taskList.add(Task.fromMap(task));
    });
    */

    List<Task> taskList = tasks.isNotEmpty
        ? tasks.map((t) => Task.fromMap(t)).toList() // Issue with table with no category
        : [];

    return taskList;
  }

  Future<List<Task>> getTasks() async {
    return _getTasks(table: 'tasks', orderBy: 'category');
  }

  Future<List<Task>> getHistoricalTasks() async {
    return _getTasks(table: 'historical_tasks', orderBy: 'date');
  }

  Future<List<Task>> getPlannedTasks() async {
    List<Task> tasks = await _getTasks(table: 'tasks', orderBy: 'date');
    tasks.removeWhere((e) => e.date == null || e.category != PLANNED_TAG);
    return tasks;
  }

  Future<int> _add(String table, dynamic json) async {
    //print("Adding: ${task.toMap()}");
    Database db = await instance.database;
    return await db.insert(table, json);
  }

  Future<int> addTask(Task task) async {
    return _add('tasks', task.toMap());
  }

  Future<int> addHistoricalTask(Task task) async {
    Map<String, dynamic> taskMap = task.toMap();
    taskMap.remove('category');
    taskMap['id'] = null;
    return _add('historical_tasks', taskMap);
  }

  // Remove task from tasks db with id.
  Future<int> remove(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  
  Future<int> update(Task task) async {
    Database db = await instance.database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // Deletes everything.
  Future<int> truncate() async {
    Database db = await instance.database;
    return await db.delete('historical_tasks');
  }

  Future<void> printDB() async {
    Database db = await instance.database;
    print(await db.query('tasks'));
  }
}

