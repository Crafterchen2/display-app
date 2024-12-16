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
        return ((value.isAc) ? onAc : onDc) ?? fallback;
      },
    );
  }
}

ValueNotifier<AcDcMode> acDcNotifier = ValueNotifier(getDefaultState());

AcDcMode getDefaultState() {
  return AcDcMode.ac; //TODO adjust default value to current config
}