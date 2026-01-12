import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rewards', style: AppTheme.headingLarge),
              const SizedBox(height: AppTheme.spacingSm),
              Text('The Economy', style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXxl),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('👛', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Vibe Counter',
                        style: AppTheme.headingMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Vibe Store & Camino Token Exchange',
                        style: AppTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingXxl),
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingLg),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLight,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        child: Column(
                          children: [
                            Text('0', style: AppTheme.headingLarge.copyWith(color: AppTheme.accent)),
                            const SizedBox(height: AppTheme.spacingSm),
                            Text('Camino Tokens', style: AppTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
