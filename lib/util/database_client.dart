import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:working_with_sqlt/model/candidate.model.dart';
import 'package:working_with_sqlt/model/district.model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "District";
  final String columnId = "id";
  final String columnDistrict = 'district'; 
  final String columnconstituency = "constituency";
  final String columnSubCountry = "subcounty";
  final String columnElectoralAreaVillage = "electoral_area_village";

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
      await deleteDatabase(path);

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

  // Return candidates for a given district
  Future getCandidateForGivenDistrict(String districtName) async {
    try {
      var dbClient = await db;
      var sql =
          "select * from candidates_position c  inner join kampenidb k on c.field7 = k.field1 where k.field1='$districtName'";
      var result = await dbClient.rawQuery(sql);
      var resultList = result.toList();
      return resultList.map((map) => Candidate.fromMap(map)).toList();
    } catch (e) {
      print(e.toString());
    }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
