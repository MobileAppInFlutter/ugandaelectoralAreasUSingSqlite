import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:working_with_sqlt/model/district.model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "kampenidb";
  final String columnId = "id";
  final String columnDistrict = 'field1'; //"DISTRICT";
  final String columnconstituency = "field2";
  final String columnSubCountry = "field3";
  final String columnElectoralAreaVillage = "field4";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, "kampeniData.db");

// Delete the database
      // await deleteDatabase(path);

// Check if the db exists
      var exists = await databaseExists(path);

      if (!exists) {
        // Should happen only the first time you launch your application
        print("Creating new copy from asset");

        // Make sure the parent directory exists
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        // Copy from asset
        ByteData data = await rootBundle.load(join("assets", "kampeni.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
      } else {
        print("Opening existing database");
      }
      // open the database
      return await openDatabase(path, readOnly: true);
    } catch (e) {
      print(e.toString());
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnDistrict TEXT, $columnconstituency TEXT, $columnSubCountry TEXT, $columnElectoralAreaVillage TEXT)");
    print("Table is created");
  }

  //Get
  Future<List> getItems() async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery(
          "SELECT * FROM $tableName ORDER BY $columnDistrict ASC"); //ASC

      return result.toList();
    } catch (e) {
      print(e.toString());
    }
  }

  // search
  Future getLocationDetails(String electoralVillage) async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery(
          "SELECT * FROM $tableName WHERE field4 = '$electoralVillage' GROUP BY $columnconstituency, $columnSubCountry"); //ASC
      var resultList = result.toList();

      return resultList.map((map) => DistrictItem.fromMap(map)).toList();
    } catch (e) {
      print(e.toString());
    }
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
