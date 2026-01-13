import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/vibes_provider.dart';

class ProgressHeader extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final vibesState = ref.watch(vibesProvider);
    
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✨', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${vibesState.balance}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
