import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'team_logo.dart';

class SoccerKitIcon extends StatelessWidget {
  final String teamName;
  final double size;
  const SoccerKitIcon({super.key, required this.teamName, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final color = TeamLogo.teamColor(teamName);
    return SvgPicture.asset(
      'assets/icons/soccer_jersey.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
