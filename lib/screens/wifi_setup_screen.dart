import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pionixbox/screens/wifi_password_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';

class WifiSetupScreen extends StatefulWidget {
  const WifiSetupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WifiSetupScreen> createState() => _WifiSetupScreenState();
}

class _WifiSetupScreenState extends State<WifiSetupScreen> {
  bool _wifi = true;
  bool _showPasswordScreen = false;
  final mqtt = MQTT();
  String _selectedSSID = '';
  List<String> _ssids = [];
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    mqtt.subscribe(
        "everest_api/setup/var/wifi_info", parseAvailableNetworksInfo);
    super.initState();
  }

  void parseAvailableNetworksInfo(String message) {
    _ssids.clear();
    final networks = jsonDecode(message);
    for (final n in networks) {
      _ssids.add(n['ssid']);
    }
    setState(() {});
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
                            setState(() {
                              _wifi = val;
                            });
                          },
                          titleStyle: AppTextStyles.heading6
                              .copyWith(color: AppColors.primaryBlue),
                          title: 'Wifi',
                          value: _wifi,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.3,
                        child: ActionButtonWithTitleBar(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20),
                          onChanged: (val) {
                            setState(() {
                              _wifi = val;
                            });
                          },
                          titleStyle: AppTextStyles.heading6
                              .copyWith(color: AppColors.primaryBlue),
                          title: 'Scan',
                          icon: Icon(
                            Icons.wifi_protected_setup,
                            size: screenWidth * 0.03,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Container(
                      height: 1,
                      width: screenWidth * 0.1,
                      color: AppColors.primaryBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Available Networks',
                        style: AppTextStyles.subTitle4
                            .copyWith(color: AppColors.primaryBlue),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Expanded(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _ssids.length,
                      itemBuilder: (context, index) {
                        return _networkCardWidget(_ssids[index]);
                      }),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              alignment: Alignment.topRight,
              color: Colors.white,
              width: double.infinity,
              height: screenHeight * 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                width: 200,
                color: AppColors.primaryBlue,
                onPressed: () => Navigator.pop(context),
                title: 'Back',
              ),
            ),
          ),
          _showPasswordScreen
              ? WifiPasswordScreen(
                  passwordController: _passwordController,
                  passwordFocusNode: _passwordFocusNode,
                  onConnectPressed: () {
                    connectToNetwork();
                    _passwordController.clear();
                    setState(() {
                      _showPasswordScreen = false;
                    });
                  },
                  onBackPressed: () {
                    _passwordController.clear();
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

  Widget _networkCardWidget(String ssid) {
    return InkWell(
      onTap: () {
        _selectedSSID = ssid;
        setState(() {
          _showPasswordScreen = true;
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Icon(
                    Icons.wifi,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Expanded(
                    child: Text(
                  ssid,
                  style: AppTextStyles.heading3,
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.chevron_right,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            height: 0.2,
            width: double.infinity,
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  void connectToNetwork() async {
    if (_passwordController.text.isEmpty) {
      debugPrint('Please enter passworkd');
    } else {
      final psk = await _generatePSK(_passwordController.text);
      final payload =
          {"interface": "wlan0", "ssid": _selectedSSID, "psk": psk}.toString();
      mqtt.publish(Topic.addNetwork, payload);
    }
  }

  Future<String> _generatePSK(String password) async {
    final pbkdf2 =
        Pbkdf2(macAlgorithm: Hmac(Sha1()), iterations: 4096, bits: 256);

    List<int> password_bytes = utf8.encode(password);
    List<int> ssid_bytes = utf8.encode(_selectedSSID);

    final psk = await pbkdf2.deriveKey(
        secretKey: SecretKey(password_bytes), nonce: ssid_bytes);
    final psk_bytes = await psk.extractBytes();
    final psk_string = hex.encode(psk_bytes);

    print("PSK: " + psk_string);
    return psk_string;
  }
}
