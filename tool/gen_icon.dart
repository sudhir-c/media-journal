// Generates the macOS app icon PNGs from the pixel-art "smiling TV" design.
//
// The design is authored on a 240x240 grid; this rasterizes it to every size
// the AppIcon.appiconset needs. Run with: dart run tool/gen_icon.dart
//
// Re-run after editing the `rects` below to regenerate all sizes.

import 'dart:io';

import 'package:image/image.dart' as img;

const cream = (242, 236, 221); // #F2ECDD tile
const ink = (38, 40, 29); // #26281D set + face
const mustard = (216, 165, 58); // #D8A53A screen

/// (x, y, w, h, color) on the 240-grid, painted in order.
const rects = <(double, double, double, double, (int, int, int))>[
  // antennas
  (96, 60, 12, 12, ink),
  (108, 72, 12, 12, ink),
  (144, 60, 12, 12, ink),
  (132, 72, 12, 12, ink),
  // body + screen
  (60, 84, 120, 96, ink),
  (72, 96, 84, 72, mustard),
  // knobs + legs
  (162, 114, 12, 12, ink),
  (162, 144, 12, 12, ink),
  (84, 180, 12, 12, ink),
  (144, 180, 12, 12, ink),
  // eyes
  (90, 114, 12, 12, ink),
  (126, 114, 12, 12, ink),
  // smile (finer 6px pixels)
  (90, 138, 6, 6, ink),
  (132, 138, 6, 6, ink),
  (96, 144, 6, 6, ink),
  (126, 144, 6, 6, ink),
  (102, 150, 6, 6, ink),
  (108, 150, 6, 6, ink),
  (114, 150, 6, 6, ink),
  (120, 150, 6, 6, ink),
];

const tileRadius = 54.0; // on the 240 grid

const outputs = {
  'app_icon_16.png': 16,
  'app_icon_32.png': 32,
  'app_icon_64.png': 64,
  'app_icon_128.png': 128,
  'app_icon_256.png': 256,
  'app_icon_512.png': 512,
  'app_icon_1024.png': 1024,
};

img.ColorRgba8 _c((int, int, int) rgb, [int a = 255]) =>
    img.ColorRgba8(rgb.$1, rgb.$2, rgb.$3, a);

img.Image render(int size) {
  final s = size / 240.0;
  int sc(double v) => (v * s).round();
  final image = img.Image(width: size, height: size, numChannels: 4);

  // Rounded cream tile (transparent corners).
  img.fillRect(
    image,
    x1: 0,
    y1: 0,
    x2: size - 1,
    y2: size - 1,
    radius: tileRadius * s,
    color: _c(cream),
  );

  for (final (x, y, w, h, color) in rects) {
    img.fillRect(
      image,
      x1: sc(x),
      y1: sc(y),
      x2: sc(x + w) - 1,
      y2: sc(y + h) - 1,
      color: _c(color),
    );
  }
  return image;
}

void main() {
  final dir = Directory('macos/Runner/Assets.xcassets/AppIcon.appiconset');
  if (!dir.existsSync()) {
    stderr.writeln('AppIcon.appiconset not found — run from the project root.');
    exit(1);
  }
  outputs.forEach((name, size) {
    final png = img.encodePng(render(size));
    File('${dir.path}/$name').writeAsBytesSync(png);
    stdout.writeln('wrote $name (${size}px)');
  });
}
