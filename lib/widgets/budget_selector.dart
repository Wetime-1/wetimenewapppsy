import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BudgetOption {
  final String value;
  final String emoji;
  final String label;

  BudgetOption({required this.value, required this.emoji, required this.label});
}

class BudgetSelector extends StatelessWidget {
  final String? selectedValue;
  final Function(String) onSelect;

  const BudgetSelector({
    super.key,
    required this.selectedValue,
    required this.onSelect,
  });

  static final List<BudgetOption> options = [
    BudgetOption(value: 'budget', emoji: '🎒', label: 'Budget'),
    BudgetOption(value: 'mid', emoji: '⭐', label: 'Comfort'),
    BudgetOption(value: 'premium', emoji: '✨', label: 'Premium'),
    BudgetOption(value: 'luxury', emoji: '👑', label: 'Luxury'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedValue == option.value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(option.value),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : [],
                ),
                child: Column(
                  children: [
                    Text(option.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      option.label,
                      style: AppTheme.bodyMedium.copyWith(
                        color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
