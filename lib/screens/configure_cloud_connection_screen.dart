import 'package:display_app/utils/pionix_cloud_manager.dart';
import 'package:display_app/widgets/keyboard.dart';
import 'package:display_app/widgets/pionix_input_field.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

/// a config file for debugging
String debugConfig = """
address="sc-debug-mqtt.schoneberg.pionix.net:443"

hostname="sc-production.schoneberg.pionix.net"

# Enrolment server credentials
username="pionix_debug"
password="supersecretpassword1234"

manufacturer_id="debugDev"

id_file="/etc/charger_id"
id_mac="eth0"

# alternatively set the ID here
# charger_id=
""";

class ConfigureCloudConnectionScreen extends StatefulWidget {
  const ConfigureCloudConnectionScreen({super.key});
  static var matchUrlWithPort = RegExp(r"[\d\w]+(\.[\d\w]+)*:(\d)+");
  static var matchHostname = RegExp(r"[\d\w]+(\.[\d\w]+)*");

  @override
  State<ConfigureCloudConnectionScreen> createState() =>
      _ConfigureCloudConnectionScreenState();
}

/// a generic form validator to check if the provided input matches a regex
FormFieldValidator<String> regexValidator(
  RegExp mustMatch, {
  String onEmpty = "please provide an input",
  String onNotMatching = "input is invalid",
}) {
  return (String? value) {
    if (value == null || value.isEmpty) {
      return onEmpty;
    }
    if (!mustMatch.hasMatch(value)) {
      return onNotMatching;
    }
    return null;
  };
}

var noSpacesAllowedValidator = regexValidator(RegExp("^[^\\s]*\$"),
    onNotMatching: "the input cant contain spaces");

class _ConfigureCloudConnectionScreenState
    extends State<ConfigureCloudConnectionScreen> {
  final _formKey = GlobalKey<FormState>();

  bool overrideId = false;

  bool shiftEnabled = false;

  TextEditingController? inputController = TextEditingController();
  bool keyboardVisible = false;

  ScrollController scrollController = ScrollController();

  PionixCloudManager? config;

  late Widget cloudAddressInputField;
  late Widget cloudHostnameInputField;
  late Widget enrollmentUsernameInputField;
  late Widget enrollmentPasswordInputField;
  late Widget manufacturerIdInputField;
  late TextEditingController chargerIdcontroller;

  static const double height = 56;
  double additionalScrollDownLenght = height * 6;

  void openKeyboard(TextEditingController textFieldController) {
    inputController = textFieldController;
    keyboardVisible = true;
    setState(() {});
  }

  void Function(TextEditingController) openKeyboardAndScrollDownTo(
      double down) {
    void inner(TextEditingController textFieldController) {
      scrollTo(down);
      setState(() {});
      openKeyboard(textFieldController);
    }

    return inner;
  }

  void scrollTo(double scroll) {
    scrollController.animateTo(scroll,
        duration: const Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    try {
      //disable this for debugging:
      config = PionixCloudManager.loadFile(cloudConfigFile);

      // for debugging only:
      // config = PionixCloudManager(debugConfig);

      cloudAddressInputField = PionixInputField(
        icon: Icons.cloud,
        label: 'mqtt server with port address',
        initialText: config!.address,
        validator: regexValidator(
          ConfigureCloudConnectionScreen.matchUrlWithPort,
          onEmpty: "Please enter an address",
          onNotMatching: "Please enter a valid address with port number",
        ),
        onSaved: (value) {
          config!.address = value;
        },
        onTap: openKeyboardAndScrollDownTo(0),
      );

      cloudHostnameInputField = PionixInputField(
        icon: Icons.cloud,
        label: "hostname of the server",
        initialText: config!.hostname,
        validator: regexValidator(
          ConfigureCloudConnectionScreen.matchHostname,
          onEmpty: "Please enter a hostname",
          onNotMatching: "Please enter a valid hostname",
        ),
        onSaved: (value) {
          config!.hostname = value;
        },
        onTap: openKeyboardAndScrollDownTo(height),
      );

      enrollmentUsernameInputField = PionixInputField(
        icon: Icons.person,
        label: "username for enrollment server",
        initialText: config!.username,
        onSaved: (value) {
          config!.username = value;
        },
        validator: noSpacesAllowedValidator,
        onTap: openKeyboardAndScrollDownTo(height * 2),
      );

      enrollmentPasswordInputField = PionixInputField(
        icon: Icons.key,
        label: "password for enrollment server",
        initialText: config!.password,
        onSaved: (value) {
          config!.password = value;
        },
        onTap: openKeyboardAndScrollDownTo(height * 3),
      );

      manufacturerIdInputField = PionixInputField(
        icon: Icons.numbers,
        label: "manufacturer id",
        initialText: config!.manufacturerId,
        validator: noSpacesAllowedValidator,
        onSaved: (value) {
          config!.manufacturerId = value;
        },
        onTap: openKeyboardAndScrollDownTo(height * 4),
      );

      chargerIdcontroller = TextEditingController(
        text: config!.chargerId ?? "currently_not_defined",
      );
    } catch (e) {
      config = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Connect to Cloud'),
      ),
      body: (config == null)
          ? Center(
              child: Text(
                "Cloud connection not available",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            )
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    children: <Widget>[
                      cloudAddressInputField,
                      cloudHostnameInputField,
                      enrollmentUsernameInputField,
                      enrollmentPasswordInputField,
                      manufacturerIdInputField,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Checkbox(
                            value: overrideId,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                overrideId = !overrideId;
                              });
                            }),
                      ),
                      PionixInputField(
                        icon: Icons.numbers,
                        label:
                            "id for this charger (make sure this is unique or bad stuff will happen)",
                        enabled: overrideId,
                        onSaved: (value) {
                          config!.chargerId = value;
                        },
                        validator: noSpacesAllowedValidator,
                        onTap: openKeyboardAndScrollDownTo(height * 6),
                        providedController: chargerIdcontroller,
                      ),
                      ElevatedButton(
                        onPressed: _formKey.currentState?.validate() ?? false
                            ? () {
                                if (!overrideId) {
                                  config!.chargerId = null;
                                }
                                config!.configure();
                                debugPrint("connect to cloud");
                              }
                            : null,
                        child: Text("Connect to Cloud"),
                      ),
                      SizedBox(
                        height: additionalScrollDownLenght,
                      ),
                    ],
                  ),
                ),
                keyboardVisible
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Theme.of(context).colorScheme.secondary,
                          child: PionixVirtualKeyboard(
                            textController: inputController,
                            type: VirtualKeyboardType.Alphanumeric,
                            specialCharacters: true,
                            onKeyPress: _onkeyPress,
                          ),
                        ))
                    : SizedBox.shrink()
              ],
            ),
    );
  }

  void _onkeyPress(PionixVirtualKeyboardKey key) {
    if (key.action == PionixVirtualKeyboardKeyAction.Return) {
      inputController = null;
      keyboardVisible = false;
      setState(() {});
    }
  }
}
