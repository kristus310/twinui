// Plain Flutter ("before") and twinui ("after") versions of the same widgets.
// test/examples_equivalence_test.dart proves each pair lays out identically.
import 'package:flutter/material.dart';
import 'package:twinui/twinui.dart';

// 1. A padded, rounded, shadowed label -------------------------------------

Widget labelBefore() => Container(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          'Hello',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );

Widget labelAfter() => const Text('Hello')
    .bold()
    .fontSize(18)
    .textColor(Colors.white)
    .padding(horizontal: 20, vertical: 12)
    .decorated(
      color: Colors.indigo,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
    );

// 2. A tappable icon + text row --------------------------------------------

Widget likeBefore(VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 20),
          SizedBox(width: 8),
          Text('Like'),
        ],
      ),
    );

Widget likeAfter(VoidCallback onTap) => <Widget>[
      const Icon(Icons.favorite, size: 20),
      const Text('Like'),
    ]
        .toRow(
          mainAxisSize: MainAxisSize.min,
          separator: const SizedBox(width: 8),
        )
        .onTap(onTap);

// 3. A column with gaps between the children -------------------------------

Widget listBefore() => const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('One'),
          SizedBox(height: 16),
          Text('Two'),
          SizedBox(height: 16),
          Text('Three'),
        ],
      ),
    );

Widget listAfter() => <Widget>[
      const Text('One'),
      const Text('Two'),
      const Text('Three'),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separator: const SizedBox(height: 16),
        )
        .padding(all: 16);

// 4. An implicit fade animation ---------------------------------------------

Widget fadeBefore({required bool dimmed}) => AnimatedOpacity(
      opacity: dimmed ? 0.3 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: const Text('Fade me'),
    );

Widget fadeAfter({required bool dimmed}) => const Text('Fade me')
    .opacity(dimmed ? 0.3 : 1, animate: true)
    .animate(const Duration(milliseconds: 300), Curves.easeOut);

// 5. A rounded avatar --------------------------------------------------------

Widget avatarBefore() => SizedBox(
      width: 48,
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: const ColoredBox(
          color: Colors.teal,
          child: Center(child: Icon(Icons.person, color: Colors.white)),
        ),
      ),
    );

Widget avatarAfter() => const Icon(Icons.person)
    .iconColor(Colors.white)
    .center()
    .backgroundColor(Colors.teal)
    .clipRRect(all: 24)
    .width(48)
    .height(48);
