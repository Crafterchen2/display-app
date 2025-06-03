import 'package:display_app/widgets/empty.dart';
import 'package:flutter/material.dart';

class GeneralLogger extends StatelessWidget {

  final Widget? header;
  final bool separateHeader;
  final Widget? footer;
  final bool separateFooter;
  final List<Widget?> content;

  final Decoration? backgroundDeco;

  const GeneralLogger({
    super.key,
    this.header,
    this.footer,
    this.backgroundDeco,
    this.separateHeader = true,
    this.separateFooter = false,
    this.content = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) header!,
          if (header != null && separateHeader) Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: content.length,
              reverse: true,
              itemBuilder: (context, index) => content[content.length - index - 1] ?? Empty(),
            ),
          ),
          if (footer != null && separateFooter) Divider(),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class StringLogger extends GeneralLogger {

  /// For Convenience. Creates Text widgets based on [proto] and [strings].
  /// only [proto.key] and [proto.data] are ignored when creating the widgets,
  /// everything else gets applied accordingly, including deprecated fields.
  StringLogger({
    super.key,
    super.header,
    super.footer,
    super.backgroundDeco,
    super.separateHeader,
    super.separateFooter,
    List<String?> strings = const [],
    Text? proto,
  }) : super(
    content: List.generate(
      strings.length,
      (index) {
        if (strings[index] == null) return null;
        if (proto == null) return Text(strings[index]!);
        return Text(strings[index]!,
          style: proto.style,
          strutStyle: proto.strutStyle,
          textAlign: proto.textAlign,
          textDirection: proto.textDirection,
          locale: proto.locale,
          softWrap: proto.softWrap,
          overflow: proto.overflow,
          textScaleFactor: proto.textScaleFactor,
          textScaler: proto.textScaler,
          maxLines: proto.maxLines,
          semanticsLabel: proto.semanticsLabel,
          textWidthBasis: proto.textWidthBasis,
          textHeightBehavior: proto.textHeightBehavior,
          selectionColor: proto.selectionColor,
        );
      },
      growable: false,
    ),
  );
}