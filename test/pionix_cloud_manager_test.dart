import 'package:display_app/utils/pionix_cloud_manager.dart';
import 'package:flutter_test/flutter_test.dart';

String exampleConfig1 = """
# Pionix Cloud configuration
# used by pionix-cloud-service.sh

# hostname and port for connecting to the Pionix Cloud server (required)
address="sc-production-mqtt.schoneberg.pionix.net:443"

# hostname for connecting to the enrolment server (required)
hostname="sc-production.schoneberg.pionix.net"

# Enrolment server credentials
username="pionix"
password="supersecretpassword1234"

# Manufacturer ID (required)
manufacturer_id="pionixDev"

# file containing the charging station ID
id_file="/etc/charger_id"

# use the MAC address from the Ethernet device id_mac for the charger ID
id_mac="eth0"

# alternatively set the ID here
# charger_id=
""";

String badConfig1 = """
# Pionix Cloud configuration
# used by pionix-cloud-service.sh

# hostname and port for connecting to the Pionix Cloud server (required)
# address="sc-production-mqtt.schoneberg.pionix.net:443"                         <--- this is commented out :(

# hostname for connecting to the enrolment server (required)
hostname="sc-production.schoneberg.pionix.net"

# Enrolment server credentials
username="pionix"
password="supersecretpassword1234"

# Manufacturer ID (required)
manufacturer_id="pionixDev"

# file containing the charging station ID
id_file="/etc/charger_id"

# use the MAC address from the Ethernet device id_mac for the charger ID
id_mac="eth0"

# alternatively set the ID here
# charger_id=
""";
String exampleConfig2 = """
# Pionix Cloud configuration
# used by pionix-cloud-service.sh

# hostname and port for connecting to the Pionix Cloud server (required)
address="sc-production-mqtt.schoneberg.pionix.net:443" #<--- here is a inline comment (which are not supported in env files technically but they should work)

# hostname for connecting to the enrolment server (required)
hostname="sc-production.schoneberg.pionix.net"

# Enrolment server credentials
username="pionix"
password="supersecretpassword1234"

# Manufacturer ID (required)
manufacturer_id="pionixDev"

# file containing the charging station ID
id_file="/etc/charger_id"

# use the MAC address from the Ethernet device id_mac for the charger ID
id_mac="eth0"

# alternatively set the ID here
# charger_id=
""";

String expectedConfig1 = """
# Pionix Cloud configuration
# used by pionix-cloud-service.sh

# hostname and port for connecting to the Pionix Cloud server (required)
address="mycustomaddress:42"

# hostname for connecting to the enrolment server (required)
hostname="mycustomhostname"

# Enrolment server credentials
username="pionix"
password="supersecretpassword1234"

# Manufacturer ID (required)
manufacturer_id="pionixDev"

# file containing the charging station ID
id_file="/etc/charger_id"

# use the MAC address from the Ethernet device id_mac for the charger ID
id_mac="eth0"

# alternatively set the ID here
# charger_id=
""";

void main() {
  test("Test Cloud config parsing normal", () {
    var configManager = PionixCloudManager(exampleConfig1);
    assert(configManager.valid);
  });
  test(
    "test config parse fail missing field",
    () {
      var configManager = PionixCloudManager(badConfig1);
      assert(!configManager.valid);
    },
  );

  test(
    "test config with inline comments",
    () {
      var configManager = PionixCloudManager(exampleConfig2);
      assert(configManager.valid);
      assert(configManager.address ==
          "sc-production-mqtt.schoneberg.pionix.net:443");
    },
  );
  test(
    "test changing config",
    () async {
      var configManager = PionixCloudManager(exampleConfig1);
      configManager.address = "mycustomaddress:42";

      configManager.hostname = "mycustomhostname";

      assert(await configManager.newConfig == expectedConfig1);
    },
  );
}
