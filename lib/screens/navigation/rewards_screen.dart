import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/vibes_provider.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibesState = ref.watch(vibesProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rewards', style: AppTheme.headingLarge),
              const SizedBox(height: AppTheme.spacingSm),
              Text('Your Wallet', style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXxl),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Vibes Balance',
                        style: AppTheme.headingMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Earn vibes, exchange for rewards',
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
                            Text('${vibesState.balance}', style: AppTheme.headingLarge.copyWith(color: AppTheme.accent)),
                            const SizedBox(height: AppTheme.spacingSm),
                            Text('Vibes', style: AppTheme.bodyMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Exchange vibes for gifts, tools, or Camino Tokens',
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textTertiary),
                        textAlign: TextAlign.center,
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
