import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Empty extends SingleChildRenderObjectWidget {

  ///This is an empty widget.
  ///It has a size of [Size.zero] and doesn't do or draw anything.
  ///It is useful anyway as a "non-null null value", using [bool isEmpty = widget is Empty], see [check(Widget? toTest)].
  const Empty ({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomPaint();
  }

  ///Returns true if and only if [toTest] is not null and an implementor of class [Empty].
  static bool check(dynamic toTest) {
    return toTest is Empty;
  }

}