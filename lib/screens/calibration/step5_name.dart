import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/calibration_provider.dart';
import '../../providers/profiles_provider.dart';
import '../../providers/vibes_provider.dart';
import '../../models/trip_profile.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/continue_button.dart';
import '../../widgets/vibes_earned_toast.dart';
import '../navigation/main_navigation.dart';

class Step5NameScreen extends ConsumerStatefulWidget {
  const Step5NameScreen({super.key});

  @override
  ConsumerState<Step5NameScreen> createState() => _Step5NameScreenState();
}

class _Step5NameScreenState extends ConsumerState<Step5NameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<String> _getSuggestions() {
    final calibration = ref.read(calibrationProvider);
    final groupLabel = {
      'solo': 'Solo',
      'couple': 'Romantic',
      'family': 'Family',
      'friends': 'Squad'
    }[calibration.group] ?? '';
    
    return [
      '$groupLabel ${calibration.location}',
      '${calibration.budget?.toUpperCase()} Trip',
      '${calibration.location} Adventure',
    ];
  }

  void _createProfile() async {
    final calibration = ref.read(calibrationProvider);
    final name = _nameController.text.trim();
    
    if (name.isEmpty) return;

    final profile = TripProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      group: calibration.group!,
      budget: calibration.budget!,
      location: calibration.location!,
      country: calibration.country!,
      name: name,
      icon: TripProfile.getIconForGroup(calibration.group!),
      weatherFilter: calibration.weatherFilter,
      timeAwareness: calibration.timeAwareness,
      crowdAvoidance: calibration.crowdAvoidance,
      liveAvailability: calibration.liveAvailability,
      createdAt: DateTime.now(),
    );

    await ref.read(profilesProvider.notifier).addProfile(profile);
    
    // Award vibes for completing onboarding
    await ref.read(vibesProvider.notifier).earnVibes(50, 'First trip created!');
    showVibesEarned(context, 50);
    
    ref.read(calibrationProvider.notifier).reset();

    if (mounted) {
      // Show vibes earned notification after short delay
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _showVibesEarnedDialog();
      }
    }
  }

  Widget _buildVibeRow(String label, int amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: bold 
                ? AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold) 
                : AppTheme.bodyMedium,
          ),
          Text(
            '+$amount ✨', 
            style: bold 
                ? AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppTheme.accent) 
                : AppTheme.bodyMedium.copyWith(color: AppTheme.accent),
          ),
        ],
      ),
    );
  }

  void _showVibesEarnedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 64)),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                'You earned 100 Vibes!',
                style: AppTheme.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                'Welcome bonus complete',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.bgSecondary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Column(
                  children: [
                    _buildVibeRow('Started journey', 5),
                    _buildVibeRow('Travel group', 10),
                    _buildVibeRow('Budget style', 10),
                    _buildVibeRow('Destination', 15),
                    _buildVibeRow('Preferences', 10),
                    _buildVibeRow('First trip created', 50),
                    const Divider(),
                    _buildVibeRow('Total', 100, bold: true),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  child: Text(
                    'Start Exploring',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _getSuggestions();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProgressHeader(
              currentStep: 5,
              totalSteps: 5,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ALMOST DONE', style: AppTheme.labelSmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Name this journey', style: AppTheme.headingLarge),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Save it for easy access later', style: AppTheme.bodyMedium),
                    const SizedBox(height: AppTheme.spacingXxl),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Solo Weekend Explorer',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: const BorderSide(color: AppTheme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: const BorderSide(color: AppTheme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: const BorderSide(color: AppTheme.accent, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
                      ),
                      style: AppTheme.bodyLarge,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    Text('Suggestions:', style: AppTheme.bodyMedium),
                    const SizedBox(height: AppTheme.spacingSm),
                    Wrap(
                      spacing: AppTheme.spacingSm,
                      runSpacing: AppTheme.spacingSm,
                      children: suggestions.map((suggestion) {
                        return GestureDetector(
                          onTap: () {
                            _nameController.text = suggestion;
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.bgSecondary,
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Text(suggestion, style: AppTheme.bodyMedium),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    ContinueButton(
                      text: "Let's go!",
                      isActive: _nameController.text.trim().isNotEmpty,
                      onPressed: _createProfile,
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
