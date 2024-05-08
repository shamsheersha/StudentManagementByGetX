import 'package:sqflite/sqflite.dart';
import 'package:student_app/db_helper/database_connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  //insert user
  insertData(table, data) async {
    print("hello adil");
    var connection = await database;
    return await connection?.insert(table, data);
  }

  // Read All Record
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //read a single racord by id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  // update user
  updateData(table, data, id) async {
    var connection = await database;

    // print(connection?.query(table,where: 'id=?',whereArgs: [id]));
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [id]);
  }
  //delete

  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id =$itemId");
  }

// search  data
  searchRecords(String searchTerm) async {
    var db = await database;
    List<Map> result = await db!.query(
      'user',
      where: "name LIKE ?",
      whereArgs: ['%$searchTerm%'],
    );
    return result;
  }
}
