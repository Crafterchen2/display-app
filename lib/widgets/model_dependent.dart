import 'package:display_app/data/models/charger_info.dart';
import 'package:display_app/data/providers/charger_info_provider.dart';
import 'package:display_app/utils/constants/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// a class for showing a Widget only on specified platforms
class ModelDependent extends ConsumerWidget {
  /// a list of Platforms the child should be displayed on
  final List<ChargerModel> platforms;

  /// the Widget do display
  final Widget child;

  /// a Widget to display if the Device is unknown
  final Widget unknownChild;

  /// shows a Widget depending on the platform
  const ModelDependent({
    required this.child,
    this.platforms = const <ChargerModel>[],
    this.unknownChild = const SizedBox.shrink(),
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChargerInfo chargerInfo =
        ref.watch(chargerInfoStreamProvider).whenOrNull(data: (data) => data) ??
            ChargerInfo(
              ChargerModel.unknown,
              null,
              null,
              null,
              null,
            );
    if (chargerInfo.model_name == ChargerModel.unknown &&
        !platforms.contains(ChargerModel.unknown)) {
      return unknownChild;
    }
    return (platforms.contains(chargerInfo.model_name))
        ? child
        : const SizedBox.shrink();
  }

  static dynamic on({
    required ChargerModel chargerModel,
    dynamic onBelayBox,
    dynamic onUMWC,
    dynamic onUMWCar,
    dynamic defaultValue,
  }) =>
      {
        ChargerModel.belayBox: onBelayBox,
        ChargerModel.microMegaWattCar: onUMWCar,
        ChargerModel.microMegaWattCharger: onUMWC,
        ChargerModel.unknown: null,
      }[chargerModel] ??
      defaultValue;
}
