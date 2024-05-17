import 'package:flutter/material.dart';

class IconTextField extends StatefulWidget {
  final Icon icon;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  bool visible;
  bool hidden;
  Decoration? decoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.1),
    borderRadius: const BorderRadius.all(Radius.circular(20.00)),
  );

  IconTextField(
      {Key? key,
      required this.icon,
      required this.controller,
      this.hintText = '',
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.onTap,
      this.visible = false,
      this.decoration,
      this.hidden = true})
      : super(key: key);

  @override
  State<IconTextField> createState() => _IconTextFieldState();
}

class _IconTextFieldState extends State<IconTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: widget.decoration,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          widget.icon,
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              obscureText: !widget.visible,
              readOnly: true,
              onTap: widget.onTap,
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.grey.shade400),
                    ),
            ),
          ),
          widget.hidden
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.visible = !widget.visible;
                    });
                  },
                  icon: Icon(
                    widget.visible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade400,
                    size: 28,
                  ))
              : Container()
        ],
      ),
    );
  }
}
