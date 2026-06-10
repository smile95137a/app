import 'package:flutter/material.dart';

/// Loads a real DraftKings icon extracted into assets/images/reference/.
/// [tint] (optional) recolors the icon's opaque pixels — used for nav
/// active/inactive states. Leave null to show the icon in its original colors.
class RefIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final Color? tint;

  const RefIcon(
    this.name, {
    super.key,
    required this.width,
    required this.height,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      'assets/images/reference/$name.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
    if (tint == null) return img;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(tint!, BlendMode.srcIn),
      child: img,
    );
  }
}
