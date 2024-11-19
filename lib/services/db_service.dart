import 'dart:io';

import 'package:myapp/models/lost_object_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<bool> databaseExists(String path) async {
  final file = File(path);
  return file.exists();
}

Future<Database?> getDB() async {
  String path = await getDatabasesPath();
  String dbPath = join(path, 'object.db');
  bool exists = await databaseExists(dbPath);
  if (exists) {
    Database db = await openDatabase(dbPath);
    return db;
  } else {
    return null;
  }
}

Future<Database> createDB() async {
  String path = await getDatabasesPath();
  String dbPath = join(path, 'object.db');

  return openDatabase(
    dbPath,
    onCreate: (database, version) async {
      await database.execute('''
        CREATE TABLE object(
          object_id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          type TEXT NOT NULL,
          nature TEXT NOT NULL,
          station TEXT NOT NULL
        )
        ''');
      await database.execute('''
        CREATE TABLE station(
          station_id INTEGER PRIMARY KEY AUTOINCREMENT,
          station_name TEXT NOT NULL
        )
        ''');
      await database.execute('''
        CREATE TABLE type(
          type_id INTEGER PRIMARY KEY AUTOINCREMENT,
          type_name TEXT NOT NULL
        )
        ''');
      await database.execute('''
        CREATE TABLE nature(
          nature_id INTEGER PRIMARY KEY AUTOINCREMENT,
          nature_name TEXT NOT NULL
        )
        ''');
    },
    version: 1,
  );
}

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  String dbPath = join(path, 'object.db');

  bool exists = await databaseExists(dbPath);
  Database db;

  if (!exists) {
    db = await createDB();
    await addSampleObjects(db);
  } else {
    db = await openDatabase(dbPath);
  }
  return db;
}

Future<void> insertItem(Database db, LostObject lostObject) async {
  await db.insert(
    'object',
    {
      'date': lostObject.date,
      'type': lostObject.type,
      'nature': lostObject.nature,
      'station': lostObject.startStation
    },
  );
}

Future<void> insertMultipleItems(Database db, List<LostObject> objects) async {
  await db.transaction((txn) async {
    for (var object in objects) {
      await txn.insert(
        'object',
        {
          'date': object.date,
          'station': object.startStation,
          'type': object.type,
          'nature': object.nature,
        },
      );
    }
  });
}

Future<List<String>> retrieveTypes(Database db) async {
  List<Map<String, dynamic>> maps = await db.query('type');
  return maps.map((map) => map['type_name'].toString()).toList();
}

Future<List<String>> retrieveNatures(Database db) async {
  List<Map<String, dynamic>> maps = await db.query('nature');
  return maps.map((map) => map['nature_name'].toString()).toList();
}

Future<List<String>> retrieveStations(Database db) async {
  List<Map<String, dynamic>> maps = await db.query('station');
  return maps.map((map) => map['station_name'].toString()).toList();
}

Future<List<LostObject>> retrieveItems(Database db,
    {List<String>? startStation,
    List<String>? type,
    List<String>? nature,
    String? minDate,
    String? maxDate,
    String? orderBy,
    String? orderByDirection}) async {
  List<String> whereClauses = [];
  List<dynamic> whereArgs = [];
  String orderByClause = '';

  if (startStation != null && startStation.isNotEmpty) {
    whereClauses
        .add('station IN (${List.filled(startStation.length, '?').join(',')})');
    whereArgs.addAll(startStation);
  }
  if (type != null && type.isNotEmpty) {
    whereClauses.add('type IN (${List.filled(type.length, '?').join(',')})');
    whereArgs.addAll(type);
  }
  if (nature != null && nature.isNotEmpty) {
    whereClauses
        .add('nature IN (${List.filled(nature.length, '?').join(',')})');
    whereArgs.addAll(nature);
  }
  if (minDate != null && minDate.isNotEmpty) {
    whereClauses.add('date > ?');
    whereArgs.add(minDate);
  }
  if (maxDate != null && maxDate.isNotEmpty) {
    whereClauses.add('date < ?');
    whereArgs.add(maxDate);
  }
  if (orderBy != null &&
      orderBy.isNotEmpty &&
      orderByDirection != null &&
      orderByDirection.isNotEmpty) {
    orderByClause = ' $orderBy $orderByDirection';
  }

  String where = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : '';
  List<Map<String, dynamic>> maps;

  if (where.isNotEmpty) {
    if (orderByClause.isNotEmpty) {
      maps = await db.query(
        'object',
        where: where,
        whereArgs: whereArgs,
        orderBy: orderByClause,
      );
    } else {
      maps = await db.query(
        'object',
        where: where,
        whereArgs: whereArgs,
      );
    }
  } else {
    if (orderByClause.isNotEmpty) {
      maps = await db.query(
        'object',
        orderBy: orderByClause,
      );
    } else {
      maps = await db.query('object');
    }
  }

  return maps.map((map) => LostObject.fromJson(map)).toList();
}

