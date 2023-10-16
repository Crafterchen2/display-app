import 'dart:collection';
import 'package:flutter/material.dart';

class BorderLayout extends StatelessWidget{
  
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
            Expanded(child: (widgets.containsKey(BorderLayoutSlot.north) && widgets[BorderLayoutSlot.north] != null) ?  widgets[BorderLayoutSlot.north]! : Container()),
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
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: (widgets.containsKey(BorderLayoutSlot.center) && widgets[BorderLayoutSlot.center] != null) ? widgets[BorderLayoutSlot.center]! : Container()),
                ],
              )),
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
      ]
    );
  }

}

enum BorderLayoutSlot {north, east, south, west, center}