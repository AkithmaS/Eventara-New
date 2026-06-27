import 'package:flutter/material.dart';

/// Reusable brand logo widget with icon + text
/// Ensures consistent styling everywhere the brand name is used
class BrandLogo extends StatelessWidget {
  final bool showIcon;
  final double fontSize;
  final Color textColor;
  final double letterSpacing;

  const BrandLogo({
    super.key,
    this.showIcon = true,
    this.fontSize = 16,
    this.textColor = const Color(0xFF9B8AFB), // _purpleLight
    this.letterSpacing = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Image.asset(
            'assets/icons/icon.png',
            width: fontSize + 4,
            height: fontSize + 4,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          'EVENTARA',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            letterSpacing: letterSpacing,
          ),
        ),
      ],
    );
  }
}
