import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../theme/app_colors.dart';
import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';

class WifiPasswordScreen extends StatefulWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onBackPressed;
  final VoidCallback onConnectPressed;

  const WifiPasswordScreen({
    Key? key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onBackPressed,
    required this.onConnectPressed,
  }) : super(key: key);

  @override
  State<WifiPasswordScreen> createState() => _WifiPasswordScreenState();
}

class _WifiPasswordScreenState extends State<WifiPasswordScreen> {
  bool _showKeyboard = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  // height: screenHeight * 0.1,
                  width: double.infinity,
                  child: IconTextField(
                    hintText: 'Enter Password',
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
              !_showKeyboard
                  ? const Spacer()
                  : SizedBox(height: screenHeight * 0.05),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  width: double.infinity,
                  height: screenHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryButton(
                        width: screenWidth * 0.3,
                        color: AppColors.primaryAmber,
                        onPressed: () {
                          _showKeyboard = false;
                          widget.onBackPressed();
                          debugPrint('on back Pressed');
                        },
                        title: 'Back',
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        width: screenWidth * 0.3,
                        color: AppColors.primaryAmber,
                        onPressed: widget.onConnectPressed,
                        title: 'Connect',
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _showKeyboard
              ? Container(
                  color: AppColors.primaryBlue,
                  child: VirtualKeyboard(
                      height: screenHeight * 0.4,
                      fontSize: screenHeight * 0.04,
                      textColor: Colors.white,
                      textController: widget.passwordController,
                      defaultLayouts: const [
                        VirtualKeyboardDefaultLayouts.English
                      ],
                      type: VirtualKeyboardType.Alphanumeric,
                      onKeyPress: (key) => _onKeyPress(key)),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Return:
          setState(() {
            _showKeyboard = false;
          });

          debugPrint('Enter key pressed');
          break;
        default:
      }
    }
  }
}
