import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'character.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

class DB {
  static Future<DB>? _singletonFuture;
  static late Database _db;

  // 私有构造函数
  DB._internal();

  // 静态工厂方法，返回单例实例
  static Future<DB> getInstance() async {
    _singletonFuture ??= _initSingleton();
    return _singletonFuture!;
  }

  static Future<DB> _initSingleton() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }
    // 异步获取单例实例
    final db = await _openDB();
    final singleton = DB._internal();
    singleton._initialize(db);
    return singleton;
  }

  void _initialize(Database db) {
    _db = db;
    _createTable();
  }

  static _openDB() async {
    if (Platform.isWindows) {
      String? appDataPath = Platform.environment['APPDATA'];
      return await databaseFactoryFfi
          .openDatabase("$appDataPath\\maple_query\\test.db");
    }else{
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      final directory = await getApplicationDocumentsDirectory();
      return await databaseFactoryFfi.openDatabase("${directory.path}\\test.db");
    }
  }

  static close() async {
    await _db.close();
  }

  static _createTable() async {
    await _db.execute('''
  CREATE TABLE IF NOT EXISTS main_page (
      id INTEGER PRIMARY KEY,
      name VARCHAR(20) UNIQUE,
      class_name VARCHAR(20),
      level INT,
      server VARCHAR(20),
      img_url VARCHAR(200),
      exp  INT,
      exp_percent  DOUBLE,
      
      server_rank INT,
      server_class_rank INT,
      global_rank INT,
      class_rank INT,
      
      achievement_points INT,
      achievement_rank INT,
      
      legion_coin_per_day  INT,
      legion_level INT,
      legion_power INT,
      legion_rank INT,
      
      history TEXT,
      
      at_update DATETIME DEFAULT CURRENT_TIMESTAMP
  )
  ''');
  }

  add(Character c) async {
    await _db.insert('main_page', <String, Object?>{
      'name': c.name,
      'class_name': c.className,
      'level': c.level,
      'server': c.server,
      'img_url': c.imgUrl,
      'exp': c.exp,
      'exp_percent': c.expPercent,
      'server_rank': c.serverRank,
      'server_class_rank': c.serverClassRank,
      'global_rank': c.globalRank,
      'class_rank': c.classRank,
      'achievement_points': c.achievementPoints,
      'achievement_rank': c.achievementRank,
      'legion_coin_per_day': c.legionCoinPerDay,
      'legion_level': c.legionLevel,
      'legion_power': c.legionPower,
      'legion_rank': c.legionRank,
      'history': c.history.toString(),
      'at_update': c.update?.toIso8601String(),
    });
  }

  delete(String name) async {
    await _db.delete('main_page', where: "name = ?", whereArgs: [name]);
  }

  update(Character c) async {
    await _db.update(
        'main_page',
        <String, Object?>{
          'class_name': c.className,
          'level': c.level,
          'server': c.server,
          'img_url': c.imgUrl,
          'exp': c.exp,
          'exp_percent': c.expPercent,
          'server_rank': c.serverRank,
          'server_class_rank': c.serverClassRank,
          'global_rank': c.globalRank,
          'class_rank': c.classRank,
          'achievement_points': c.achievementPoints,
          'achievement_rank': c.achievementRank,
          'legion_coin_per_day': c.legionCoinPerDay,
          'legion_level': c.legionLevel,
          'legion_power': c.legionPower,
          'legion_rank': c.legionRank,
          'history': c.history.toString(),
          'at_update': c.update?.toIso8601String(),
        },
        where: "name = ?",
        whereArgs: [c.name]);
  }

  Future<List<Character>> getAllName() async {
    final result = await _db.query('main_page');
    List<Character> cs = [];
    for (final c in result) {
      Character cc = Character(
        name: c["name"] as String,
        className: c["class_name"] as String,
        level: c["level"] as int,
        server: c["server"] as String,
        imgUrl: c["img_url"] as String,
        exp: c["exp"] as int,
        expPercent: c["exp_percent"] as double,
        serverRank: c["server_rank"] as int?,
        serverClassRank: c["server_class_rank"] as int?,
        globalRank: c["global_rank"] as int?,
        classRank: c["class_rank"] as int?,
        achievementPoints: c["achievement_points"] as int?,
        achievementRank: c["achievement_rank"] as int?,
        legionCoinPerDay: c["legion_coin_per_day"] as int?,
        legionLevel: c["legion_level"] as int?,
        legionPower: c['legion_power'] as int?,
        legionRank: c['legion_rank'] as int?,
        history: History.fromString(c['history'] as String),
        update: DateTime.parse(c['at_update'] as String),
      );
      final now = DateTime.now();
      DateTime todayAt6 = DateTime(now.year, now.month, now.day, 6, 0, 0);
      if (cc.update!.isAfter(todayAt6)) {
        await cc.getImageFile();
      }
      cs.add(cc);
    }
    return cs;
  }
}
