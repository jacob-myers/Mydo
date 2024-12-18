import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mydo/classes/task.dart';
import 'package:flutter/widgets.dart';
import 'package:mydo/data/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:stack/stack.dart' as s;

// https://www.youtube.com/watch?v=noi6aYsP7Go

enum TaskAction {
  none,
  add,
  edit,
  mark,
  delete,
  superdelete,
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  static s.Stack<Tuple2<TaskAction, Task>> previousActions = s.Stack();

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

  undo() {
    var tup = previousActions.pop();
    TaskAction action = tup.item1;
    Task task = tup.item2;
    print("${action} ${task.content}");

    switch (action) {
      case TaskAction.none:
        break;
      case TaskAction.add:
        remove("tasks", task.id!);
        break;
      case TaskAction.edit:
        update(task);
        break;
      case TaskAction.mark:
        int histTaskID = previousActions.pop().item2.id!;
        addTask(task);
        remove("historical_tasks", histTaskID);
        break;
      case TaskAction.delete:
        addTask(task);
        break;
      case TaskAction.superdelete:
        addHistoricalTask(task);
        break;
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
    int id = await _add('tasks', task.toMap());
    //previousActions.push(Tuple2(Action.add, id));
    return id;
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
    //previousActions.push(Tuple2(Action.edit, task.id!));
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

