import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/calibration_provider.dart';
import '../../providers/vibes_provider.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/continue_button.dart';
import '../../widgets/vibes_earned_toast.dart';
import 'step4_context.dart';

class Step3LocationScreen extends ConsumerWidget {
  const Step3LocationScreen({super.key});

  static final List<Map<String, String>> cities = [
    {'city': 'Brussels', 'country': 'Belgium', 'flag': '🇧🇪'},
    {'city': 'Barcelona', 'country': 'Spain', 'flag': '🇪🇸'},
    {'city': 'Paris', 'country': 'France', 'flag': '🇫🇷'},
    {'city': 'Amsterdam', 'country': 'Netherlands', 'flag': '🇳🇱'},
    {'city': 'Rome', 'country': 'Italy', 'flag': '🇮🇹'},
    {'city': 'Lisbon', 'country': 'Portugal', 'flag': '🇵🇹'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibration = ref.watch(calibrationProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProgressHeader(
              currentStep: 3,
              totalSteps: 5,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YOUR ADVENTURE', style: AppTheme.labelSmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Where are we heading?', style: AppTheme.headingLarge),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Curated local experiences await', style: AppTheme.bodyMedium),
                    const SizedBox(height: AppTheme.spacingXxl),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLg,
                        vertical: AppTheme.spacingMd,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.bgSecondary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppTheme.textTertiary),
                          const SizedBox(width: AppTheme.spacingMd),
                          Text(
                            calibration.location ?? 'Search city...',
                            style: AppTheme.bodyLarge.copyWith(
                              color: calibration.location != null 
                                  ? AppTheme.textPrimary 
                                  : AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          final isSelected = calibration.location == city['city'];
                          return GestureDetector(
                            onTap: () {
                              final wasNull = ref.read(calibrationProvider).location == null;
                              ref.read(calibrationProvider.notifier).setLocation(
                                city['city']!,
                                city['country']!,
                              );
                              if (wasNull) {
                                ref.read(vibesProvider.notifier).earnVibes(15, 'Chose your destination');
                                showVibesEarned(context, 15);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                              padding: const EdgeInsets.all(AppTheme.spacingLg),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.accentLight : Colors.white,
                                border: Border.all(
                                  color: isSelected ? AppTheme.accent : AppTheme.border,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              ),
                              child: Row(
                                children: [
                                  Text(city['flag']!, style: const TextStyle(fontSize: 24)),
                                  const SizedBox(width: AppTheme.spacingMd),
                                  Text(
                                    '${city['city']}, ${city['country']}',
                                    style: AppTheme.bodyLarge.copyWith(
                                      color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    ContinueButton(
                      isActive: calibration.isLocationSelected,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Step4ContextScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
