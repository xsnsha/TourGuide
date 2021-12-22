import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tourguide/entities/City.dart';
import 'package:tourguide/entities/Object.dart';
import 'package:tourguide/entities/ObjectAgent.dart';
import 'package:tourguide/entities/UserInfo.dart';
import 'package:tourguide/ui/LoginPage.dart';

class DatabaseProvider {
  static final DatabaseProvider _singleton = DatabaseProvider._internal();

  factory DatabaseProvider() {
    return _singleton;
  }

  DatabaseProvider._internal();

  Database? db;

  StreamController<List<ObjectInfo>> objectsAgentStream = StreamController();
  StreamController<List<ObjectInfo>> objectsAllStream = StreamController();
  StreamController<List<ObjectInfo>> objectsUserStream = StreamController();

  Future open() async {
    if (db == null) {
      sqfliteFfiInit();

      var databaseFactory = databaseFactoryFfi;

      final databasesPath = await getApplicationDocumentsDirectory();
      String path = join(databasesPath.path, 'demo.db');

      db = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
              version: 1,
              onCreate: (db, version) async {
                await createCityTable(db, mockCities);
              },
              onConfigure: (db) async {
                await db.execute('PRAGMA foreign_keys = ON');
              }));
    }
  }

  Future<bool> isTableExists(String name) async {
    bool isExists = false;
    try {
      var count = Sqflite.firstIntValue(
          await db!.rawQuery('SELECT COUNT(*) FROM $name'));
      if (count != 0) {
        isExists = true;
      }
    } catch (e) {}
    return isExists;
  }

  Future<int> createUserTable(UserInfo userInfo) async {
    List<Map<String, Object?>> maps = [];

    if (await isTableExists(userInfo.tableName)) {
      maps = await db!.rawQuery(
          'SELECT * FROM ${userInfo.tableName} '
          'WHERE $columnPass = ? AND $columnLogin = ?',
          [userInfo.pass, userInfo.login]);
    } else {
      await db?.execute('''
  CREATE TABLE ${userInfo.tableName} (
      ${userInfo.columnId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $columnName TEXT NOT NULL,
      $columnLogin TEXT NOT NULL,
      $columnPass TEXT NOT NULL
  )
  ''');
    }

    var userId = -1;
    if (maps.isEmpty) {
      userId = await insertUserInfo(userInfo);
    } else {
      var info = UserInfo.fromMap(userInfo.roleEnum, maps.first);
      await updateUserInfo(info, userInfo.name);
      userId = info.id;
    }

    return userId;
  }

  Future<int> insertUserInfo(UserInfo userInfo) async {
    final id = await db?.insert(userInfo.tableName, userInfo.toMap());
    var resultQuery = await db?.query(userInfo.tableName);
    print("insertUserInfo $resultQuery");

    return id ?? -1;
  }

  Future<void> updateUserInfo(UserInfo userInfo, String newName) async {
    await db?.execute(
        'UPDATE ${userInfo.tableName} SET $columnName = ? '
        'WHERE ${userInfo.columnId} = ?',
        [newName, userInfo.id]);
    var result = await db?.query(userInfo.tableName);
    print("updateUserInfo $result");
  }

  Future createCityTable(Database db, List<City> cities) async {
    await db.execute('DROP TABLE If EXISTS $tableCityName');
    await db.execute('''
  CREATE TABLE $tableCityName (
      $columnCityId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $columnCityName TEXT NOT NULL
  )
  ''');
    await db.transaction((txn) async {
      cities.forEach((element) async {
        await db.insert(tableCityName, element.toMap());
      });
      getListsOfCity();
    });
  }

  Future<List<City>> getListsOfCity() async {
    List<City> cities = [];

    try {
      var res = await db?.query(tableCityName);

      res?.forEach((element) {
        cities.add(City.fromMap(element));
      });
    } catch (e) {}
    print("getListsOfCity ${cities.map((e) => e.name)}");

    return cities;
  }

  Future createObjectTable(ObjectInfo objectInfo, UserInfo userInfo) async {
    if (!await isTableExists(tableObjectName)) {
      try {
        await db?.execute('''
  CREATE TABLE $tableObjectName (
      $columnObjectsId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $columnObjectCityId INTEGER NOT NULL REFERENCES $tableCityName($columnCityId),
      $columnObjectName TEXT NOT NULL,
      $columnObjectAddress TEXT NOT NULL,
      $columnObjectWorkTime TEXT NOT NULL
  )
  ''');
      } catch (e) {}
    }

    final idObject = await insertObject(objectInfo, userInfo);
    print("insertObject $idObject");
    if (idObject != -1 || idObject != 0) {
      if (userInfo.roleEnum == RoleEnum.agent) {
        createObjectAgent(ObjectAgent()
          ..id = idObject
          ..idAgent = userInfo.id);
      } else {}
    }
  }

  Future<int> insertObject(ObjectInfo objectInfo, UserInfo userInfo) async {
    var idObject = await db?.insert(tableObjectName, objectInfo.toMap());
    return idObject ?? -1;
  }

  Future createObjectAgent(ObjectAgent objectAgent) async {
    if (!await isTableExists(tableObjectAgent)) {
      await db?.execute('''
  CREATE TABLE $tableObjectAgent (
      $columnObjectId INTEGER NOT NULL REFERENCES $tableObjectName($columnObjectsId),
      $columnAgentId INTEGER NOT NULL REFERENCES $tableAgent($columnAgentId),
      PRIMARY KEY($columnObjectId, $columnAgentId)
  )
  ''');
    }

    await insertObjectAgent(objectAgent);

    getAgentObjects(objectAgent.idAgent);
  }

  Future<void> insertObjectAgent(ObjectAgent objectAgent) async {
    await db?.insert(tableObjectAgent, objectAgent.toMap());
    var result = await db?.query(tableObjectAgent);
    print("insertObjectAgent $result");
  }

  void getAgentObjects(int idAgent) async {
    final lists = await _queryObjectsByAgentId(idAgent);
    if (lists.isNotEmpty) {
      objectsAgentStream.add(lists);
    }
  }


  Future createObjectUser(ObjectUser objectUser) async {
    if (!await isTableExists(tableObjectUser)) {
      await db?.execute('''
  CREATE TABLE $tableObjectUser (
      $columnObjectId INTEGER NOT NULL REFERENCES $tableObjectName($columnObjectsId),
      $columnUserId INTEGER NOT NULL REFERENCES $tableUser($columnUserId),
      PRIMARY KEY($columnObjectId, $columnUserId)
  )
  ''');
    }

    try{
      await insertObjectUser(objectUser);
      getUserObjects(objectUser.idUser);
    }catch(e){

    }
  }

  Future<void> insertObjectUser(ObjectUser objectUser) async {
    await db?.insert(tableObjectUser, objectUser.toMap());
    var result = await db?.query(tableObjectUser);
    print("insertObjectUser $result");
  }

  void getUserObjects(int idUser) async {
    final lists = await _queryObjectsByUserId(idUser);
    objectsUserStream.add(lists);
  }

  void deleteUserObject(ObjectUser objectUser) async {
    try{
      await db?.rawDelete("DELETE FROM $tableObjectUser WHERE "
          "$columnObjectId = ? AND $columnUserId = ?",
          [objectUser.id, objectUser.idUser]);
      getUserObjects(objectUser.idUser);
    }catch(e){

    }
  }

  void getAllObjects() async {
    List<ObjectInfo> lists = [];
    try{
      final res = await db?.rawQuery("SELECT * FROM $tableObjectName");
      if(res != null && res.isNotEmpty){
        res.forEach((element) {
          lists.add(ObjectInfo.fromMap(element));
        });
      }
    }catch(e){
      log("error getAllObjects");
    }

    if (lists.isNotEmpty) {
      objectsAllStream.add(lists);
    }
  }

  Future<List<ObjectInfo>> _queryObjectsByAgentId(int objectAgentId) async {
    List<ObjectInfo> lists = [];
    try{
      final res = await db?.rawQuery("SELECT * FROM $tableObjectAgent "
          "INNER JOIN $tableObjectName ON $columnObjectId = $columnObjectsId "
          "WHERE $columnAgentId = $objectAgentId");
      if(res != null && res.isNotEmpty){
        res.forEach((element) {
          lists.add(ObjectInfo.fromMap(element));
        });
      }
    }catch(e){
      log("error _queryObjectsByAgentId");
    }
    return lists;
  }

  Future<List<ObjectInfo>> _queryObjectsByUserId(int objectUserId) async {
    List<ObjectInfo> lists = [];
    try{
      final res = await db?.rawQuery("SELECT * FROM $tableObjectUser "
          "INNER JOIN $tableObjectName ON $columnObjectId = $columnObjectsId "
          "WHERE $columnUserId = $objectUserId");
      if(res != null && res.isNotEmpty){
        res.forEach((element) {
          lists.add(ObjectInfo.fromMap(element));
        });
      }
    }catch(e){
      log("error _queryObjectsByUserId");
    }
    return lists;
  }

  void closeAgentStream(){
    if(!objectsAgentStream.isClosed){
      objectsAgentStream.close();
    }
  }

  void closeUserStream(){
    if(!objectsUserStream.isClosed){
      objectsUserStream.close();
    }
  }

  void closeAllStream(){
    if(!objectsAllStream.isClosed){
      objectsAllStream.close();
    }
  }
}
