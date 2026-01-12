import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Radar', style: AppTheme.headingLarge),
              const SizedBox(height: AppTheme.spacingSm),
              Text('Passive Discovery', style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXxl),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🧭', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Live Map',
                        style: AppTheme.headingMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Filtered vouchers & places nearby',
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
