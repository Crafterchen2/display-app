import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pionixbox/data/models/available_network.dart';
import 'package:pionixbox/data/models/configured_network.dart';
import 'package:pionixbox/data/repo/prod_repo.dart';
import 'package:pionixbox/screens/wifi_password_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/dialogs.dart';
import 'package:pionixbox/widgets/network_card_widget.dart';

import '../mqtt.dart';
import '../utils/constants/common.dart';
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
  bool _autoScan = false;
  bool _showPasswordScreen = false;
  bool optionsMenu = false;
  bool showConnectedDetails = false;
  final mqtt = MQTT();
  final appRepo = ProdRepo();
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

  @override
  void dispose() {
    disableWifiScanning();
    blockWifi();
    super.dispose();
  }

  void _connect() async {
    try {
      await mqtt.connect();
      scanWifi();
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
      final cn = ConfiguredNetwork(
          networkId: n['network_id'],
          ssid: n["ssid"],
          interface: n['interface'],
          isConnected: n['connected']);
      configuredNetworks.add(cn);
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: sectionedListView()),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  optionsMenu = true;
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.primaryBlue),
                margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.04,
                    horizontal: screenHeight * 0.05),
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.025,
                    horizontal: screenHeight * 0.03),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: screenHeight * 0.06,
                ),
              ),
            ),
          ),
          const PionixCloseButton(),
          optionsMenu
              ? Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: AppColors.primaryBlue,
                      width: screenWidth * 0.4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  optionsMenu = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.04,
                                    horizontal: screenWidth * 0.01),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: screenHeight * 0.08,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: SwitchSettingsButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.03,
                                    horizontal: screenHeight * 0.02),
                                onChanged: (val) {
                                  _wifi = val;
                                  if (val) {
                                    debugPrint('Unblocking the rfKill value');
                                    unblockWifi();
                                  } else {
                                    debugPrint('blocking the rfKill value');
                                    blockWifi();
                                  }
                                  setState(() {});
                                },
                                titleStyle: AppTextStyles.subTitle4.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                title: 'Wifi',
                                value: _wifi,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            SizedBox(
                              child: SwitchSettingsButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.03,
                                    horizontal: screenHeight * 0.02),
                                onChanged: (val) {
                                  _autoScan = val;
                                  if (val) {
                                    debugPrint('Enable wifi scanning');
                                    enableWifiScanning();
                                  } else {
                                    debugPrint('disable wifi scanning');
                                    disableWifiScanning();
                                  }
                                  setState(() {});
                                },
                                titleStyle: AppTextStyles.subTitle4.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                title: 'Auto Scan',
                                value: _autoScan,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              child: ActionButtonWithTitleBar(
                                margin: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.03,
                                    horizontal: screenHeight * 0.02),
                                onPressed: () {
                                  removeAllNetworks();
                                },
                                titleStyle: AppTextStyles.subTitle4.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                title: 'Reset',
                                icon: Icon(
                                  Icons.reset_tv,
                                  size: screenWidth * 0.03,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
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
    if (passwordController.text.isEmpty) {
      debugPrint('Please enter passworkd');
    } else {
      final psk = await generatePSK(_selectedSSID, passwordController.text);
      final payload =
          "{\"interface\": \"wlan0\", \"ssid\": \"$_selectedSSID\", \"psk\": \"$psk\"}";
      mqtt.publish(Topic.addNetwork, payload);
      Navigator.pop(context);
    }
  }

  void enableWifiScanning() {
    mqtt.publish(Topic.enableWifiScanning, '0');
  }

  void disableWifiScanning() {
    mqtt.publish(Topic.disableWifiScanning, '0');
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

  void removeNetworks(String interface, int networkId) {
    final payload = "{\"interface\": \"wlan0\", \"network_id\": $networkId}";
    mqtt.publish(Topic.removeNetwork, payload);
  }

  void scanWifi() {
    /// calling twice to make sure its going through all available frequencies
    mqtt.publish(Topic.scanWifi, '');
    mqtt.publish(Topic.scanWifi, '');
  }

  Future<void> confirmationDialog(BuildContext context,
      {required ConfiguredNetwork cn}) async {
    showDialog(
        context: context,
        builder: (ctz) {
          return BasicDialog(
              title: cn.ssid,
              positiveText: 'Disconnect',
              negativeText: 'Cancel',
              content: 'Disconnecting this network',
              onPositivePressed: () {
                removeNetworks(cn.interface, cn.networkId);
                Navigator.pop(context);
                PionixSnackBar.errorSnackBar(context, '$_selectedSSID disconnected');
              },
              onNegativePressed: () {
                Navigator.pop(context);
              });
        });
  }

  Widget sectionedListView() {
    List<Widget> items = [];
    if (configuredNetworks.isNotEmpty) {
      items.add(Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward,
                  color: AppColors.primaryBlue.withOpacity(0.1)),
              Text(
                'Pull to rescan',
                style: AppTextStyles.subTitle4
                    .copyWith(color: AppColors.primaryBlue.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      ));
      // items.add(const ListSectionLabel(label: 'Configured Networks'));
      final ids = configuredNetworks.map((e) => e.ssid).toSet();
      configuredNetworks.retainWhere((element) => ids.remove(element.ssid));
      for (final cn in configuredNetworks) {
        items.add(NetworkCardWidget(
          ssid: cn.ssid.isNotEmpty ? cn.ssid : 'Hidden SSID',
          isConnected: cn.isConnected,
          onPressed: () async {
            _selectedSSID = cn.ssid;
            if (cn.isConnected) {
              await confirmationDialog(context, cn: cn);
              // removeNetworks(cn.interface, cn.networkId);
              // PionixSnackBar.errorSnackBar(context, 'Removing Network');
            } else {
              _showPasswordScreen = true;
            }
            setState(() {});
          },
        ));
      }
    }
    if (availableNetworks.isNotEmpty) {
      // items.add(const ListSectionLabel(label: 'Available Networks'));
      final ids = availableNetworks.map((e) => e.ssid).toSet();
      availableNetworks.retainWhere((element) => ids.remove(element.ssid));
      availableNetworks
          .sort((a, b) => b.signal_level.compareTo(a.signal_level));
      for (final an in availableNetworks) {
        items.add(NetworkCardWidget(
          ssid: an.ssid.isNotEmpty ? an.ssid : 'Hidden SSID',
          isConnected: an.ssid == connectedSsid,
          signalLevel: an.signal_level,
          strengthColor: checkSignalStrengthColor(an.signal_level),
          // strength: checkSignalStrength(an.signal_level) +
          //     ' ' +
          //     '(' +
          //     an.signal_level.toString() +
          //     ')',
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
        ? RefreshIndicator(
            onRefresh: () async {
              scanWifi();
            },
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (builder, index) {
                  return items[index];
                }),
          )
        : Center(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.3,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _wifi = true;
                  unblockWifi();
                  scanWifi();
                  setState(() {});
                },
                child: Text(
                  'Tap here to turn the Wifi ON'.toUpperCase(),
                  style: AppTextStyles.subTitle4
                      .copyWith(color: AppColors.primaryAmber),
                ),
              ),
            ),
          );
  }
}
