import 'dart:io';

import 'package:display_app/screens/cloud_info_screen.dart';
import 'package:display_app/utils/pionix_cloud_manager.dart';
import 'package:display_app/widgets/empty.dart';
import 'package:display_app/widgets/keyboard.dart';
import 'package:display_app/widgets/logging.dart';
import 'package:display_app/widgets/pionix_input_field.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../utils/routing/app_router.dart';
import '../widgets/buttons.dart';

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

class AdvancedConfigProvider extends StatefulWidget {

  final EnrollMode mode;

  const AdvancedConfigProvider({
    super.key,
    this.mode = EnrollMode.normal,
  });
  static var matchUrlWithPort = RegExp(r"[\d\w]+(\.[\d\w]+)*:(\d)+");
  static var matchHostname = RegExp(r"[\d\w]+(\.[\d\w]+)*");

  @override
  State<AdvancedConfigProvider> createState() => _AdvancedConfigProviderState();
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

///Set this to true once we fully support RFC 7030.
final configSupported = false;

var noSpacesAllowedValidator = regexValidator(RegExp("^[^\\s]*\$"),
    onNotMatching: "the input cant contain spaces");

class _AdvancedConfigProviderState extends State<AdvancedConfigProvider> {
  final _formKey = GlobalKey<FormState>();

  bool overrideId = false;

  TextEditingController? inputController = TextEditingController();
  bool keyboardVisible = false;

  ScrollController scrollController = ScrollController();

  PionixCloudManager? config;

  late Widget cloudAddressInputField;
  late Widget cloudHostnameInputField;
  late Widget enrollmentUsernameInputField;
  late Widget enrollmentPasswordInputField;
  late Widget manufacturerIdInputField;
  late Widget Function(bool) chargerIdInputField;

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
      if (!configSupported) return;
      //disable this for debugging:
      config = PionixCloudManager.loadFile(cloudConfigFile);

      // for debugging only:
      // config = PionixCloudManager(debugConfig);

      cloudAddressInputField = PionixInputField(
        icon: Icons.cloud,
        label: 'mqtt server with port address',
        initialText: config!.address,
        validator: regexValidator(
          AdvancedConfigProvider.matchUrlWithPort,
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
          AdvancedConfigProvider.matchHostname,
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

      chargerIdInputField = PionixInputField.disableable(
        icon: Icons.numbers,
        label:
            "id for this charger (make sure this is unique or bad stuff will happen)",
        onSaved: (value) {
          config!.chargerId = value;
        },
        initialText: config!.chargerId ?? "currently_not_defined",
        validator: noSpacesAllowedValidator,
        onTap: openKeyboardAndScrollDownTo(height * 6),
      );
    } catch (e) {
      config = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PionixAppBar('Connect to Cloud'),
      body: (!configSupported) ? Center(
        child: Text(
          "Coming soon!\n\nInterested? Message support@pionix.com",
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
      ) : Visibility(
        visible: config != null,
        replacement: Center(
          child: Text(
            "Cloud connection not available",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(
                  right: 10,
                ),
                controller: scrollController,
                children: <Widget>[
                  cloudAddressInputField,
                  cloudHostnameInputField,
                  enrollmentUsernameInputField,
                  enrollmentPasswordInputField,
                  manufacturerIdInputField,
                  Row(
                    children: [
                      Checkbox(
                        value: overrideId,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            overrideId = !overrideId;
                          });
                        },
                      ),
                      Expanded(
                        child: Text("Overwrite Charger ID"),
                      ),
                    ],
                  ),
                  chargerIdInputField(overrideId),
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
            Visibility(
              visible: keyboardVisible,
              replacement: Empty(),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: PionixVirtualKeyboard(
                    textController: inputController,
                    type: VirtualKeyboardType.Alphanumeric,
                    specialCharacters: true,
                    onKeyPress: _onkeyPress,
                  ),
                ),
              ),
            )
          ],
        ),
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

const String scriptPath = "/usr/sbin/pionix-cloud-service.sh";

class SimpleConfigProvider extends StatefulWidget {

  final EnrollMode mode;

  const SimpleConfigProvider({
    super.key,
    this.mode = EnrollMode.normal,
  });

  @override
  State<SimpleConfigProvider> createState() => _SimpleConfigProviderState();
}

class _SimpleConfigProviderState extends State<SimpleConfigProvider> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? inputController = TextEditingController();
  bool keyboardVisible = false;
  bool logVisible = false;
  final List<Widget> logEntries = [];

  PionixCloudManager? config;

  late Widget otpInputField;

  static const double height = 56;
  double additionalScrollDownLenght = height * 6;

  String? otp;

  ///The PID of the script process.
  ///null => no script process is running at the moment
  int? scriptPid;