Future<void> addSampleObjects(Database db) async {
  List<String> stations = [
    'Gare de Metz',
    'Gare de Poitiers',
    'Gare de Perpignan',
    'Gare de Limoges',
    'Gare de Clermont-Ferrand',
    'Gare d\'Angers',
    'Gare de Tours',
    'Gare de Dijon',
    'Gare de Besançon',
    'Gare d\'Annecy',
    'Gare de Valence',
    'Gare de Brest',
    'Gare de Quimper',
    'Gare de La Rochelle',
    'Gare de Pau',
    'Gare de Bayonne',
    'Gare de Biarritz',
    'Gare de Saint-Brieuc',
    'Gare de Laval',
    'Gare de Bourges',
    'Gare de Lorient',
    'Gare d\'Agen',
    'Gare de Chamonix',
    'Gare de Nice',
    'Gare de Rouen',
    'Gare de Lille',
    'Gare de Strasbourg'
  ];

  List<String> types = [
    'Portefeuille en cuir',
    'Lunettes de vue',
    'Sac de sport rouge',
    'Passeport français',
    'Smartphone avec coque noire',
    'Sac plastique d\'enseigne Carrefour',
    'Chapeau en feutre gris',
    'Casque audio sans fil noir',
    'Blouson en cuir marron',
    'Porte-clés en forme de tour Eiffel',
    'Bonnet en laine bleu',
    'Écharpe en soie rouge',
    'Sac à dos noir avec logo Nike',
    'Doudoune légère bleue',
    'Sac à main en cuir noir',
    'Lunettes de soleil en étui rigide',
    'Carte bancaire Visa',
    'Valise à roulettes rouge',
    'Parapluie pliant noir',
    'Sac à main en tissu fleuri',
    'Sacoche en cuir marron',
    'iPhone 12 avec coque transparente',
    'Foulard en coton jaune',
    'Livre relié avec couverture bleue',
    'Portefeuille en cuir noir',
    'Lunettes de soleil',
    'Sac à dos scolaire rouge',
    'Passeport italien',
    'iPhone avec coque silicone bleue',
    'Sac plastique Monoprix',
    'Chapeau en paille beige',
    'Casque audio Sony noir',
    'Blouson en jean',
    'Porte-clés avec badge magnétique',
    'Bonnet en laine gris',
    'Écharpe rayée multicolore',
    'Sac à dos noir pour ordinateur',
    'Doudoune verte avec capuche',
    'Sac à main bleu en tissu',
    'Lunettes en étui rigide noir',
    'Carte de crédit Mastercard',
    'Valise à roulettes noire',
    'Parapluie pliant noir avec poignée en bois',
    'Sac à main rose en cuir',
    'Sacoche en cuir marron avec bandoulière',
    'Samsung Galaxy avec coque transparente',
    'Foulard en coton jaune',
    'Livre de poche',
    'Portefeuille avec permis de conduire',
    'Valise de cabine grise',
    'Sac de sport Adidas bleu',
    'Lunettes de soleil Ray-Ban'
  ];

  List<String> natures = [
    'Porte-monnaie, portefeuille',
    'Lunettes',
    'Sac de voyage, sac de sport, sac à bandoulière',
    'Carte d\'identité, passeport, permis de conduire',
    'Téléphone portable protégé (étui, coque, …)',
    'Sac d\'enseigne (plastique, papier, …)',
    'Bonnet, chapeau',
    'Téléphone portable',
    'Manteau, veste, blazer, parka, blouson, cape',
    'Clés, porte-clés',
    'Foulard, écharpe',
    'Sac à dos',
    'Sac à main',
    'Lunettes en étui',
    'Carte de crédit',
    'Valise, sac sur roulettes'
  ];

  for (var station in stations) {
    await db.insert('station', {'station_name': station});
  }

  for (var type in types) {
    await db.insert('type', {'type_name': type});
  }

  for (var nature in natures) {
    await db.insert('nature', {'nature_name': nature});
  }

  List<LostObject> sampleObjects = [
    LostObject(
      date: '2023-09-12T09:00:00+00:00',
      startStation: 'Gare de Metz',
      type: 'Portefeuille en cuir',
      nature: 'Porte-monnaie, portefeuille',
    ),
    LostObject(
      date: '2022-02-03T14:45:30+00:00',
      startStation: 'Gare de Poitiers',
      type: 'Lunettes de vue',
      nature: 'Lunettes',
    ),
    LostObject(
      date: '2022-04-18T16:30:00+00:00',
      startStation: 'Gare de Perpignan',
      type: 'Sac de sport rouge',
      nature: 'Sac de voyage, sac de sport, sac à bandoulière',
    ),
    LostObject(
      date: '2023-07-22T19:15:45+00:00',
      startStation: 'Gare de Limoges',
      type: 'Passeport français',
      nature: 'Carte d\'identité, passeport, permis de conduire',
    ),
    LostObject(
      date: '2024-02-10T11:30:00+00:00',
      startStation: 'Gare de Clermont-Ferrand',
      type: 'Smartphone avec coque noire',
      nature: 'Téléphone portable protégé (étui, coque, …)',
    ),
    LostObject(
      date: '2023-01-15T08:20:10+00:00',
      startStation: 'Gare d\'Angers',
      type: 'Sac plastique d\'enseigne Carrefour',
      nature: 'Sac d\'enseigne (plastique, papier, …)',
    ),
    LostObject(
      date: '2024-03-27T12:40:00+00:00',
      startStation: 'Gare de Tours',
      type: 'Chapeau en feutre gris',
      nature: 'Bonnet, chapeau',
    ),
    LostObject(
      date: '2024-08-01T15:10:30+00:00',
      startStation: 'Gare de Dijon',
      type: 'Casque audio sans fil noir',
      nature: 'Téléphone portable',
    ),
    LostObject(
      date: '2023-12-21T10:10:10+00:00',
      startStation: 'Gare de Besançon',
      type: 'Blouson en cuir marron',
      nature: 'Manteau, veste, blazer, parka, blouson, cape',
    ),
    LostObject(
      date: '2023-11-24T13:00:00+00:00',
      startStation: 'Gare de Metz',
      type: 'Porte-clés en forme de tour Eiffel',
      nature: 'Clés, porte-clés',
    ),
    LostObject(
      date: '2023-03-11T17:50:45+00:00',
      startStation: 'Gare d\'Annecy',
      type: 'Bonnet en laine bleu',
      nature: 'Bonnet, chapeau',
    ),
    LostObject(
      date: '2022-10-16T14:25:30+00:00',
      startStation: 'Gare de Valence',
      type: 'Écharpe en soie rouge',
      nature: 'Foulard, écharpe',
    ),
    LostObject(
      date: '2023-01-05T09:15:45+00:00',
      startStation: 'Gare de Brest',
      type: 'Sac à dos noir avec logo Nike',
      nature: 'Sac à dos',
    ),
    LostObject(
      date: '2024-07-22T18:00:00+00:00',
      startStation: 'Gare de Quimper',
      type: 'Doudoune légère bleue',
      nature: 'Manteau, veste, blazer, parka, blouson, cape',
    ),
    LostObject(
      date: '2022-08-19T20:35:45+00:00',
      startStation: 'Gare de La Rochelle',
      type: 'Sac à main en cuir noir',
      nature: 'Sac à main',
    ),
    LostObject(
      date: '2024-05-30T22:00:00+00:00',
      startStation: 'Gare de Pau',
      type: 'Lunettes de soleil en étui rigide',
      nature: 'Lunettes en étui',
    ),
    LostObject(
      date: '2023-09-15T11:15:30+00:00',
      startStation: 'Gare de Bayonne',
      type: 'Carte bancaire Visa',
      nature: 'Carte de crédit',
    ),
    LostObject(
      date: '2024-09-10T19:45:00+00:00',
      startStation: 'Gare de Biarritz',
      type: 'Valise à roulettes rouge',
      nature: 'Valise, sac sur roulettes',
    ),
    LostObject(
      date: '2024-05-10T07:30:00+00:00',
      startStation: 'Gare de Saint-Brieuc',
      type: 'Parapluie pliant noir',
      nature: 'Bonnet, chapeau',
    ),
    LostObject(
      date: '2023-02-12T09:00:00+00:00',
      startStation: 'Gare de Laval',
      type: 'Sac à main en tissu fleuri',
      nature: 'Sac à main',
    ),
    LostObject(
      date: '2024-06-18T10:10:00+00:00',
      startStation: 'Gare de Bourges',
      type: 'Sacoche en cuir marron',
      nature: 'Sac de voyage, sac de sport, sac à bandoulière',
    ),
    LostObject(
      date: '2024-01-09T14:14:00+00:00',
      startStation: 'Gare de Lorient',
      type: 'iPhone 12 avec coque transparente',
      nature: 'Téléphone portable',
    ),
    LostObject(
      date: '2024-01-21T12:00:00+00:00',
      startStation: 'Gare d\'Agen',
      type: 'Foulard en coton jaune',
      nature: 'Foulard, écharpe',
    ),
    LostObject(
      date: '2024-09-11T11:11:11+00:00',
      startStation: 'Gare de Chamonix',
      type: 'Livre relié avec couverture bleue',
      nature: 'Sac d\'enseigne (plastique, papier, …)',
    ),
    LostObject(
      date: '2023-05-12T09:00:00+00:00',
      startStation: 'Gare de Metz',
      type: 'Portefeuille en cuir noir',
      nature: 'Porte-monnaie, portefeuille',
    ),
    LostObject(
      date: '2022-11-03T14:45:30+00:00',
      startStation: 'Gare de Poitiers',
      type: 'Lunettes de soleil',
      nature: 'Lunettes',
    ),
    LostObject(
      date: '2021-04-18T16:30:00+00:00',
      startStation: 'Gare de Perpignan',
      type: 'Sac à dos scolaire rouge',
      nature: 'Sac à dos',
    ),
    LostObject(
      date: '2020-07-22T19:15:45+00:00',
      startStation: 'Gare de Limoges',
      type: 'Passeport italien',
      nature: 'Carte d\'identité, passeport, permis de conduire',
    ),
    LostObject(
      date: '2019-10-10T11:30:00+00:00',
      startStation: 'Gare de Clermont-Ferrand',
      type: 'iPhone avec coque silicone bleue',
      nature: 'Téléphone portable protégé (étui, coque, …)',
    ),
    LostObject(
      date: '2023-06-15T08:20:10+00:00',
      startStation: 'Gare d\'Angers',
      type: 'Sac plastique Monoprix',
      nature: 'Sac d\'enseigne (plastique, papier, …)',
    ),
    LostObject(
      date: '2021-02-27T12:40:00+00:00',
      startStation: 'Gare de Tours',
      type: 'Chapeau en paille beige',
      nature: 'Bonnet, chapeau',
    ),
    LostObject(
      date: '2022-08-01T15:10:30+00:00',
      startStation: 'Gare de Dijon',
      type: 'Casque audio Sony noir',
      nature: 'Téléphone portable',
    ),
    LostObject(
      date: '2018-03-21T10:10:10+00:00',
      startStation: 'Gare de Besançon',
      type: 'Blouson en jean',
      nature: 'Manteau, veste, blazer, parka, blouson, cape',
    ),
    LostObject(
      date: '2020-12-24T13:00:00+00:00',
      startStation: 'Gare de Metz',
      type: 'Porte-clés avec badge magnétique',
      nature: 'Clés, porte-clés',
    ),
    LostObject(
      date: '2023-07-11T17:50:45+00:00',
      startStation: 'Gare d\'Annecy',
      type: 'Bonnet en laine gris',
      nature: 'Bonnet, chapeau',
    ),
    LostObject(
      date: '2022-03-16T14:25:30+00:00',
      startStation: 'Gare de Valence',
      type: 'Écharpe rayée multicolore',
      nature: 'Foulard, écharpe',
    ),
    LostObject(
      date: '2019-01-05T09:15:45+00:00',
      startStation: 'Gare de Brest',
      type: 'Sac à dos noir pour ordinateur',
      nature: 'Sac à dos',
    ),
    LostObject(
      date: '2023-04-22T18:00:00+00:00',
      startStation: 'Gare de Quimper',
      type: 'Doudoune verte avec capuche',
      nature: 'Manteau, veste, blazer, parka, blouson, cape',
    ),
    LostObject(
      date: '2021-07-19T20:35:45+00:00',
      startStation: 'Gare de La Rochelle',
      type: 'Sac à main bleu en tissu',
      nature: 'Sac à main',
    ),
    LostObject(
      date: '2020-05-30T22:00:00+00:00',
      startStation: 'Gare de Pau',
      type: 'Lunettes en étui rigide noir',
      nature: 'Lunettes en étui',
    ),
    LostObject(
      date: '2023-01-15T11:15:30+00:00',
      startStation: 'Gare de Bayonne',
      type: 'Carte de crédit Mastercard',
      nature: 'Carte de crédit',
    ),
    LostObject(
      date: '2022-09-20T19:45:00+00:00',
      startStation: 'Gare de Biarritz',
      type: 'Valise à roulettes noire',
      nature: 'Valise, sac sur roulettes',
    ),
    LostObject(
      date: '2021-10-10T07:30:00+00:00',
      startStation: 'Gare de Saint-Brieuc',
      type: 'Parapluie pliant noir avec poignée en bois',
      nature: 'Bonnet, chapeau',
    ),
    LostObject(
      date: '2020-08-12T09:00:00+00:00',
      startStation: 'Gare de Laval',
      type: 'Sac à main rose en cuir',
      nature: 'Sac à main',
    ),
    LostObject(
      date: '2019-06-18T10:10:00+00:00',
      startStation: 'Gare de Bourges',
      type: 'Sacoche en cuir marron avec bandoulière',
      nature: 'Sac de voyage, sac de sport, sac à bandoulière',
    ),
    LostObject(
      date: '2023-09-09T14:14:00+00:00',
      startStation: 'Gare de Lorient',
      type: 'Samsung Galaxy avec coque transparente',
      nature: 'Téléphone portable',
    ),
    LostObject(
      date: '2021-06-21T12:00:00+00:00',
      startStation: 'Gare d\'Agen',
      type: 'Foulard en coton jaune',
      nature: 'Foulard, écharpe',
    ),
    LostObject(
      date: '2022-11-11T11:11:11+00:00',
      startStation: 'Gare de Chamonix',
      type: 'Livre de poche',
      nature: 'Sac d\'enseigne (plastique, papier, …)',
    ),
    LostObject(
      date: '2023-03-22T10:10:00+00:00',
      startStation: 'Gare de Nice',
      type: 'Portefeuille avec permis de conduire',
      nature: 'Porte-monnaie, portefeuille',
    ),
    LostObject(
      date: '2020-09-10T08:20:00+00:00',
      startStation: 'Gare de Rouen',
      type: 'Valise de cabine grise',
      nature: 'Valise, sac sur roulettes',
    ),
    LostObject(
      date: '2021-12-25T15:30:00+00:00',
      startStation: 'Gare de Lille',
      type: 'Sac de sport Adidas bleu',
      nature: 'Sac de voyage, sac de sport, sac à bandoulière',
    ),
    LostObject(
      date: '2022-06-15T11:00:00+00:00',
      startStation: 'Gare de Strasbourg',
      type: 'Lunettes de soleil Ray-Ban',
      nature: 'Lunettes',
    )
  ];

  await insertMultipleItems(db, sampleObjects);
}
