import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/calibration_provider.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/context_toggle.dart';
import '../../widgets/continue_button.dart';
import 'step5_name.dart';

class Step4ContextScreen extends ConsumerWidget {
  const Step4ContextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibration = ref.watch(calibrationProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProgressHeader(
              currentStep: 4,
              totalSteps: 5,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SMART FILTERS', style: AppTheme.labelSmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Context awareness', style: AppTheme.headingLarge),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Let the app adapt to reality', style: AppTheme.bodyMedium),
                    const SizedBox(height: AppTheme.spacingXxl),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ContextToggle(
                              emoji: '🌦️',
                              title: 'Weather Filtering',
                              subtitle: 'Hide outdoor when rain',
                              value: calibration.weatherFilter,
                              onChanged: (val) => 
                                  ref.read(calibrationProvider.notifier).setWeatherFilter(val),
                            ),
                            ContextToggle(
                              emoji: '🕐',
                              title: 'Time Awareness',
                              subtitle: 'Bars at night, café AM',
                              value: calibration.timeAwareness,
                              onChanged: (val) => 
                                  ref.read(calibrationProvider.notifier).setTimeAwareness(val),
                            ),
                            ContextToggle(
                              emoji: '👥',
                              title: 'Crowd Avoidance',
                              subtitle: 'Skip busy hotspots',
                              value: calibration.crowdAvoidance,
                              onChanged: (val) => 
                                  ref.read(calibrationProvider.notifier).setCrowdAvoidance(val),
                            ),
                            ContextToggle(
                              emoji: '🎫',
                              title: 'Live Availability',
                              subtitle: 'Only show open spots',
                              value: calibration.liveAvailability,
                              onChanged: (val) => 
                                  ref.read(calibrationProvider.notifier).setLiveAvailability(val),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ContinueButton(
                      isActive: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Step5NameScreen()),
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
