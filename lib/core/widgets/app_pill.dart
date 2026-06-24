import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const AppPill({super.key, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
          boxShadow: active
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 6)]
              : [const BoxShadow(color: Color(0x0A000000), blurRadius: 4)],
        ),
        child: Text(label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            )),
      ),
    );
  }
}