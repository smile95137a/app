import 'package:flutter/material.dart';

class AppRefIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;

  const AppRefIcon(
    this.name, {
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_ref/$name.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
