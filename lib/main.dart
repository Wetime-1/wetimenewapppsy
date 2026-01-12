import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/profiles_provider.dart';
import 'screens/navigation/main_navigation.dart';
import 'screens/calibration/step1_group.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('user_data');

  runApp(
    const ProviderScope(
      child: WetimeApp(),
    ),
  );
}

class WetimeApp extends StatelessWidget {
  const WetimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wetime',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesState = ref.watch(profilesProvider);
    final hasProfiles = profilesState.profiles.isNotEmpty;

    return hasProfiles ? const MainNavigationScreen() : const Step1GroupScreen();
  }
}
