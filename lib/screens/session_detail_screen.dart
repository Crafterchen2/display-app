import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../mqtt.dart';
import '../theme/app_text_styles.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final mqtt = MQTT();
  late PowerMeter powerMeter;
  late Limits limits;
  String selectedLanguage = 'english';
  bool showLoader = true;
  bool currentListExpanded = false;
  bool powerListExpanded = false;
  bool frequencyListExpanded = false;
  bool energyListExpanded = false;
  bool voltageListExpanded = false;
  bool limitsListExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    extractArguments(context);
    _connectMqtt();
    super.didChangeDependencies();
  }

  void extractArguments(BuildContext context) {
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    powerMeter = i["powerMeter"];
    limits = i["limits"];
    debugPrint('\n\n ${powerMeter.toJson()}');
    debugPrint('\n ${powerMeter.current_A.toJson()}');
    debugPrint('\n ${powerMeter.power_W.toJson()}');
    debugPrint('\n ${powerMeter.voltage_V.toJson()}');
    debugPrint('\n ${powerMeter.energy_Wh_import.toJson()}');
    debugPrint('\n ${powerMeter.frequency_Hz.toJson()}');
    debugPrint('\n\n ${limits.toJson()} \n\n');
    setState(() {
      showLoader = false;
    });
  }

  void parsePowermeterDetails(String powermtere) {
    final i = jsonDecode(powermtere);
    powerMeter = PowerMeter.fromJson(i);

    if (mounted) {
      setState(() {
        showLoader = false;
      });
    }
  }

  void parseLimits(String message) {
    final i = jsonDecode(message);
    limits = Limits.fromJson(i);
    if (mounted) {
      setState(() {
        showLoader = false;
      });
    }
  }

  Future<void> _connectMqtt() async {
    setState(() {
      showLoader = true;
    });
    try {
      await mqtt.connect();

      mqtt.subscribe("everest_api/evse_manager/var/limits", parseLimits);
      mqtt.subscribe(
          "everest_api/evse_manager/var/powermeter", parsePowermeterDetails);
      setState(() {
        showLoader = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        showLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryBlue,
        ),
        padding: EdgeInsets.all(12),
        child: Stack(
          children: [
            showLoader || powerMeter == null || limits == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Powermeter',
                              style: AppTextStyles.heading3
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SessionDetailCardWidget(
                        expanded: currentListExpanded,
                        sectionTitle: 'Current A',
                        map: powerMeter.current_A.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            currentListExpanded = !currentListExpanded;
                          });
                        },
                      ),
                      SessionDetailCardWidget(
                        expanded: powerListExpanded,
                        sectionTitle: 'Power w',
                        map: powerMeter.power_W.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            powerListExpanded = !powerListExpanded;
                          });
                        },
                      ),
                      SessionDetailCardWidget(
                        expanded: energyListExpanded,
                        sectionTitle: 'Energy',
                        map: powerMeter.energy_Wh_import.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            energyListExpanded = !energyListExpanded;
                          });
                        },
                      ),
                      SessionDetailCardWidget(
                        expanded: frequencyListExpanded,
                        sectionTitle: 'Frequency',
                        map: powerMeter.frequency_Hz.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            frequencyListExpanded = !frequencyListExpanded;
                          });
                        },
                      ),
                      SessionDetailCardWidget(
                        expanded: voltageListExpanded,
                        sectionTitle: 'Voltage',
                        map: powerMeter.voltage_V.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            voltageListExpanded = !voltageListExpanded;
                          });
                        },
                      ),
                      SessionDetailCardWidget(
                        expanded: limitsListExpanded,
                        sectionTitle: 'Limits',
                        map: limits.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            limitsListExpanded = !limitsListExpanded;
                          });
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.15,
                      )
                    ],
                  ),
            const PionixCloseButton(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class SessionDetailCardWidget extends StatelessWidget {
  final bool expanded;
  final String sectionTitle;
  final Map<String, dynamic> map;
  final VoidCallback? onExpendPressed;

  const SessionDetailCardWidget(
      {Key? key,
      required this.sectionTitle,
      required this.map,
      this.expanded = false,
      this.onExpendPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: Colors.white30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      sectionTitle,
                      style:
                          AppTextStyles.subTitle4.copyWith(color: Colors.white),
                    ),
                  ),
                  IconButton(
                      onPressed: onExpendPressed ?? () {},
                      icon: Icon(
                        expanded
                            ? Icons.keyboard_arrow_down_sharp
                            : Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: screenHeight * 0.08,
                      ))
                ],
              ),
              expanded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                      child: Container(
                        height: 2,
                        color: Colors.white10,
                      ),
                    )
                  : SizedBox(),
              if (expanded) ...populateList(context),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> populateList(BuildContext context) {
    List<Widget> items = [];
    for (final item in map.entries) {
      var val = item.value;
      if(item.value.runtimeType == 'double'){
        val = val.toStringAsFixed(2);
      }else{
        val = val.toString();
      }
      items.add(buildItem(context,
          key: item.key, value: val));
    }
    return items;
  }

  Widget buildItem(BuildContext context, {String key = '', String value = ''}) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key,
                style: AppTextStyles.heading3.copyWith(color: Colors.white),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.digitsHeading3
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
