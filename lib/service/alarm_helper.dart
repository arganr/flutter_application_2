import 'package:flutter_application_2/model/alarm_model.dart';
import 'package:sqflite/sqflite.dart';

class AlarmHelper {
  static Database _database;
  static AlarmHelper _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = AlarmHelper._createInstance();
    }
    return _alarmHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "alarmDart.db";

    var database = await openDatabase(path, version: 1, onCreate: (db, verion) {
      db.execute("CREATE TABLE Alarm ("
          "id INT,"
          "DateSet DATETIME,"
          "DateUp DATETIME,"
          "SecondDiff INT,"
          "isActive INT"
          ")");
    });
    return database;
  }

  newAlarm(AlarmModel newAlrm) async {
    final db = await database;
    var res = await db.insert("Alarm", newAlrm.toJson());
    return res;
  }

  updateAlarm(AlarmModel upAlrm) async {
    final db = await database;
    var result = await db.update("Alarm", upAlrm.toJson(),
        where: "id = ?", whereArgs: [upAlrm.id]);
    return result;
  }

  updateInactiveAlarm() async {
    final db = await database;
    var result = await db.rawUpdate(
        "UPDATE Alarm SET isActive = 0, DateUp=DATETIME('now') WHERE isActive = 0 AND DateSet < DATETIME('now')");
    return result;
  }

  getAlarm() async {
    final db = await database;
    var res = await db.query("Alarm", where: "isActive = 1");
    List<AlarmModel> list =
        res.isNotEmpty ? res.map((c) => AlarmModel.fromJson(c)).toList() : [];
    return list;
  }

  getAlarmDone() async {
    final db = await database;
    var res = await db.query("Alarm", where: "isActive = 0");
    List<AlarmModel> list =
        res.isNotEmpty ? res.map((c) => AlarmModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteAllAlarm() async {
    final db = await database;
    var res = await db.delete("Alarm");
    return res;
  }

  Future<AlarmModel> getAlarmById(int id) async {
    final db = await database;
    var result = await db.query("Alarm", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? AlarmModel.fromJson(result.first) : Null;
  }

  maxId() async {
    int intID = 0;
    final db = await database;

    var result = await db
        .rawQuery("SELECT id AS max_id FROM Alarm ORDER BY id DESC LIMIT 1");

    if (result.isNotEmpty) {
      var dbItem = result.first;
      intID = int.parse(dbItem['max_id'].toString());
    }

    intID += 1;

    return intID;
  }
}
