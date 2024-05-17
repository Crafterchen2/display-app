import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:pionixbox/data/models/available_network.dart';
import 'package:pionixbox/data/models/configured_network.dart';
import 'package:pionixbox/data/models/saved_network.dart';
import 'package:pionixbox/data/providers/ap_state_provider.dart';
import 'package:pionixbox/screens/wifi_password_screen.dart';
import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/dialogs.dart';
import 'package:pionixbox/widgets/network_card_widget.dart';

import '../data/models/network_device_info.dart';
import '../main.dart';
import '../mqtt.dart';
import '../utils/constants/helper.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';
import 'landing_screen.dart';

class WifiSetupScreen extends ConsumerStatefulWidget {
  const WifiSetupScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<WifiSetupScreen> createState() => _WifiSetupScreenState();
}

class _WifiSetupScreenState extends ConsumerState<WifiSetupScreen> {
  String connectedSsid = 'Not Specified';
  bool _wifi = false;
  bool _ap = false;
  bool _showPasswordScreen = false;
  bool optionsMenu = false;
  bool showConnectedDetails = false;
  final mqtt = MQTT();
  String _selectedSSID = '';
  List<AvailableNetwork> availableNetworks = [];
  List<ConfiguredNetwork> configuredNetworks = [];
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  List<NetworkDeviceInfo> devices = [];
  bool initialisingScreen = false;
  bool bannerVisible = false;
  String bannerText = "";
  String apStateString = "unknown";

  @override
  void didChangeDependencies() {
    extractArguments(context);
    _connect();
    super.didChangeDependencies();
  }

  void extractArguments(BuildContext context) {
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    initialisingScreen = i["init"];
    setState(() {});
  }

  @override
  void dispose() {
    disableWifiScanning();
    checkOnlineStatus();
    super.dispose();
  }

