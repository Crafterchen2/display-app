import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/locale/locale_providers.dart';
import '../data/models/locale/locale_state.dart';
import '../data/models/locale/locale_translate_name.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale currentLocale = ref.watch(localeProvider);
    List<Locale> supportedLocales = ref.read(supportedLocalesProvider);

    return DropdownButton<Locale>(
        isDense: true,
        value:
            (!supportedLocales.contains(currentLocale)) ? null : currentLocale,
        icon: const Icon(Icons.arrow_drop_down),
        underline: Container(
          height: 1,
          color: Colors.black26,
        ),
        onChanged: (Locale? newLocale) {
          if (newLocale == null) {
            return;
          }
          debugPrint("Selected $newLocale");

          // Set the locale (this will rebuild the app)
          ref.read(localeStateProvider.notifier).setLocale(newLocale);

          return;
        },
        // Create drop down items from our supported locales
        items: supportedLocales
            .map<DropdownMenuItem<Locale>>(
              (locale) => DropdownMenuItem<Locale>(
                value: locale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    translateLocaleName(locale: locale),
                  ),
                ),
              ),
            )
            .toList());
  }
}
