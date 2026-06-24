import 'package:bunhut_pos/core/constants/app_colors.dart';
import 'package:bunhut_pos/core/constants/app_size.dart';
import 'package:flutter/cupertino.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, this.padding, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: onTap,
     child: Container(
       padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
       decoration: BoxDecoration(
         color: AppColors.surface,
         borderRadius: BorderRadius.circular(AppSizes.cardRadius),
         border: Border.all(color: AppColors.border),
         boxShadow: const [
           BoxShadow(color: Color(0x0A000000), blurRadius: 12 , offset: Offset(0, 4))
         ]
       ),
       child: child,
     ),
   );
  }

}