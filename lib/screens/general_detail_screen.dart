import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';

import '../widgets/info_cards.dart';

class GeneralDetailScreen extends StatelessWidget {
  final List<SessionDetailCardWidget> infoCards;
  final List<SessionDetailCardWidget> fullInfoCards;

  final Color boxOutlineColor;

  final Divider minorDivider;
  final Divider majorDivider;

  const GeneralDetailScreen({
    super.key,
    required this.infoCards,
    required this.fullInfoCards,
    this.boxOutlineColor = Colors.white30,
    this.minorDivider = const Divider(
      color: Colors.white10,
      thickness: 2,
    ),
    this.majorDivider = const Divider(
      color: Colors.white30,
      thickness: 2,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: adjustScale(16),
              children: infoCards,
            ),
            minorDivider,
            Padding(
              padding: EdgeInsets.only(bottom: adjustScale(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: fullInfoCards,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
