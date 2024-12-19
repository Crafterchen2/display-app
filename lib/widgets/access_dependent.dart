import 'package:display_app/widgets/empty.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants/keys.dart';

class AccessDependent extends StatelessWidget {

  late final ValueListenable<AccessMode> valueListenable;

  final ValueListenable<AccessMode>? ovrValueListenable;
  final Widget fallback;
  final Widget? onPublic;
  final Widget? onPrivate;
  final Widget? onUnset;

  AccessDependent({
    super.key,
    this.ovrValueListenable,
    this.onPublic,
    this.onPrivate,
    this.onUnset,
    this.fallback = const Empty(),
  }) {
    valueListenable = ovrValueListenable ?? accessNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        return on(
          accessMode: value,
          fallback: fallback,
          onPrivate: onPrivate,
          onPublic: onPublic,
          onUnset: onUnset,
        );
      },
    );
  }

  static dynamic on({
    required AccessMode accessMode,
    dynamic onPublic,
    dynamic onPrivate,
    dynamic onUnset,
    dynamic fallback,
  }){
    return switch(accessMode) {
      AccessMode.public => onPublic,
      AccessMode.private => onPrivate,
      AccessMode.unset => onUnset,
    } ?? fallback;
  }

}

final ValueNotifier<AccessMode> accessNotifier = ValueNotifier(getDefaultState());

AccessMode getDefaultState() {
  return AccessMode.unset;
}