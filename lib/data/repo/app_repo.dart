import 'package:pionixbox/data/models/available_network.dart';
import 'package:pionixbox/data/models/configured_network.dart';

abstract class AppRepo {
  ///
  ///
  Future<int> saveConfiguredNetworkLocally(ConfiguredNetwork cn);

  ///
  ///
  Future<List<ConfiguredNetwork>> fetchConfiguredNetworks();

  ///
  ///
  Future<int> saveAvailableNetworkLocally(AvailableNetwork an);

  ///
  ///
  Future<int> updateConfiguredNetworkLocally(ConfiguredNetwork cn);

  ///
  ///
  Future<List<AvailableNetwork>> fetchAvailableNetworks();
}
