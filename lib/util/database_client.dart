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
  // candidate table
  final String candidateTable = 'Candidate';
  final String surnameColumn = 'surname';
  final String otherNameColumn = 'other_name';
  final String genderColumn = 'sex';
  final String politicalPartyColumn = 'political_party';
  final String symbolColumn = 'symbol';
  final String categoryNameColumn = 'category_name';
  final String districtNameColumn = 'district_name';
  final String electoralAreaColumn = 'electoral_area';
  final String statusColumn = 'status';

  // District table
  final String districtTable = "District";
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

  // void _onCreate(Database db, int version) async {
  //   await db.execute(
  //       "CREATE TABLE $districtTable(id INTEGER PRIMARY KEY, $columnDistrict TEXT, $columnconstituency TEXT, $columnSubCountry TEXT, $columnElectoralAreaVillage TEXT)");
  //   print("Table is created");
  // }

  // HANDLE CANDIDATE TABLE QUERIES

  //end of Candidate queries

  // HANDLE DISTRICT TABLE QUERIES
  //Get
  Future<List> getItems() async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery(
          "SELECT * FROM $districtTable ORDER BY $columnDistrict ASC");

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
          "SELECT * FROM $districtTable WHERE $columnElectoralAreaVillage = '$electoralVillage' GROUP BY $columnconstituency, $columnSubCountry");
      var resultList = result.toList();
      return resultList.map((map) => DistrictItem.fromMap(map)).toList();
    } catch (e) {
      print(e.toString());
    }
  }
  //end of district queries

  // ACCROSS TABLES

  // Return candidates for a given district
  Future getCandidateForGivenArea(String electoralVillageName) async {
    try {
      var dbClient = await db;
      var sql =
          "SELECT d.district,d.constituency,d.subcounty,d.electoral_area_village, c.surname, c.other_name, c.sex, c.political_party, c.symbol, c.category_name,c.electoral_area, c.district_name  FROM Candidate c INNER JOIN district d ON d.district = c.district_name WHERE d.electoral_area_village = '$electoralVillageName'  ORDER BY c.surname";
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
