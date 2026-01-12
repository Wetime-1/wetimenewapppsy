import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/profiles_provider.dart';
import '../calibration/step1_group.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesState = ref.watch(profilesProvider);
    final activeProfile = profilesState.activeProfile;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wetime', style: AppTheme.headingLarge),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXxl),

                // Weather Banner (Mock)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Text('🌧️', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '14°C in ${activeProfile?.location ?? "Brussels"}',
                              style: AppTheme.headingMedium,
                            ),
                            Text(
                              'Light rain expected',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight,
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text('Indoor +40%', style: AppTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXxl),

                // Active Trip Card
                if (activeProfile != null) ...[
                  Text('ACTIVE TRIP', style: AppTheme.labelSmall),
                  const SizedBox(height: AppTheme.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(activeProfile.icon, style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activeProfile.name, style: AppTheme.headingMedium),
                                  Text(
                                    '${activeProfile.location} • ${activeProfile.budget}',
                                    style: AppTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('234', style: AppTheme.headingMedium.copyWith(color: AppTheme.accent)),
                                Text('Matches', style: AppTheme.bodyMedium),
                              ],
                            ),
                            Column(
                              children: [
                                Text('89', style: AppTheme.headingMedium.copyWith(color: AppTheme.accent)),
                                Text('Weather', style: AppTheme.bodyMedium),
                              ],
                            ),
                            Column(
                              children: [
                                Text('12', style: AppTheme.headingMedium.copyWith(color: AppTheme.accent)),
                                Text('Near', style: AppTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                                ),
                                child: const Text('Explore'),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                              ),
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXxl),
                ],

                // Saved Profiles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SAVED PROFILES', style: AppTheme.labelSmall),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Step1GroupScreen()),
                        );
                      },
                      child: Text('+ New', style: AppTheme.bodyMedium.copyWith(color: AppTheme.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // New Profile Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Step1GroupScreen()),
                          );
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: AppTheme.spacingMd),
                          decoration: BoxDecoration(
                            color: AppTheme.bgSecondary,
                            border: Border.all(color: AppTheme.border, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, size: 32, color: AppTheme.textTertiary),
                              const SizedBox(height: AppTheme.spacingSm),
                              Text('New', style: AppTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      // Existing Profiles
                      ...profilesState.profiles.map((profile) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(profilesProvider.notifier).setActiveProfile(profile.id);
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: AppTheme.spacingMd),
                            padding: const EdgeInsets.all(AppTheme.spacingMd),
                            decoration: BoxDecoration(
                              color: activeProfile?.id == profile.id ? AppTheme.accentLight : Colors.white,
                              border: Border.all(
                                color: activeProfile?.id == profile.id ? AppTheme.accent : AppTheme.border,
                                width: activeProfile?.id == profile.id ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(profile.icon, style: const TextStyle(fontSize: 32)),
                                const SizedBox(height: AppTheme.spacingSm),
                                Text(
                                  profile.name,
                                  style: AppTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXxl),

                // Patterns
                Text('YOUR PATTERNS', style: AppTheme.labelSmall),
                const SizedBox(height: AppTheme.spacingMd),
                _PatternCard(
                  emoji: '🍜',
                  text: 'Always splurge on food',
                ),
                _PatternCard(
                  emoji: '🌳',
                  text: 'Family = outdoor focused',
                ),
                _PatternCard(
                  emoji: '🌙',
                  text: 'Solo = nightlife heavy',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String emoji;
  final String text;

  const _PatternCard({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppTheme.spacingMd),
          Text(text, style: AppTheme.bodyMedium),
        ],
      ),
    );
  }
}
