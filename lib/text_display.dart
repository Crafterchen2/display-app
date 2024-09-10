import 'package:flutter/material.dart';
import 'package:pionixbox/theme/pionix_theme_provider.dart';

void main() async {
  runApp(const DisplayTester());
}

class DisplayTester extends StatelessWidget {
  const DisplayTester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = PionixThemeProvider();
    return MaterialApp(
      title: 'Pionix Box',
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.light,
      theme: themeProvider.getLightTheme(),
      darkTheme: themeProvider.getDarkTheme(),
      home: const TextDisplayHome(),
    );
  }
}

class TextDisplayHome extends StatelessWidget {
  const TextDisplayHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const Text("Fonts"),
            FontDisplay(
              child: Text(
                "headlineSmall",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            FontDisplay(
              child: Text(
                "headlineMedium",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            FontDisplay(
              child: Text(
                "headlineLarge",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            FontDisplay(
              child: Text(
                "displaySmall",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            FontDisplay(
              child: Text(
                "displayMedium",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            FontDisplay(
              child: Text(
                "displayLarge",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            FontDisplay(
              child: Text(
                "titleSmall",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            FontDisplay(
              child: Text(
                "titleMedium",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FontDisplay(
              child: Text(
                "titleLarge",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FontDisplay(
              child: Text(
                "labelSmall",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            FontDisplay(
              child: Text(
                "labelMedium",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            FontDisplay(
              child: Text(
                "labelLarge",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            FontDisplay(
              child: Text(
                "bodySmall",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            FontDisplay(
              child: Text(
                "bodyMedium",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            FontDisplay(
              child: Text(
                "bodyLarge",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FontDisplay extends StatelessWidget {
  final Widget? child;

  const FontDisplay({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        right: 12,
        left: 4,
        bottom: 2,
      ),
      child: Column(
        children: [
          const Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: child ?? Container(),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
