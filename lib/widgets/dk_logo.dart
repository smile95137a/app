import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

// ─────────────────────────────────────────────
// Header app icon: real dk_app_icon.png asset
// Green circle with white DraftKings crown
// ─────────────────────────────────────────────
class DkAppIcon extends StatelessWidget {
  final double size;
  const DkAppIcon({super.key, this.size = 42});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/dk_app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Full DRAFTKINGS logo: real dk_logo.png asset
// Transparent background — blends into dark cards
// ─────────────────────────────────────────────
class DkLogo extends StatelessWidget {
  final double height;
  const DkLogo({super.key, this.height = 22});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/dk_logo.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}

// ─────────────────────────────────────────────
// Orange crown only (for standalone use)
// ─────────────────────────────────────────────
class DkCrown extends StatelessWidget {
  final double height;
  const DkCrown({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/dk_crown.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}

// ─────────────────────────────────────────────
// "THE CROWN IS YOURS" — used in Won card header
// ─────────────────────────────────────────────
class CrownIsYours extends StatelessWidget {
  final double fontSize;
  const CrownIsYours({super.key, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'THE CROWN IS ',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          TextSpan(
            text: 'YOURS',
            style: TextStyle(
              color: AppColors.green,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
