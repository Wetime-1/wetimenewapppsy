import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trips', style: AppTheme.headingLarge),
              const SizedBox(height: AppTheme.spacingSm),
              Text('Planned Serendipity', style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXxl),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📅', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Your Itinerary',
                        style: AppTheme.headingMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Saved plans and scheduled activities',
                        style: AppTheme.bodyMedium,
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
