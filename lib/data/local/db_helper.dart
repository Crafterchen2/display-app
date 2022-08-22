// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:path/path.dart';
// import 'package:pionixbox/data/models/configured_network.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../models/available_network.dart';
//
// class DbHelper {
//   static const _databaseName = "pionix_box.db";
//   static const _databaseVersion = 1;
//
//   /// configured networks
//   static const tableConfiguredNetworks = "configured_networks";
//   static const colCnSsid = 'ssid';
//   static const colCnNetworkId = 'network_id';
//   static const colCnPassword = 'password';
//   static const colCnPSK = 'psk';
//   static const colCnIsConnected = 'is_connected';
//
//   /// Connected network
//   static const tableConnectedNetworks = "connected_networks";
//   static const colConnectedSsid = 'ssid';
//   static const colConnectedPassword = 'password';
//   static const colConnectedPSK = 'psk';
//
//   /// available networks
//   static const tableAvailableNetworks = "available_networks";
//   static const colAnSsid = 'ssid';
//   static const colAnFrequency = 'frequency';
//   static const colAnSignalLevel = 'signal_level';
//
//   DbHelper._privateConstructor();
//
//   static final DbHelper instance = DbHelper._privateConstructor();
//
//   static late Database _database;
//
//   Future<Database> get database async {
//     _database = await _initDatabase();
//     return _database;
//   }
//
//   _initDatabase() async {
//     String path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(path,
//         version: _databaseVersion, onCreate: _onCreate);
//   }
//
//   Future _onCreate(Database db, int version) async {
//     // await db.execute('''
//     //       CREATE TABLE $tableAvailableNetworks (
//     //         $colAnSsid TEXT NOT NULL,
//     //         $colAnFrequency INTEGER,
//     //         $colAnSignalLevel INTEGER,
//     //       )
//     //       ''');
//     await db.execute('''
//           CREATE TABLE $tableConfiguredNetworks (
//             $colCnNetworkId INTEGER NOT NULL,
//             $colCnSsid TEXT,
//             $colCnPassword TEXT,
//             $colCnPSK TEXT,
//             $colCnIsConnected INTEGER
//           )
//           ''');
//
//   }
//
//   Future<int> addConfiguredNetwork(ConfiguredNetwork cn) async {
//     Database db = await instance.database;
//     try {
//       var res = await db.insert(tableConfiguredNetworks, cn.toJson());
//       return res;
//     } catch (e) {
//       debugPrint('error while adding Configured Network: $e');
//     }
//     return 0;
//   }
//
//   Future<int> updateConfiguredNetwork(ConfiguredNetwork cn) async {
//     Database db = await instance.database;
//     try {
//       var res = await db.update(tableConfiguredNetworks, cn.toJson());
//       return res;
//     } catch (e) {
//       debugPrint('error while updating Configured Network: $e');
//     }
//     return 0;
//   }
//
//   Future<List<ConfiguredNetwork>> getConfiguredNetworks() async {
//     Database db = await instance.database;
//     var res = await db.query(tableConfiguredNetworks);
//     List<ConfiguredNetwork> list = [];
//     for (final cn in res) {
//       list.add(ConfiguredNetwork.fromJson(cn));
//     }
//
//     return list;
//   }
//
//   Future<int> addAvailableNetwork(AvailableNetwork an) async {
//     Database db = await instance.database;
//     try {
//       var res = await db.insert(tableAvailableNetworks, an.toJson());
//       return res;
//     } catch (e) {
//       debugPrint('error while adding Available network: $e');
//     }
//     return 0;
//   }
//
//   Future<List<AvailableNetwork>> getAvailableNetworks() async {
//     Database db = await instance.database;
//     var res = await db.query(tableAvailableNetworks);
//     List<AvailableNetwork> list = [];
//     for (final an in res) {
//       list.add(AvailableNetwork.fromJson(an));
//     }
//
//     return list;
//   }
//
//   Future<void> closeDb() async {
//     Database db = await instance.database;
//     await db.close();
//   }
// }
