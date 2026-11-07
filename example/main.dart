// Shows each before/after pair side by side.
// Run it from any app that depends on twinui:
//   flutter run -t path/to/twinui/example/main.dart
import 'package:flutter/material.dart';

import 'before_after.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'twinui before / after',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const ExamplePage(),
      );
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool dimmed = false;
  int likes = 0;

  Widget _pair(String title, Widget before, Widget after) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Text('plain Flutter'), before],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Text('twinui'), after],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('twinui: before / after')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _pair('1. Padded, rounded, shadowed label', labelBefore(),
                labelAfter()),
            _pair(
              '2. Tappable icon + text (taps so far: $likes)',
              likeBefore(() => setState(() => likes++)),
              likeAfter(() => setState(() => likes++)),
            ),
            _pair('3. Column with gaps', listBefore(), listAfter()),
            SwitchListTile(
              title: const Text('Dim the fade example'),
              value: dimmed,
              onChanged: (v) => setState(() => dimmed = v),
            ),
            _pair('4. Implicit fade animation', fadeBefore(dimmed: dimmed),
                fadeAfter(dimmed: dimmed)),
            _pair('5. Rounded avatar', avatarBefore(), avatarAfter()),
          ],
        ),
      );
}
