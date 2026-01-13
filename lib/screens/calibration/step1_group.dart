import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/calibration_provider.dart';
import '../../providers/vibes_provider.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/option_card.dart';
import '../../widgets/continue_button.dart';
import '../../widgets/vibes_earned_toast.dart';
import 'step2_budget.dart';

class Step1GroupScreen extends ConsumerWidget {
  const Step1GroupScreen({super.key});

  void _selectGroup(BuildContext context, WidgetRef ref, String group) {
    final wasNull = ref.read(calibrationProvider).group == null;
    ref.read(calibrationProvider.notifier).setGroup(group);
    if (wasNull) {
      ref.read(vibesProvider.notifier).earnVibes(10, 'Selected travel group');
      showVibesEarned(context, 10);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibration = ref.watch(calibrationProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProgressHeader(
              currentStep: 1,
              totalSteps: 5,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ABOUT YOU', style: AppTheme.labelSmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Who are you traveling with?', style: AppTheme.headingLarge),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('This helps tailor your recommendations', style: AppTheme.bodyMedium),
                    const SizedBox(height: AppTheme.spacingXxl),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppTheme.spacingMd,
                        mainAxisSpacing: AppTheme.spacingMd,
                        children: [
                          OptionCard(
                            emoji: '🎒',
                            label: 'Solo',
                            description: 'Freedom',
                            isSelected: calibration.group == 'solo',
                            onTap: () => _selectGroup(context, ref, 'solo'),
                          ),
                          OptionCard(
                            emoji: '💑',
                            label: 'Couple',
                            description: 'Romance',
                            isSelected: calibration.group == 'couple',
                            onTap: () => _selectGroup(context, ref, 'couple'),
                          ),
                          OptionCard(
                            emoji: '👨‍👩‍👧‍👦',
                            label: 'Family',
                            description: 'Kid-focus',
                            isSelected: calibration.group == 'family',
                            onTap: () => _selectGroup(context, ref, 'family'),
                          ),
                          OptionCard(
                            emoji: '🎉',
                            label: 'Friends',
                            description: 'Squad',
                            isSelected: calibration.group == 'friends',
                            onTap: () => _selectGroup(context, ref, 'friends'),
                          ),
                        ],
                      ),
                    ),
                    ContinueButton(
                      isActive: calibration.isGroupSelected,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Step2BudgetScreen()),
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
