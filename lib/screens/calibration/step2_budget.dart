import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/calibration_provider.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/budget_selector.dart';
import '../../widgets/continue_button.dart';
import 'step3_location.dart';

class Step2BudgetScreen extends ConsumerWidget {
  const Step2BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibration = ref.watch(calibrationProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProgressHeader(
              currentStep: 2,
              totalSteps: 5,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RESOURCES', style: AppTheme.labelSmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Your comfort zone?', style: AppTheme.headingLarge),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('We find gems at every level', style: AppTheme.bodyMedium),
                    const SizedBox(height: AppTheme.spacingXxl),
                    BudgetSelector(
                      selectedValue: calibration.budget,
                      onSelect: (value) => ref.read(calibrationProvider.notifier).setBudget(value),
                    ),
                    const Spacer(),
                    ContinueButton(
                      isActive: calibration.isBudgetSelected,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Step3LocationScreen()),
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