  bool _scriptSuccess = true;

  /// Whether the script has succeeded or is running.
  /// true => script has succeeded / Script has not been run
  /// null => script is running
  /// false => script has been run and failed
  bool? get scriptSuccess {
    if (scriptPid != null) return null;
    return _scriptSuccess;
  }

  void attemptSetOtp(String value) {
    if (value.length != 8) return;
    otp = "${value.substring(0, 4)}-${value.substring(4, 8)}";
  }

  void openKeyboard(TextEditingController textFieldController) {
    inputController = textFieldController;
    keyboardVisible = true;
    setState(() {});
  }

  @override
  void initState() {
    try {
      if (configSupported) {
        //disable this for debugging:
        config = PionixCloudManager.loadFile(cloudConfigFile);

        // for debugging only:
        // config = PionixCloudManager(debugConfig);
      } else {
        config = null;
      }
    } catch (e) {
      config = null;
    }

    otpInputField = OtpInputField(
      onTextChanged: attemptSetOtp,
      onTap: openKeyboard,
    );

    if (widget.mode == EnrollMode.restart) {
      submit();
    }
    super.initState();
  }

  void assembleStringEntry(String msg, bool isError) {
    var text = Text(msg,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: (isError) ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
      ),
    );
    setState(() {
      logEntries.add(text);
    });
  }

  void assembleDataEntry(List<int> data, bool isError) {
    var msg = String.fromCharCodes(data);
    msg = msg.substring(0, msg.length - 1); //Cut out trailing linefeed
    assembleStringEntry(msg, isError);
  }

