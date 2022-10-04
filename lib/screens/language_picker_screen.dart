import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../data/models/application_info.dart';
import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../widgets/restart_widget.dart';

class LanguagePickerScreen extends StatefulWidget {
  const LanguagePickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  String selectedLanguage = Language.unknown;

  List<String> languages = [Language.english, Language.german];
  late ApplicationInfo _appInfo;
  final mqtt = MQTT();

  @override
  void initState() {
    _connect(context);
    super.initState();
  }

  void applicationInfo(String message) {
    final msg = jsonDecode(message);
    _appInfo = ApplicationInfo.fromJson(msg);
    if (_appInfo.current_language == 'eng') {
      selectedLanguage = Language.english;
    } else {
      selectedLanguage = Language.german;
    }

    if (mounted) {
      setState(() {
        // _showProgress = false;
      });
    }
  }

  void updateCurrentLanguage(String lang) {
    mqtt.publish(Topic.updateCurrentLanguage, lang);
    setState(() {});
  }

  void getAppInfo(BuildContext context, MQTT mqtt) {
    mqtt.publish("everest_api/setup/cmd/get_application_info", '');
    mqtt.subscribe("everest_api/setup/var/application_info", applicationInfo);
  }

  void _connect(BuildContext context) async {
    try {
      await mqtt.connect();
      getAppInfo(context, mqtt);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
      setState(() {
        // _showProgress = false;
      });
    }

    setState(() {
      // _showProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create a DateFormat for the current locale
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          selectedLanguage != Language.unknown
              ? Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: languages.length,
                        itemBuilder: (context, index) {
                          final l = languages[index];
                          return languageItem(
                            language: l,
                            selected: selectedLanguage == l,
                          );
                        }),
                  ),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ...languageButtons(context),
                  //   ],
                  // ),
                )
              : const Expanded(
                  child: Center(
                      child: CircularProgressIndicator(
                  color: AppColors.primaryAmber,
                ))),
          const PionixCloseButton(),
        ],
      ),
    );
  }

  Widget languageItem({required String language, bool selected = false}) {
    return GestureDetector(
      onTap: () {
        languages.clear();
        setState(() {
          if (language == 'english') {
            context.setLocale(const Locale('en', 'US'));
            languages = ['english', 'german'];
            updateCurrentLanguage("eng");
            selectedLanguage = Language.english;
          } else {
            context.setLocale(const Locale('de', 'DE'));
            languages = ['english', 'german'];
            updateCurrentLanguage("ger");
            selectedLanguage = Language.german;
          }
          Navigator.pop(context);
          // RestartWidget.restartApp(context);
        });
        // Navigator.of(context).pop({"selectedLanguage": language});
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(
                  color:
                      selected ? AppColors.primaryAmber : AppColors.primaryBlue,
                  width: 3.0)),
          child: Text(
            language.tr(),
            style:
                AppTextStyles.heading6.copyWith(color: AppColors.primaryAmber),
          ),
        ),
      ),
    );
  }
}
