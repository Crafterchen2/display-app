// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:pionixbox/data/models/available_network.dart';
// import 'package:pionixbox/data/models/configured_network.dart';
//
// import '../local/db_helper.dart';
// import 'app_repo.dart';
//
// ///
// ///
// class ProdRepo implements AppRepo {
//   @override
//   Future<List<AvailableNetwork>> fetchAvailableNetworks() async {
//     debugPrint('Runninng fetch Available Networks');
//     final result = await DbHelper.instance.getAvailableNetworks();
//     debugPrint(result.length.toString());
//     return result;
//   }
//
//   @override
//   Future<List<ConfiguredNetwork>> fetchConfiguredNetworks() async {
//     debugPrint('Runninng fetch Configured Networks');
//     final result = await DbHelper.instance.getConfiguredNetworks();
//     debugPrint(result.length.toString());
//     return result;
//   }
//
//   @override
//   Future<int> saveAvailableNetworkLocally(AvailableNetwork an) async {
//     final success = await DbHelper.instance.addAvailableNetwork(an);
//     if (success == 1) {
//       debugPrint('Available Network Successfully added locally');
//     }
//     return success;
//   }
//
//   @override
//   Future<int> saveConfiguredNetworkLocally(ConfiguredNetwork cn) async {
//     final success = await DbHelper.instance.addConfiguredNetwork(cn);
//     if (success == 1) {
//       debugPrint('Configured Network Successfully added locally');
//     }
//     return success;
//   }
//
//   @override
//   Future<int> updateConfiguredNetworkLocally(ConfiguredNetwork cn) async {
//     final success = await DbHelper.instance.updateConfiguredNetwork(cn);
//     if (success == 1) {
//       debugPrint('Configured Network Successfully updated');
//     }
//     return success;
//   }
// }
