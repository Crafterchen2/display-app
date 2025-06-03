import 'dart:math';

import 'package:flutter/material.dart';

class PionixInputField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String textHint;
  final FormFieldValidator<String>? validator;
  final bool? enabled;
  final String? initialText;
  final ValueChanged<String>? onSaved;
  final void Function(TextEditingController)? onTap;
  late final TextEditingController controller;
  final bool mulitLine;

  static PionixInputField Function(bool) disableable({
    required IconData icon,
    required String label,
    String textHint = "",
    FormFieldValidator<String>? validator,
    String? initialText,
    ValueChanged<String>? onSaved,
    void Function(TextEditingController)? onTap,
    TextEditingController? providedController,
    bool multiline = false,
  }) {
    var constantEditingController =
        providedController ?? TextEditingController(text: initialText);
    PionixInputField inner(bool enabled) => PionixInputField(
          enabled: enabled,
          icon: icon,
          label: label,
          mulitLine: multiline,
          onSaved: onSaved,
          onTap: onTap,
          providedController: constantEditingController,
          textHint: textHint,
          validator: validator,
        );
    return inner;
  }

  PionixInputField({
    super.key,
    required this.icon,
    required this.label,
    this.textHint = "",
    this.validator,
    this.enabled,
    this.onSaved,
    this.onTap,
    this.initialText,
    TextEditingController? providedController,
    this.mulitLine = false,
  }) {
    controller = providedController ?? TextEditingController(text: initialText);
    controller.addListener(() {
      var newlineAt = controller.text.indexOf("\n");
      if (newlineAt == controller.text.length - 1) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      } else if (newlineAt != -1 && !mulitLine) {
        controller.text = controller.text.replaceFirst("\n", "");
      }
      onSaved?.call(controller.text);
    });
  }

  @override
  State<PionixInputField> createState() => _PionixInputFieldState();
}

class _PionixInputFieldState extends State<PionixInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(widget.icon),
          label: Text(widget.label),
          hintText: widget.textHint,
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                  },
                )
              : null,
        ),
        validator: widget.validator,
        enabled: widget.enabled ?? true,
        controller: widget.controller,
        onTap: () {
          widget.onTap?.call(widget.controller);
        },
      ),
    );
  }
}

class OtpInputField extends StatefulWidget {

  final ValueChanged<String>? onTextChanged;
  final void Function(TextEditingController)? onTap;
  late final TextEditingController controller;
  final double charWidth;

  String get otp => controller.text;

  OtpInputField({
    super.key,
    this.onTextChanged,
    this.onTap,
    this.charWidth = 50,
    TextEditingController? providedController,
  }) {
    controller = providedController ?? TextEditingController();
    controller.addListener(() {
      controller.text = controller.text.replaceAll("\n", "");
      controller.text = controller.text.substring(0, min(controller.text.length, 8));
      onTextChanged?.call(controller.text);
    });
  }

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {

  @override
  void initState() {
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  Color? getBgColor(int index, BuildContext context) {
    if (index > widget.otp.length) return null;
    if (index == widget.otp.length) return Theme.of(context).colorScheme.secondaryContainer;
    var validChar = RegExp(r"[a-zA-Z0-9]");
    if (validChar.hasMatch(widget.otp[index])) {
      return Theme.of(context).colorScheme.tertiaryContainer;
    } else {
      return Theme.of(context).colorScheme.errorContainer;
    }
  }

  String getOtpChar(int index) {
    if (index < 0 || index >= widget.otp.length) return "";
    return widget.otp[index];
  }

  List<Widget> buildOtpSegment(int nSeg, int charPerSeg, Widget? separator, TextStyle? style) {
    List<Widget> rv = [];
    for (int i = 0; i < nSeg; i++) {
      rv.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              strokeAlign: BorderSide.strokeAlignOutside,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: buildOtpCharWidgets(i * charPerSeg, charPerSeg, style),
          ),
        ),
      );
      if (separator != null && i < nSeg - 1) rv.add(separator);
    }
    return rv;
  }

  List<Widget> buildOtpCharWidgets(int start, int amount, TextStyle? style) {
    List<Widget> rv = [];
    var max = amount + start;
    for (int i = start; i < max; i++) {
      rv.add(
        Container(
          decoration: BoxDecoration(
            color: getBgColor(i, context),
            border: (i < max - 1) ? Border(
              right: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                style: BorderStyle.solid,
                width: 2,
              ),
            ) : null,
          ),
          child: SizedBox(
            width: widget.charWidth,
            child: Center(
              child: Text(getOtpChar(i),
                style: style,
              ),
            ),
          ),
        ),
      );
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontFamily: "RobotoMono",
      fontFeatures: [FontFeature.tabularFigures()],
    );
    var separator = SizedBox(
      width: widget.charWidth,
      child: Center(
        child: Text("-",
          style: textTheme,
        ),
      ),
    );
    return FormField(
      validator: (value) {
        if (value == null) return ""; //We don't want to harass the user with an error before inputting has started, but the Form should be invalid anyway.
        if (value is! String) return "An unknown error occurred.";
        if (value.isEmpty) return ""; //See above.
        if (value.length < 8) return "Please provide 8 characters.";
        if (RegExp(r"^[a-zA-Z0-9]{8}$").hasMatch(value)) return null;
        return "Please use only letters and numbers.";
      },
      builder: (field) {
        return InkWell(
          onTap: () {
            widget.onTap?.call(widget.controller);
            widget.controller.addListener(() {
              field.didChange(widget.controller.text);
            });
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildOtpSegment(2, 4, separator, textTheme),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  field.errorText ?? " ",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: (field.hasError) ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
