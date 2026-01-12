import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';
import 'radar_screen.dart';
import 'trips_screen.dart';
import 'rewards_screen.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    final screens = [
      const RadarScreen(),
      const TripsScreen(),
      const RewardsScreen(),
      const HomeScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.accent,
          unselectedItemColor: AppTheme.textTertiary,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Text('🧭', style: TextStyle(fontSize: 24)),
              label: 'Radar',
            ),
            BottomNavigationBarItem(
              icon: Text('📅', style: TextStyle(fontSize: 24)),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Text('👛', style: TextStyle(fontSize: 24)),
              label: 'Rewards',
            ),
            BottomNavigationBarItem(
              icon: Text('👤', style: TextStyle(fontSize: 24)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
