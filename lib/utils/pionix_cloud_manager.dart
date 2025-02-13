import 'dart:io';

import 'package:flutter/widgets.dart';

var cloudConfigFile = File("/etc/default/pionix-cloud");

class PionixCloudManager {
  String configContent;

  /// hostname and port for connecting to the Pionix Cloud server (required)
  late String address;

  /// hostname for connecting to the enrolment server (required)
  late String hostname;

  /// Enrolment server credentials (username)
  late String username;

  /// Enrolment server credentials (password)
  late String password;

  /// Manufacturer ID (required)
  late String manufacturerId;

  /// file containing the charging station ID
  late String idFile;

  /// use the MAC address from the Ethernet device id_mac for the charger ID
  late String? idMac;

  /// user this string as a charger ID
  late String? chargerId;
  bool valid = true;

  PionixCloudManager(this.configContent) {
    parseFile(configContent);
  }

  /// creates a cloud manager by loading a file.
  /// THIS METHOD RAISES if the file is not found
  factory PionixCloudManager.loadFile(File file) {
    var config = file.readAsStringSync();
    return PionixCloudManager(config);
  }

  void parseFile(String filecontent) {
    var lines = filecontent.split("\n");
    var values = <String, String>{};
    for (String line in lines) {
      line = line.replaceFirst(RegExp(r"( |^)#.*$", multiLine: true),
          ""); // remove comments and inline comments if seperated with a space like key=value #comment here
      line = line.replaceAll(" ", "");
      if (line == "") {
        continue;
      }

      List<String> split = line.split("=");
      assert(split.length == 2, "Line containing no assignment");
      String key = split[0];
      String value = split[1];
      value = parseValue(value);
      values[key] = value;
    }

    try {
      address = values["address"]!;
      hostname = values["hostname"]!;
      username = values["username"]!;
      password = values["password"]!;
      manufacturerId = values["manufacturer_id"]!;
      idFile = values["id_file"]!;
      idMac = values["id_mac"];
      chargerId = values["charger_id"];
      assert(idMac != null || chargerId != null);
    } catch (error, stacktrace) {
      debugPrint(
          "the provided config is invalid: ${error.toString()} in\n${stacktrace.toString()}\n programm continues normally");
      valid = false;
    }
  }

  Future<String> get newConfig async {
    if (!valid) {
      debugPrint("Not writing file");
      throw Error();
    }
    var values = {
      "address": address,
      "hostname": hostname,
      "username": username,
      "password": password,
      "manufacturer_id": manufacturerId,
      "id_file": idFile,
      "idMac": idMac,
      "charger_id": chargerId
    };
    for (var entry in values.entries) {
      if (entry.value != null) {
        // replace normal line
        configContent = configContent.replaceFirst(
            RegExp("^${entry.key}=.*\$", multiLine: true),
            "${entry.key}=\"${entry.value}\"");
        // replace commented out line (mainly for charger ID overriding)
        configContent = configContent.replaceFirst(
            RegExp("^#\\s*${entry.key}=.*\$", multiLine: true),
            "${entry.key}=\"${entry.value}\"");
      } else {
        // comment out valid line
        configContent = configContent.replaceFirstMapped(
            RegExp("^${entry.key}=.*\$", multiLine: true), (Match match) {
          return "# ${match.group(0)}";
        });
      }
    }
    return configContent;
  }

  void writeFile(File file) async {
    newConfig.then((content) => cloudConfigFile.writeAsString(content),
        onError: (error) {
      debugPrint("error occurred when saving cloud config to $file:\n$error");
    });
  }

  static String parseValue(String value) {
    if ((value.startsWith("\"") && value.endsWith("\"")) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      return value = value.substring(1, value.length - 1);
    }
    return value;
  }

  /// apply this config file
  void configure() async {
    var clientKey = File("/etc/mosquitto/client.key");
    clientKey.delete();
    var clientCert = File("/etc/mosquitto/client.crt");
    clientCert.delete();
    var caCert = File("/etc/mosquitto/ca.crt");
    caCert.delete();

    writeFile(cloudConfigFile);

    var result = await Process.run(
        "systemctl", ["restart", "pionix-cloud-service.service"]);
    if (result.exitCode != 0) {
      debugPrint("Cloud enrollment failed: ${result.stderr}");
    }
  }
}
