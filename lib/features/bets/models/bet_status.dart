import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum BetStatus {
  open,
  won,
  lost,
  voided;

  String get displayText {
    switch (this) {
      case BetStatus.open:
        return 'Open';
      case BetStatus.won:
        return 'Won';
      case BetStatus.lost:
        return 'Lost';
      case BetStatus.voided:
        return 'Void';
    }
  }

  Color get badgeTextColor {
    switch (this) {
      case BetStatus.open:
        return AppColors.warning;
      case BetStatus.won:
        return AppColors.green;
      case BetStatus.lost:
        return AppColors.danger;
      case BetStatus.voided:
        return AppColors.textSecondary;
    }
  }

  Color get badgeBgColor {
    switch (this) {
      case BetStatus.open:
        return AppColors.warningDark;
      case BetStatus.won:
        return AppColors.greenDarkBadge;
      case BetStatus.lost:
        return AppColors.dangerDark;
      case BetStatus.voided:
        return const Color(0xFF2A2A2A);
    }
  }

  static BetStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'won':
        return BetStatus.won;
      case 'lost':
        return BetStatus.lost;
      case 'voided':
      case 'void':
        return BetStatus.voided;
      default:
        return BetStatus.open;
    }
  }
}
