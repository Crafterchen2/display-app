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
        onSaved?.call(controller.text);
      } else if (newlineAt != -1 && !mulitLine) {
        controller.text = controller.text.replaceFirst("\n", "");
      }
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