  void _connect() async {
    try {
      await mqtt.connect();
      mqtt.subscribe(
          "everest_api/setup/var/wifi_info", parseAvailableNetworksInfo);
      mqtt.subscribe("everest_api/setup/var/configured_networks",
          parseConfiguredNetworksInfo);

      mqtt.subscribe(
          "everest_api/setup/var/network_device_info", networkDeviceInfo);

      enableWifiScanning();
      scanWifi();
      listConfiguredNetworks();
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  void networkDeviceInfo(String message) {
    final deviceInfo = jsonDecode(message);
    devices.clear();
    for (final d in deviceInfo) {
      final device = NetworkDeviceInfo.fromJson(d);

      if (device.wireless && device.blocked == false) {
        if (mounted) {
          setState(
            () {
              _wifi = true;
            },
          );
        }

        break;
      }

      devices.add(device);
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

  void filterAvailableNetworks() {
    for (final item in configuredNetworks) {
      availableNetworks.removeWhere((element) => element.ssid == item.ssid);
    }
  }

  void filterConfiguredNetworks() {}

  void parseAvailableNetworksInfo(String message) {
    availableNetworks.clear();
    final networks = jsonDecode(message);
    for (final n in networks) {
      availableNetworks
          .add(AvailableNetwork(n['ssid'], n["frequency"], n['signal_level']));
    }
    filterAvailableNetworks();
    if (mounted) {
      setState(() {});
    }
  }

  void showBanner(String title) {
    bannerText = title;
    bannerVisible = true;
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          setState(
            () {
              bannerVisible = false;
              bannerText = "";
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final apState =
        ref.watch(apStateStreamProvider).whenOrNull(data: (data) => data);
    if (apState != null) {
      apStateString = apState;
      if (apStateString == "enabled") {
        _ap = true;
        _wifi = true;
      } else if (apStateString == "disabled") {
        _ap = false;
      }
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton:
          !_showPasswordScreen ? const PionixCloseButton() : null,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: sectionedListView()),
            ],
          ),
          initialisingScreen
              ? Align(
                  //This seems like duplicated code. needs investigation.
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    height: screenHeight * 0.2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SecondaryButton(
                            title: 'close'.tr(),
                            borderColor:
                                Theme.of(context).colorScheme.errorContainer,
                            textColor:
                                Theme.of(context).colorScheme.errorContainer,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            //width: screenWidth * 0.2,
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          PrimaryButton(
                            child: const Text('Add LAN'),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                  ),
                                ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.lanInfoScreen,
                                arguments: {
                                  'init': true,
                                },
                              );
                            },
                            //width: screenWidth * 0.3,
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          PrimaryButton(
                            child: const Text('Done with SETUP'),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                  ),
                                ),
                            onPressed: () {
                              setInitialized();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const LandingScreen();
                                  },
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Visibility(
                  visible: bannerVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      bannerText,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                    ),
                  ),
                ),
          _showPasswordScreen
              ? WifiPasswordScreen(
                  ssid: _selectedSSID,
                  isSaved: getSavedNetworkFromSSID(_selectedSSID) != null,
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
                  onForgetPressed: () async {
                    final savedNetwork = getSavedNetworkFromSSID(_selectedSSID);
                    if (savedNetwork != null) {
                      await forgetConfirmationDialog(context,
                          interface: savedNetwork.interface,
                          networkId: savedNetwork.network_id,
                          ssid: _selectedSSID);
                    }
                    passwordController.clear();
                    setState(() {
                      _showPasswordScreen = false;
                    });
                  })
              : const SizedBox(),
        ],
      ),
    );
  }

  void connectToNetwork(BuildContext context) async {
    if (passwordController.text.isEmpty) {
      debugPrint('Please enter password'); // FIXME: add a dialog here
    } else {
      // first try to remove an existing network
      {
        final savedNetwork = getSavedNetworkFromSSID(_selectedSSID);
        if (savedNetwork != null) {
          debugPrint(
              "Removing existing network $_selectedSSID with network id ${savedNetwork.network_id}");
          removeNetwork(savedNetwork.interface, savedNetwork.network_id);
        }
      }
      final psk = await generatePSK(_selectedSSID, passwordController.text);
      final payload =
          "{\"interface\": \"wlan0\", \"ssid\": \"$_selectedSSID\", \"psk\": \"$psk\"}";
      mqtt.publish(Topic.addNetwork, payload);
      debugPrint("Added network $_selectedSSID");
      final savedNetwork = getSavedNetworkFromSSID(_selectedSSID);
      if (savedNetwork != null) {
        debugPrint(
            "Selecting network $_selectedSSID with network id ${savedNetwork.network_id}");
        final payloadSelectNetwork =
            "{\"interface\": \"${savedNetwork.interface}\", \"network_id\": ${savedNetwork.network_id}}";
        selectNetwork(payloadSelectNetwork);
      }
    }
  }

  SavedNetwork? getSavedNetworkFromSSID(String ssid) {
    final network =
        configuredNetworks.firstWhereOrNull((element) => element.ssid == ssid);
    if (network == null) {
      return null;
    }
    return SavedNetwork(
        network_id: network.networkId, interface: network.interface);
  }

  void enableNetwork(String payload) {
    mqtt.publish(Topic.enableNetwork, payload);
  }

  void disableNetwork(String interface, int networkId) {
    final payload = "{\"interface\": \"wlan0\", \"network_id\": $networkId}";
    mqtt.publish(Topic.disableNetwork, payload);
  }

  void selectNetwork(String payload) {
    mqtt.publish(Topic.selectNetwork, payload);
  }

  void enableWifiScanning() {
    mqtt.publish(Topic.enableWifiScanning, '0');
  }

  void disableWifiScanning() {
    mqtt.publish(Topic.disableWifiScanning, '0');
  }

  void checkOnlineStatus() {
    mqtt.publish(Topic.checkOnlineStatus, '');
  }

  void blockWifi() {
    mqtt.publish(Topic.blockWifi, '0');
  }

  void unblockWifi() {
    mqtt.publish(Topic.unblockWifi, '0');
  }

  void enableAp() {
    mqtt.publish(Topic.enableAp, '0');
  }

  void disableAp() {
    mqtt.publish(Topic.disableAp, '0');
  }

  void listConfiguredNetworks() {
    mqtt.publish(Topic.listConfiguredNetworks, '');
  }

  void removeAllNetworks() {
    mqtt.publish(Topic.removeAllNetworks, '');
    configuredNetworks.clear();
  }

  void setInitialized() {
    mqtt.publish(Topic.setInitialized, 'true');
  }

  void removeNetwork(String interface, int networkId) {
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
              positiveText: 'disconnect'.tr(),
              negativeText: 'cancel'.tr(),
              content: 'disconnect_this_network'.tr(),
              onPositivePressed: () {
                disableNetwork(cn.interface, cn.networkId);
                Navigator.pop(context);
                showBanner('$_selectedSSID disconnected');
              },
              onNegativePressed: () {
                Navigator.pop(context);
              });
        });
  }

  Future<void> forgetConfirmationDialog(BuildContext context,
      {required String ssid,
      required String interface,
      required int networkId}) async {
    showDialog(
        context: context,
        builder: (ctz) {
          return BasicDialog(
              title: ssid,
              positiveText: 'forget'.tr(),
              negativeText: 'cancel'.tr(),
              content: 'forget_this_network'.tr(),
              onPositivePressed: () {
                removeNetwork(interface, networkId);

                passwordController.clear();
                setState(() {
                  _showPasswordScreen = false;
                });
                Navigator.pop(context);
              },
              onNegativePressed: () {
                Navigator.pop(context);
              });
        });
  }

  Widget sectionedListView() {
    List<Widget> items = [];
    if (configuredNetworks.isNotEmpty) {
      // items.add(const ListSectionLabel(label: 'Configured Networks'));
      final ids = configuredNetworks.map((e) => e.ssid).toSet();
      configuredNetworks.retainWhere((element) => ids.remove(element.ssid));
      for (final cn in configuredNetworks) {
        items.add(NetworkCardWidget(
          ssid: cn.ssid.isNotEmpty ? cn.ssid : 'Hidden SSID',
          isConnected: cn.isConnected,
          isSaved: getSavedNetworkFromSSID(cn.ssid) != null,
          onPressed: () async {
            _selectedSSID = cn.ssid;
            if (cn.isConnected) {
              await confirmationDialog(context, cn: cn);
              // PionixSnackBar.infoSnackBar(context, 'Removing Network');
            } else {
              final payload =
                  "{\"interface\": \"${cn.interface}\", \"network_id\": ${cn.networkId}}";
              enableNetwork(payload);
              selectNetwork(payload);
              showBanner('Connecting to network $_selectedSSID');
            }
            setState(() {});
          },
          onSavedPressed: () {
            debugPrint("on saved pressed");
            _selectedSSID = cn.ssid;
            setState(() {
              _showPasswordScreen = true;
            });
          },
        ));
      }
    }
    if (availableNetworks.isNotEmpty) {
      final ids = availableNetworks.map((e) => e.ssid).toSet();
      availableNetworks.retainWhere((element) => ids.remove(element.ssid));
      availableNetworks
          .sort((a, b) => b.signal_level.compareTo(a.signal_level));
      for (final an in availableNetworks) {
        items.add(NetworkCardWidget(
          ssid: an.ssid.isNotEmpty ? an.ssid : 'Hidden SSID',
          isConnected: an.ssid == connectedSsid,
          isSaved: getSavedNetworkFromSSID(an.ssid) != null,
          signalLevel: an.signal_level,
          strengthColor: checkSignalStrengthColor(an.signal_level),
          onPressed: () {
            _selectedSSID = an.ssid;
            setState(() {
              _showPasswordScreen = true;
            });
          },
          onSavedPressed: () {
            debugPrint("on saved pressed");
            _selectedSSID = an.ssid;
            setState(() {
              _showPasswordScreen = true;
            });
          },
        ));
      }
      items.add(SizedBox(
        height: screenHeight * 0.3,
      ));
    }
    return Column(children: [
      Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Container(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 8.0,
                  ),
                  child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'ap'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                              Switch(
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                value: _ap,
                                onChanged: (val) {
                                  _wifi = val || true;
                                  _ap = val;
                                  if (val) {
                                    debugPrint('enable AP');
                                    unblockWifi();
                                    enableAp();
                                  } else {
                                    debugPrint('disable AP');
                                    disableAp();
                                  }
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'wifi'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                              Switch(
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                value: _wifi,
                                onChanged: (val) {
                                  _wifi = val;
                                  if (val) {
                                    debugPrint('Unblocking the rfKill value');
                                    unblockWifi();
                                    enableWifiScanning();
                                  } else {
                                    debugPrint('blocking the rfKill value');
                                    _ap = false;
                                    disableAp();
                                    blockWifi();
                                    disableWifiScanning();
                                  }
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                        ],
                      )))),
          if (_wifi)
            SizedBox(
              width: screenWidth,
              child: LinearProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                minHeight: 5,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
        ],
      ),
      if (_wifi)
        Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (builder, index) {
                  return items[index];
                }))
      else
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              'please_enable_wifi'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
    ]);
  }
}
