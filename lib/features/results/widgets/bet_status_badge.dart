import 'package:flutter/material.dart';
import '../../bets/models/bet_status.dart';

class BetStatusBadge extends StatelessWidget {
  final BetStatus status;

  const BetStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: status.badgeBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.displayText,
        style: TextStyle(
          color: status.badgeTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
