import 'dart:io';

import 'package:display_app/widgets/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class AskRootPasswordScreen extends StatefulWidget {
  const AskRootPasswordScreen({super.key});

  @override
  State<AskRootPasswordScreen> createState() => _AskRootPasswordScreenState();
}

class _AskRootPasswordScreenState extends State<AskRootPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  bool keyboardVisible = true;
  bool wrongPassword = false;
  bool checkingPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
        title: Wrap(children: [
          Text(
            "Enter Password",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          Visibility(
              visible: checkingPassword,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ))
        ]),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                error: wrongPassword ? Text("wrong password") : null),
            onSubmitted: (input) {
              checkRootPassword(input, context);
            },
          ),
        ),
        Visibility(
          visible: keyboardVisible,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: PionixVirtualKeyboard(
              type: VirtualKeyboardType.Alphanumeric,
              customLayoutKeys: VirtualKeyboardPionixLayoutKeys(),
              onKeyPress: _onKeyPress,
              textController: _controller,
            ),
          ),
        )
      ]),
    );
  }

  _onKeyPress(PionixVirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.Action &&
        key.action == PionixVirtualKeyboardKeyAction.Return) {
      checkRootPassword(_controller.text, context);
    }
  }

  void checkRootPassword(String input, BuildContext context) async {
    setState(() {
      checkingPassword = true;
    });
    // this creates a script which prints the password to be used as ssh_akspass. this is no security issue however as this file can only be written or executed as root user and if we have an malicious root user we have other problems (eg runnning passwd (as root one does not need to input the current password))
    final String command =
        'touch /tmp/tmpscript.sh; chmod 300 /tmp/tmpscript.sh; echo "echo \'$input\'" > /tmp/tmpscript.sh;  SSH_ASKPASS="/tmp/tmpscript.sh" SSH_ASKPASS_REQUIRE=force ssh -o StrictHostKeyChecking=no root@localhost "echo Password check"'; // this was the only way to check as a root user if one types in the right password
    final ProcessResult process = await Process.run(
      'bash',
      ['-c', command],
    );
    if (process.exitCode == 0) {
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      setState(() {
        wrongPassword = true;
      });
    }
    setState(() {
      checkingPassword = false;
    });
  }
}
