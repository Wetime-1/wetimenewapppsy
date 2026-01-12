import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            color: AppTheme.textPrimary,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              child: LinearProgressIndicator(
                value: currentStep / totalSteps,
                backgroundColor: AppTheme.bgTertiary,
                valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            'Step $currentStep/$totalSteps',
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
