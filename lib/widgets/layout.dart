import 'package:flutter/material.dart';

class BorderLayout extends StatelessWidget {
  final Map<BorderLayoutSlot, Widget> widgets;

  const BorderLayout({
    super.key,
    required this.widgets,
  });

  ///Replicates the behaviour of the java.awt.BorderLayout.
  ///The Map<BorderLayoutSlot, Widget> [widgets] manages the widgets and determines
  ///what widget belongs to which slot.
  ///if the map is missing a key, an empty Container is placed in that slot instead.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: (widgets.containsKey(BorderLayoutSlot.north) && widgets[BorderLayoutSlot.north] != null) ? widgets[BorderLayoutSlot.north]! : Container()),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(child: (widgets.containsKey(BorderLayoutSlot.west) && widgets[BorderLayoutSlot.west] != null) ? widgets[BorderLayoutSlot.west]! : Container()),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: (widgets.containsKey(BorderLayoutSlot.center) && widgets[BorderLayoutSlot.center] != null) ? widgets[BorderLayoutSlot.center]! : Container()),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(child: (widgets.containsKey(BorderLayoutSlot.east) && widgets[BorderLayoutSlot.east] != null) ? widgets[BorderLayoutSlot.east]! : Container()),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: (widgets.containsKey(BorderLayoutSlot.south) && widgets[BorderLayoutSlot.south] != null) ? widgets[BorderLayoutSlot.south]! : Container()),
          ],
        ),
      ],
    );
  }
}

enum BorderLayoutSlot { north, east, south, west, center }

class InfoLayout extends StatelessWidget {
  final double width;
  final double radius;
  final List<Widget?> children;
  final Color? color;

  const InfoLayout({
    super.key,
    this.width = 2,
    this.radius = 12,
    this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: width,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Column(
        children: makeSeparatedList(context),
      ),
    );
  }

  List<Widget> makeSeparatedList(BuildContext context) {
    if (children.isEmpty) return [];
    final int targetLength = 2 * children.length - 1;
    List<Widget> rv = [];
    for (int i = 0; i < targetLength; i++) {
      var elementAt = children.elementAt((i / 2).ceil());
      if (elementAt != null) {
        if (i % 2 == 0) {
          rv.add(elementAt);
        } else {
          rv.add(
            Divider(
              color: color ?? Theme.of(context).colorScheme.primary,
              endIndent: 0,
              height: width,
              indent: 0,
              thickness: width,
            ),
          );
        }
      }
    }
    return rv;
  }
}
