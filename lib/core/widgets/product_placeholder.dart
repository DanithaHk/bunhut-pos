import 'package:flutter/material.dart';

class ProductPlaceholder extends StatelessWidget {
  final Color tone;
  final String? label;
  final double height;

  const ProductPlaceholder({
    super.key, required this.tone, this.label, this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final darker = HSLColor.fromColor(tone)
        .withLightness((HSLColor.fromColor(tone).lightness - 0.06).clamp(0, 1))
        .toColor();

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [tone, darker],
          transform: const GradientRotation(0.785), // 45°
          tileMode: TileMode.repeated,
          stops: const [0, 0.5],
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: label != null
          ? Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label!,
              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500)),
        ),
      )
          : null,
    );
  }
}