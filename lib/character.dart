import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class DayExp {
  final String day;
  final int level;
  final int exp;

  DayExp({required this.day, required this.level, required this.exp});

  Map<String, dynamic> toJson() => {
        'level': level,
        'exp': exp,
        'day': day,
      };

  factory DayExp.fromJson(Map<String, dynamic> json) {
    return DayExp(
      day: json['day'],
      level: json['level'],
      exp: json['exp'],
    );
  }
}

class History {
  List<DayExp> list = [];

  add(DayExp de) {
    list.add(de);
  }

  @override
  String toString() {
    return jsonEncode(list);
  }


  History();

  factory History.fromString(String value){
    History h = History();
    List<Map<String, dynamic>> data = (jsonDecode(value) as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    for(final v in data){
      h.list.add(DayExp(day: v['day'], level: v['level'], exp: v['exp']));
    }
    return h;
  }

  from(List<dynamic>? value) {
    if( value ==null) {
      return;
    }
    list.clear();
    for (final v in value) {
      list.add(DayExp(day: v['DateLabel'], level: v['Level'], exp: v['CurrentEXP']));
    }
  }
}

class Character {
  String name;
  String className;
  int level;
  String server;
  String imgUrl;
  int exp;
  double expPercent;

  int? serverRank;
  int? serverClassRank;
  int? globalRank;
  int? classRank;

  int? achievementPoints;
  int? achievementRank;

  int? legionCoinPerDay = 0;
  int? legionLevel = 0;
  int? legionPower = 0;
  int? legionRank = 0;

  History history;

  DateTime? update;
  File? imgFile;

  Character({
    required this.name,
    required this.className,
    required this.level,
    required this.server,
    required this.imgUrl,
    required this.exp,
    required this.expPercent,
    this.serverRank,
    this.serverClassRank,
    this.globalRank,
    this.classRank,
    this.achievementPoints,
    this.achievementRank,
    this.legionPower,
    this.legionLevel,
    this.legionCoinPerDay,
    this.legionRank,
    this.update,
    required this.history,
  });

  Future<File?> getImageFile() async {
    imgFile ??= await DefaultCacheManager().getSingleFile(imgUrl);

    return imgFile;
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    var data = json['CharacterData'];
    var graphData = data['GraphData'] as List<dynamic>?;
    var h = History();
    h.from(graphData);
    return Character(
      name: data['Name'],
      className: data['Class'],
      level: data['Level'],
      server: data['Server'],
      imgUrl: data['CharacterImageURL'],
      exp: data['EXP'],
      expPercent: data['EXPPercent'] / 1.0,
      serverRank: data['ServerRank'],
      serverClassRank: data['ServerClassRanking'],
      globalRank: data['GlobalRanking'],
      classRank: data['ClassRank'],
      achievementPoints: data["AchievementPoints"],
      achievementRank: data["AchievementRank"],
      legionCoinPerDay: data["LegionCoinsPerDay"],
      legionRank: data["LegionRank"],
      legionLevel: data["LegionLevel"],
      legionPower: data["LegionPower"],
      update: DateTime.now(),
      history: h,
    );
  }
}

Future<Character> get(name) async {
  final url = Uri.parse('https://api.maplestory.gg/v2/public/character/gms/$name');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var c = Character.fromJson(jsonDecode(response.body));
      await c.getImageFile();
      return c;
    }
  } catch (e) {
    rethrow;
  }
  throw Error();
}
