import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/widgets/keyboard.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';

class WifiPasswordScreen extends StatefulWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onBackPressed;
  final VoidCallback onConnectPressed;
  final VoidCallback onForgetPressed;
  final String ssid;
  final bool isSaved;

  const WifiPasswordScreen({
    Key? key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onBackPressed,
    required this.onConnectPressed,
    required this.onForgetPressed,
    required this.ssid,
    required this.isSaved,
  }) : super(key: key);

  @override
  State<WifiPasswordScreen> createState() => _WifiPasswordScreenState();
}

class _WifiPasswordScreenState extends State<WifiPasswordScreen> {
  bool _showKeyboard = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.ssid,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: IconTextField(
                    hintText: 'enter_password'.tr(),
                    onTap: () {
                      setState(() {
                        _showKeyboard = true;
                      });
                    },
                    icon: Icon(
                      Icons.vpn_key,
                      color: Colors.grey.shade400,
                      size: 28,
                    ),
                    controller: widget.passwordController,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.isSaved)
                        PrimaryButton(
                          //width: screenWidth * 0.3,
                          onPressed: () {
                            _showKeyboard = false;
                            widget.onForgetPressed();
                          },
                          child: Text('forget'.tr()),
                        ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        //width: screenWidth * 0.3,
                        onPressed: () {
                          _showKeyboard = false;
                          widget.onBackPressed();
                          debugPrint('on back Pressed');
                        },
                        child: Text('back'.tr()),
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        //width: screenWidth * 0.3,
                        onPressed: widget.onConnectPressed,
                        child: Text('connect'.tr()),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _showKeyboard
              ? OrientationBuilder(builder: (context, orientation) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        orientation == Orientation.landscape
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: PionixVirtualKeyboard(
                                    height: 300,
                                    fontSize: 32,
                                    textColor: Theme.of(context).colorScheme.primary,
                                    textController: widget.passwordController,
                                    customLayoutKeys:
                                        VirtualKeyboardPionixLayoutKeys(),
                                    type: VirtualKeyboardType.Alphanumeric,
                                    onKeyPress: (key) => _onKeyPress(key)),
                              )
                            : Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: PionixVirtualKeyboard(
                                    height: 500,
                                    fontSize: 32,
                                    textColor:
                                        Theme.of(context).colorScheme.primary,
                                    textController: widget.passwordController,
                                    defaultLayouts: const [
                                      VirtualKeyboardDefaultLayouts.English
                                    ],
                                    type: VirtualKeyboardType.Alphanumeric,
                                    onKeyPress: (key) => _onKeyPress(key)),
                              )
                      ],
                  );
                },
          )
              : const SizedBox(),
        ],
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(PionixVirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case PionixVirtualKeyboardKeyAction.Return:
          setState(() {
            _showKeyboard = false;
          });

          debugPrint('Enter key pressed');
          break;
        case PionixVirtualKeyboardKeyAction.SwitchLanguage:
          debugPrint("Switch language");
          break;
        default:
      }
    }
  }
}