  Future<void> submit() async {
    setState(() {
      inputController = null;
      keyboardVisible = false;
    });
    if (otp == null && widget.mode != EnrollMode.restart) {
      debugPrint("Can't connect to cloud as otp is null.");
      setState(() {
        assembleStringEntry("OTP verification failed", true);
        logVisible = true;
        _scriptSuccess = false;
        scriptPid = null;
      });
      return;
    }
    // We don't need the script exists check at this point anymore as it's done elsewhere
    final List<String> args = switch (widget.mode) {
      EnrollMode.normal => ["--otp-code", otp!],
      EnrollMode.restart => ["--restart-only"],
      EnrollMode.reEnroll => ["--re-enroll", "--otp-code", otp!],
    };
    var proc = await Process.start(
      scriptPath,
      args,
    );
    setState(() {
      scriptPid = proc.pid;
      logVisible = true;
    });
    proc.stdout.listen((event) => assembleDataEntry(event, false));
    proc.stderr.listen((event) => assembleDataEntry(event, true));
    proc.exitCode.then(
      (value) {
        setState(() {
          _scriptSuccess = value == 0;
          scriptPid = null;
        });
      },
      onError: (value) {
        setState(() {
          _scriptSuccess = false;
          scriptPid = null;
        });
      }
    );
    debugPrint("connection to cloud attempted.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PionixAppBar('Connect to Cloud using OTP', hideBackButton: logVisible && scriptSuccess == null,),
      floatingActionButton: (!configSupported || keyboardVisible) ? null :
        FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.simpleFurtherSettingsScreen, arguments: ConfigArgWrapper(config!));
          },
        ),
      body: Visibility(
        visible: (!configSupported || configSupported && config != null) && checkFileExists(scriptPath),
        replacement: Center(
          child: Text(
            "Cloud connection not available",
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
        ),
        child: Visibility(
          visible: !logVisible,
          replacement: GeneralLogger(
            separateFooter: true,
            footer: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                label: Text(switch(scriptSuccess) {
                  null => "Abort",
                  true => "Exit",
                  false => "Retry",
                }),
                icon: Icon(switch(scriptSuccess) {
                  null => Icons.close,
                  true => Icons.arrow_back,
                  false => Icons.loop,
                }),
                onPressed: () {
                  debugPrint(ModalRoute.of(context)?.settings.name);
                  switch(scriptSuccess){
                    case null:
                      if (scriptPid != null) {
                        Process.killPid(scriptPid!);
                      } else {
                        //We should never get here
                        assembleStringEntry("Failed to find process, could not kill", true);
                      }
                      break;
                    case true:
                      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.chargingDashboardScreen));
                      break;
                    case false:
                      Navigator.pushReplacementNamed(context, AppRoutes.simpleCloudConfigScreen, arguments: widget.mode);
                      break;
                  }
                },
              ),
            ),
            content: logEntries,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !keyboardVisible,
                  child: Expanded(
                    child: Center(
                      child: Text(
                        "Open cloud.pionix.com, generate a new OTP and enter it here:",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      otpInputField,
                      ElevatedButton(
                        onPressed: ((_formKey.currentState?.validate() ?? false) && scriptPid == null) ? (() => submit()) : null,
                        child: Text("Connect to Cloud"),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: keyboardVisible,
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: PionixVirtualKeyboard(
                      textController: inputController,
                      type: VirtualKeyboardType.Alphanumeric,
                      specialCharacters: true,
                      onKeyPress: _onkeyPress,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onkeyPress(PionixVirtualKeyboardKey key) {
    setState(() {
      if (key.action == PionixVirtualKeyboardKeyAction.Return) {
        inputController = null;
        keyboardVisible = false;
        if (_formKey.currentState?.validate() ?? false) submit();
      }
    });
  }
}

bool checkFileExists(String path) {
  try {
    return File(path).existsSync();
  } catch(_) {
    return false;
  }
}

class SimpleFurtherSettings extends StatefulWidget {

  final ConfigArgWrapper confWrapper;

  const SimpleFurtherSettings(this.confWrapper, {
    super.key,
  });
  static var matchUrlWithPort = RegExp(r"[\d\w]+(\.[\d\w]+)*:(\d)+");
  static var matchHostname = RegExp(r"[\d\w]+(\.[\d\w]+)*");

  @override
  State<SimpleFurtherSettings> createState() => _SimpleFurtherSettings();
}

class _SimpleFurtherSettings extends State<SimpleFurtherSettings> {
  final _formKey = GlobalKey<FormState>();

  bool overrideId = false;

  TextEditingController? inputController = TextEditingController();
  bool keyboardVisible = false;

  ScrollController scrollController = ScrollController();

  PionixCloudManager get config => widget.confWrapper.config;

  String? protoAddress;
  String? protoHostname;
  String? protoChargerId;

  late Widget cloudAddressInputField;
  late Widget cloudHostnameInputField;
  late Widget Function(bool) chargerIdInputField;

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
    cloudAddressInputField = PionixInputField(
      icon: Icons.cloud,
      label: 'mqtt server with port address',
      initialText: config.address,
      validator: regexValidator(
        AdvancedConfigProvider.matchUrlWithPort,
        onEmpty: "Please enter an address",
        onNotMatching: "Please enter a valid address with port number",
      ),
      onSaved: (value) {
        protoAddress = value;
      },
      onTap: openKeyboardAndScrollDownTo(0),
    );

    cloudHostnameInputField = PionixInputField(
      icon: Icons.cloud,
      label: "hostname of the server",
      initialText: config.hostname,
      validator: regexValidator(
        AdvancedConfigProvider.matchHostname,
        onEmpty: "Please enter a hostname",
        onNotMatching: "Please enter a valid hostname",
      ),
      onSaved: (value) {
        protoHostname = value;
      },
      onTap: openKeyboardAndScrollDownTo(height),
    );

    chargerIdInputField = PionixInputField.disableable(
      icon: Icons.numbers,
      label:
      "id for this charger (make sure this is unique or bad stuff will happen)",
      onSaved: (value) {
        protoChargerId = value;
      },
      initialText: config.chargerId ?? "currently_not_defined",
      validator: noSpacesAllowedValidator,
      onTap: openKeyboardAndScrollDownTo(height * 3),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PionixAppBar('Connect to Cloud using OTP (Advanced Settings)'),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(
                right: 10,
              ),
              controller: scrollController,
              children: <Widget>[
                cloudAddressInputField,
                cloudHostnameInputField,
                Row(
                  children: [
                    Checkbox(
                      value: overrideId,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          overrideId = !overrideId;
                        });
                      },
                    ),
                    Expanded(
                      child: Text("Overwrite Charger ID"),
                    ),
                  ],
                ),
                chargerIdInputField(overrideId),
                ElevatedButton(
                  onPressed: _formKey.currentState?.validate() ?? false
                      ? () {
                    if (!overrideId) {
                      config.chargerId = null;
                    } else {
                      config.chargerId = protoChargerId ?? config.chargerId;
                    }
                    config.address = protoAddress ?? config.address;
                    config.hostname = protoHostname ?? config.hostname;
                    Navigator.pop(context);
                  } : null,
                  child: Text("Save"),
                ),
                SizedBox(
                  height: additionalScrollDownLenght,
                ),
              ],
            ),
          ),
          Visibility(
            visible: keyboardVisible,
            replacement: Empty(),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: PionixVirtualKeyboard(
                  textController: inputController,
                  type: VirtualKeyboardType.Alphanumeric,
                  specialCharacters: true,
                  onKeyPress: _onkeyPress,
                ),
              ),
            ),
          )
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

class ConfigArgWrapper {

  final PionixCloudManager config;

  const ConfigArgWrapper(this.config);

}