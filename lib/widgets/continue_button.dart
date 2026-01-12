import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ContinueButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const ContinueButton({
    super.key,
    this.text = 'Continue',
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent : AppTheme.border,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTheme.headingMedium.copyWith(
            color: isActive ? Colors.white : AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }
}
