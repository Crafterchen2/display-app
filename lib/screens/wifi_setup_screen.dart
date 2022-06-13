import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pionixbox/data/local/app_shared_preferences.dart';
import 'package:pionixbox/data/models/available_network.dart';
import 'package:pionixbox/data/models/configured_network.dart';
import 'package:pionixbox/data/repo/prod_repo.dart';
import 'package:pionixbox/screens/wifi_password_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/network_card_widget.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/helper.dart';
import '../widgets/list_section_label.dart';

class WifiSetupScreen extends StatefulWidget {
  const WifiSetupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WifiSetupScreen> createState() => _WifiSetupScreenState();
}

class _WifiSetupScreenState extends State<WifiSetupScreen> {
  String connectedSsid = 'Not Specified';
  bool _wifi = false;
  bool _showPasswordScreen = false;
  final mqtt = MQTT();
  final appRepo = ProdRepo();
  List<ConfiguredNetwork> localCNs = [];
  String _selectedSSID = '';
  List<AvailableNetwork> availableNetworks = [];
  List<ConfiguredNetwork> configuredNetworks = [];
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    _connect();
    super.initState();
  }

  void _connect() async {
    connectedSsid = await AppSharedPreferences().getConnectedSSID();
    try {
      localCNs = await appRepo.fetchConfiguredNetworks();
      await mqtt.connect();
      mqtt.subscribe(
          "everest_api/setup/var/wifi_info", parseAvailableNetworksInfo);
      listConfiguredNetworks();
      mqtt.subscribe("everest_api/setup/var/configured_networks",
          parseConfiguredNetworksInfo);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  void parseConfiguredNetworksInfo(String message) {
    configuredNetworks.clear();
    final networks = jsonDecode(message);
    for (final n in networks) {
      final cn = ConfiguredNetwork(networkId: n['network_id'], ssid: n["ssid"]);
      configuredNetworks.add(cn);
      final existing =
          localCNs.firstWhere((element) => element.ssid == cn.ssid);
      if (existing == null) {
        appRepo.saveConfiguredNetworkLocally(cn);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void parseAvailableNetworksInfo(String message) {
    availableNetworks.clear();
    final networks = jsonDecode(message);
    for (final n in networks) {
      availableNetworks
          .add(AvailableNetwork(n['ssid'], n["frequency"], n['signal_level']));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.3,
                        child: SwitchSettingsButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20),
                          onChanged: (val) {
                            _wifi = val;
                            if (val) {
                              unblockWifi();
                            } else {
                              blockWifi();
                            }
                            setState(() {});
                          },
                          titleStyle: AppTextStyles.heading6
                              .copyWith(color: AppColors.primaryBlue),
                          title: 'Wifi',
                          value: _wifi,
                        ),
                      ),
                      AbsorbPointer(
                        absorbing: _wifi,
                        child: SizedBox(
                          width: screenWidth * 0.3,
                          child: ActionButtonWithTitleBar(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20),
                            onPressed: () {
                              debugPrint('Pressed');
                              // removeAllNetworks();
                            },
                            titleStyle: AppTextStyles.heading6
                                .copyWith(color: AppColors.primaryBlue),
                            title: 'Reset',
                            icon: Icon(
                              Icons.reset_tv,
                              size: screenWidth * 0.03,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: sectionedListView()),
              ],
            ),
          ),
          const PionixCloseButton(),
          _showPasswordScreen
              ? WifiPasswordScreen(
                  passwordController: passwordController,
                  passwordFocusNode: passwordFocusNode,
                  onConnectPressed: () {
                    connectToNetwork(context);
                    passwordController.clear();
                    setState(() {
                      _showPasswordScreen = false;
                    });
                  },
                  onBackPressed: () {
                    passwordController.clear();
                    setState(() {
                      _showPasswordScreen = false;
                    });
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void connectToNetwork(BuildContext context) async {
    final pref = AppSharedPreferences();
    if (passwordController.text.isEmpty) {
      debugPrint('Please enter passworkd');
    } else {
      final psk = await generatePSK(_selectedSSID, passwordController.text);
      final payload =
          "{\"interface\": \"wlan0\", \"ssid\": \"$_selectedSSID\", \"psk\": \"$psk\"}";
      mqtt.publish(Topic.addNetwork, payload);
      pref.updateWifiConnection(_selectedSSID);
      // final existing =
      //     localCNs.firstWhere((element) => element.ssid == _selectedSSID);
      // if (existing == null) {
      //   appRepo.saveConfiguredNetworkLocally(ConfiguredNetwork(
      //       networkId: localCNs.length,
      //       ssid: _selectedSSID,
      //       password: passwordController.text,
      //       psk: psk,
      //       isConnected: 1));
      // } else {
      //   appRepo.saveConfiguredNetworkLocally(ConfiguredNetwork(
      //       networkId: existing.networkId,
      //       ssid: existing.ssid,
      //       password: passwordController.text,
      //       psk: psk,
      //       isConnected: 1));
      // }
      Navigator.pop(context);
    }
  }

  void blockWifi() {
    mqtt.publish(Topic.blockWifi, '0');
  }

  void unblockWifi() {
    mqtt.publish(Topic.unblockWifi, '0');
  }

  void listConfiguredNetworks() {
    mqtt.publish(Topic.listConfiguredNetworks, '');
  }

  void removeAllNetworks() {
    mqtt.publish(Topic.removeAllNetworks, '');
    configuredNetworks.clear();
  }

  Widget sectionedListView() {
    List<Widget> items = [];
    if (configuredNetworks.isNotEmpty) {
      items.add(const ListSectionLabel(label: 'Configured Networks'));
      final ids = configuredNetworks.map((e) => e.ssid).toSet();
      configuredNetworks.retainWhere((element) => ids.remove(element.ssid));
      for (final cn in configuredNetworks) {
        items.add(NetworkCardWidget(
          ssid: cn.ssid.isNotEmpty ? cn.ssid : 'Hidden SSID',
          isConnected: cn.ssid == connectedSsid,
          onPressed: () {
            _selectedSSID = cn.ssid;
            setState(() {
              _showPasswordScreen = true;
            });
          },
        ));
      }
    }
    if (availableNetworks.isNotEmpty) {
      items.add(const ListSectionLabel(label: 'Available Networks'));
      final ids = availableNetworks.map((e) => e.ssid).toSet();
      availableNetworks.retainWhere((element) => ids.remove(element.ssid));
      for (final an in availableNetworks) {
        items.add(NetworkCardWidget(
          ssid: an.ssid.isNotEmpty ? an.ssid : 'Hidden SSID',
          isConnected: an.ssid == connectedSsid,
          onPressed: () {
            _selectedSSID = an.ssid;
            setState(() {
              _showPasswordScreen = true;
            });
          },
        ));
      }
    }
    return _wifi
        ? ListView.builder(
            itemCount: items.length,
            itemBuilder: (builder, index) {
              return items[index];
            })
        : Center(
            child: Text(
              'Please turn on wifi',
              style: AppTextStyles.subTitle4.copyWith(color: Colors.grey),
            ),
          );
  }
}
