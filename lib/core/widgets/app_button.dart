
import 'package:bunhut_pos/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget{
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color startColor;
  final Color? endColor;

  const PrimaryButton({super.key, required this.label, this.onPressed, this.icon, required this.startColor, this.endColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            startColor , endColor ?? AppColors.primaryDark
          ],
            begin: Alignment.topCenter,
            end:  Alignment.bottomCenter
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(
            color: startColor.withOpacity(0.38),
            offset: const Offset(0, 6),
            blurRadius: 12
          )]
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon!=null) ...[icon! ,const SizedBox(width: 8)],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white , fontSize: 15,
                fontWeight: FontWeight.w700
              ),
            )
          ],
        ),
      ),

    );
  }
}
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GhostButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Text(label,
          style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w500)),
    );
  }
}