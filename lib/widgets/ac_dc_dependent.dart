import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../utils/constants/keys.dart';
import 'empty.dart';

class AcDcDependent extends StatelessWidget {

  late final ValueListenable<AcDcMode> valueListenable;

  final ValueListenable<AcDcMode>? ovrValueListenable;
  final Widget fallback;
  final Widget? onAc;
  final Widget? onDc;

  AcDcDependent({
    super.key,
    this.ovrValueListenable,
    this.onAc,
    this.onDc,
    this.fallback = const Empty(),
  }) {
    valueListenable = ovrValueListenable ?? acDcNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        return on(
          acDcMode: value,
          fallback: fallback,
          onAc: onAc,
          onDc: onDc,
        );
      },
    );
  }

  static dynamic on({
    required AcDcMode acDcMode,
    dynamic onAc,
    dynamic onDc,
    dynamic fallback,
  }){
    return ((acDcMode.isAc) ? onAc : onDc) ?? fallback;
  }

}

final ValueNotifier<AcDcMode> acDcNotifier = ValueNotifier(getDefaultState());

AcDcMode getDefaultState() {
  return AcDcMode.ac; //Once this info can be read from configs, we can change the initial value here.
}