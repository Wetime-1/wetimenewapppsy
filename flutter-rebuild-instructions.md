# 🚨 FLUTTER APP REBUILD INSTRUCTIONS

## What's Wrong With Current Code

I reviewed your code. Here are the problems:

---

### Problem 1: DUPLICATE CLASSES

You have `UserProfile` defined in TWO places:
- `lib/core/services/profile_service.dart`
- `lib/core/models/video_model.dart`

This will cause conflicts and confusion.

**FIX:** Delete one, keep one clear model.

---

### Problem 2: WRONG DATA MODEL

Your current `UserProfile` in profile_service.dart:
```dart
class UserProfile {
  final bool? isSolo;        // ❌ Too simple
  final int tokens;          // ❌ Gamification (later)
  final Map<String, int> vibeScores;  // ❌ Not needed now
  final int explorerLevel;   // ❌ Gamification (later)
}
```

**What it should be:**
```dart
class TripProfile {
  final String id;
  final String group;        // "solo" | "couple" | "family" | "friends"
  final String budget;       // "budget" | "mid" | "premium" | "luxury"
  final String location;     // "Brussels"
  final String country;      // "Belgium"
  final String name;         // "Solo Weekend"
  final String icon;         // "🎒"
  final ContextSettings context;
  final DateTime createdAt;
}

class ContextSettings {
  final bool weatherFilter;
  final bool timeAwareness;
  final bool crowdAvoidance;
  final bool liveAvailability;
}
```

---

### Problem 3: ONBOARDING IS INCOMPLETE

Your current onboarding (`onboarding_flow.dart`) only has:
- Step 1: Travel Style (Solo, Family, Friends, Group)
- Step 2: Interests (Adventure, Culture, Food, etc.)

**What it should have:**
- Step 1: Travel Group (Solo, Couple, Family, Friends)
- Step 2: Budget (Budget, Comfort, Premium, Luxury)
- Step 3: Location (Search + GPS)
- Step 4: Context Settings (4 toggles)
- Step 5: Name Your Trip

You're missing 3 entire screens!

---

### Problem 4: NO TRIP PROFILES SYSTEM

Your app treats calibration as ONE-TIME onboarding.
User fills it once → never again.

**What it should be:**
- User can create MULTIPLE trip profiles
- User can SWITCH between profiles
- User can EDIT existing profiles
- Each trip to a new city = new profile

---

### Problem 5: BUBBLE WIDGET IS WRONG APPROACH

Your `bubble_widget.dart` shows a popup after 5 seconds asking "Solo or Group?"

This is the OLD approach we rejected. The research said:
> "Don't interrupt with questions. Make it feel like discovery."

**DELETE** the bubble_widget.dart approach.
**USE** the full calibration flow instead.

---

### Problem 6: CONTEXT SERVICE IS USELESS

Your `context_service.dart`:
```dart
return ContextState(
  isRaining: true,   // ❌ Hardcoded!
  isNight: true,     // ❌ Hardcoded!
  isCrowded: false,  // ❌ Hardcoded!
);
```

This does nothing. It always returns the same values.

**What it should do:**
1. Get user's selected location
2. Call Weather API with that location
3. Return REAL weather data
4. Check device time for isNight

---

### Problem 7: PROFILE PAGE IS WRONG

Your `profile_page.dart` shows:
- User name, email
- Travel style, budget
- List of trips

This is a SETTINGS page, not what we designed.

**What it should be:**
- HOME SCREEN with:
  - Weather banner (live data)
  - Active trip card
  - Saved profiles (horizontal scroll)
  - Pattern insights

---

### Problem 8: NO CLEAN DESIGN SYSTEM

Your code uses random colors:
```dart
backgroundColor: Colors.indigo,
backgroundColor: Colors.orangeAccent,
```

**What it should use:**
A proper theme file with consistent colors.

---

## 🔨 COMPLETE REBUILD INSTRUCTIONS

### STEP 1: DELETE THESE FILES

```
❌ DELETE: lib/core/services/profile_service.dart (wrong model)
❌ DELETE: lib/features/feed/bubble_widget.dart (wrong approach)
❌ DELETE: lib/features/onboarding/onboarding_flow.dart (incomplete)
❌ DELETE: lib/features/profile/profile_page.dart (wrong design)
```

Keep:
```
✅ KEEP: lib/main.dart (but modify)
✅ KEEP: lib/core/services/context_service.dart (but rewrite)
✅ KEEP: lib/core/models/video_model.dart (but clean up)
✅ KEEP: lib/features/feed/feed_screen.dart (for later)
✅ KEEP: lib/features/feed/video_item.dart (for later)
```

---

### STEP 2: CREATE NEW FOLDER STRUCTURE

```
lib/
├── main.dart
│
├── theme/
│   └── app_theme.dart              ← NEW: Colors, fonts, spacing
│
├── models/
│   ├── trip_profile.dart           ← NEW: TripProfile class
│   └── weather_data.dart           ← NEW: Weather model
│
├── providers/
│   ├── calibration_provider.dart   ← NEW: Current calibration state
│   ├── profiles_provider.dart      ← NEW: Saved profiles
│   └── weather_provider.dart       ← NEW: Weather data
│
├── services/
│   ├── storage_service.dart        ← NEW: Hive operations
│   ├── weather_service.dart        ← NEW: Weather API
│   └── location_service.dart       ← NEW: GPS + city search
│
├── screens/
│   ├── home/
│   │   └── home_screen.dart        ← NEW: Main dashboard
│   │
│   ├── calibration/
│   │   ├── step1_group.dart        ← NEW
│   │   ├── step2_budget.dart       ← NEW
│   │   ├── step3_location.dart     ← NEW
│   │   ├── step4_context.dart      ← NEW
│   │   ├── step5_name.dart         ← NEW
│   │   └── processing_screen.dart  ← NEW
│   │
│   └── feed/
│       └── feed_screen.dart        (existing, keep for later)
│
└── widgets/
    ├── option_card.dart            ← NEW: Selectable card
    ├── budget_selector.dart        ← NEW: Budget bar
    ├── location_input.dart         ← NEW: Search field
    ├── context_toggle.dart         ← NEW: Toggle row
    ├── weather_banner.dart         ← NEW: Weather display
    ├── active_trip_card.dart       ← NEW: Active trip
    ├── profile_card.dart           ← NEW: Saved profile card
    └── progress_header.dart        ← NEW: Step progress
```

---

### STEP 3: CREATE THEME FILE

Create `lib/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF8F9FA);
  static const Color bgTertiary = Color(0xFFF1F3F4);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textTertiary = Color(0xFF9AA0A6);
  
  static const Color accent = Color(0xFF1A73E8);
  static const Color accentLight = Color(0xFFE8F0FE);
  
  static const Color success = Color(0xFF34A853);
  static const Color successLight = Color(0xFFE6F4EA);
  
  static const Color warning = Color(0xFFEA8600);
  static const Color warningLight = Color(0xFFFEF7E0);
  
  static const Color border = Color(0xFFE8EAED);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusFull = 100.0;

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textTertiary,
    letterSpacing: 0.5,
  );

  // ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgPrimary,
      colorScheme: ColorScheme.light(
        primary: accent,
        secondary: accentLight,
        surface: bgPrimary,
        background: bgSecondary,
      ),
      fontFamily: 'Inter', // Add Inter font to pubspec.yaml
      appBarTheme: const AppBarTheme(
        backgroundColor: bgPrimary,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
    );
  }
}
```

---

### STEP 4: CREATE TRIP PROFILE MODEL

Create `lib/models/trip_profile.dart`:

```dart
import 'package:hive/hive.dart';

part 'trip_profile.g.dart'; // Generated by build_runner

@HiveType(typeId: 0)
class TripProfile {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String group; // solo, couple, family, friends
  
  @HiveField(2)
  final String budget; // budget, mid, premium, luxury
  
  @HiveField(3)
  final String location;
  
  @HiveField(4)
  final String country;
  
  @HiveField(5)
  final String name;
  
  @HiveField(6)
  final String icon;
  
  @HiveField(7)
  final bool weatherFilter;
  
  @HiveField(8)
  final bool timeAwareness;
  
  @HiveField(9)
  final bool crowdAvoidance;
  
  @HiveField(10)
  final bool liveAvailability;
  
  @HiveField(11)
  final DateTime createdAt;

  TripProfile({
    required this.id,
    required this.group,
    required this.budget,
    required this.location,
    required this.country,
    required this.name,
    required this.icon,
    this.weatherFilter = true,
    this.timeAwareness = true,
    this.crowdAvoidance = false,
    this.liveAvailability = true,
    required this.createdAt,
  });

  // Helper to get icon based on group
  static String getIconForGroup(String group) {
    switch (group) {
      case 'solo': return '🎒';
      case 'couple': return '💑';
      case 'family': return '👨‍👩‍👧‍👦';
      case 'friends': return '🎉';
      default: return '✈️';
    }
  }

  // Copy with method for updates
  TripProfile copyWith({
    String? id,
    String? group,
    String? budget,
    String? location,
    String? country,
    String? name,
    String? icon,
    bool? weatherFilter,
    bool? timeAwareness,
    bool? crowdAvoidance,
    bool? liveAvailability,
    DateTime? createdAt,
  }) {
    return TripProfile(
      id: id ?? this.id,
      group: group ?? this.group,
      budget: budget ?? this.budget,
      location: location ?? this.location,
      country: country ?? this.country,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      weatherFilter: weatherFilter ?? this.weatherFilter,
      timeAwareness: timeAwareness ?? this.timeAwareness,
      crowdAvoidance: crowdAvoidance ?? this.crowdAvoidance,
      liveAvailability: liveAvailability ?? this.liveAvailability,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

After creating this file, run:
```bash
flutter pub run build_runner build
```

---

### STEP 5: CREATE CALIBRATION PROVIDER

Create `lib/providers/calibration_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class for calibration in progress
class CalibrationState {
  final String? group;
  final String? budget;
  final String? location;
  final String? country;
  final bool weatherFilter;
  final bool timeAwareness;
  final bool crowdAvoidance;
  final bool liveAvailability;
  final String? name;

  CalibrationState({
    this.group,
    this.budget,
    this.location,
    this.country,
    this.weatherFilter = true,
    this.timeAwareness = true,
    this.crowdAvoidance = false,
    this.liveAvailability = true,
    this.name,
  });

  CalibrationState copyWith({
    String? group,
    String? budget,
    String? location,
    String? country,
    bool? weatherFilter,
    bool? timeAwareness,
    bool? crowdAvoidance,
    bool? liveAvailability,
    String? name,
  }) {
    return CalibrationState(
      group: group ?? this.group,
      budget: budget ?? this.budget,
      location: location ?? this.location,
      country: country ?? this.country,
      weatherFilter: weatherFilter ?? this.weatherFilter,
      timeAwareness: timeAwareness ?? this.timeAwareness,
      crowdAvoidance: crowdAvoidance ?? this.crowdAvoidance,
      liveAvailability: liveAvailability ?? this.liveAvailability,
      name: name ?? this.name,
    );
  }

  // Check if step is complete
  bool get isGroupSelected => group != null;
  bool get isBudgetSelected => budget != null;
  bool get isLocationSelected => location != null;
  bool get isNameEntered => name != null && name!.isNotEmpty;

  // Reset state
  CalibrationState reset() {
    return CalibrationState();
  }
}

// Notifier
class CalibrationNotifier extends StateNotifier<CalibrationState> {
  CalibrationNotifier() : super(CalibrationState());

  void setGroup(String group) {
    state = state.copyWith(group: group);
  }

  void setBudget(String budget) {
    state = state.copyWith(budget: budget);
  }

  void setLocation(String location, String country) {
    state = state.copyWith(location: location, country: country);
  }

  void setWeatherFilter(bool value) {
    state = state.copyWith(weatherFilter: value);
  }

  void setTimeAwareness(bool value) {
    state = state.copyWith(timeAwareness: value);
  }

  void setCrowdAvoidance(bool value) {
    state = state.copyWith(crowdAvoidance: value);
  }

  void setLiveAvailability(bool value) {
    state = state.copyWith(liveAvailability: value);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void reset() {
    state = CalibrationState();
  }
}

// Provider
final calibrationProvider = StateNotifierProvider<CalibrationNotifier, CalibrationState>((ref) {
  return CalibrationNotifier();
});
```

---

### STEP 6: CREATE PROFILES PROVIDER

Create `lib/providers/profiles_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/trip_profile.dart';

class ProfilesState {
  final List<TripProfile> profiles;
  final TripProfile? activeProfile;

  ProfilesState({
    this.profiles = const [],
    this.activeProfile,
  });

  ProfilesState copyWith({
    List<TripProfile>? profiles,
    TripProfile? activeProfile,
  }) {
    return ProfilesState(
      profiles: profiles ?? this.profiles,
      activeProfile: activeProfile ?? this.activeProfile,
    );
  }
}

class ProfilesNotifier extends StateNotifier<ProfilesState> {
  final Box<TripProfile> _box;

  ProfilesNotifier(this._box) : super(ProfilesState()) {
    _loadProfiles();
  }

  void _loadProfiles() {
    final profiles = _box.values.toList();
    final activeId = Hive.box('settings').get('activeProfileId');
    final activeProfile = profiles.firstWhere(
      (p) => p.id == activeId,
      orElse: () => profiles.isNotEmpty ? profiles.first : null as TripProfile,
    );
    
    state = ProfilesState(
      profiles: profiles,
      activeProfile: activeProfile,
    );
  }

  Future<void> addProfile(TripProfile profile) async {
    await _box.put(profile.id, profile);
    
    final updatedProfiles = [...state.profiles, profile];
    state = state.copyWith(
      profiles: updatedProfiles,
      activeProfile: profile, // New profile becomes active
    );
    
    // Save active profile ID
    await Hive.box('settings').put('activeProfileId', profile.id);
  }

  Future<void> setActiveProfile(String id) async {
    final profile = state.profiles.firstWhere((p) => p.id == id);
    state = state.copyWith(activeProfile: profile);
    await Hive.box('settings').put('activeProfileId', id);
  }

  Future<void> deleteProfile(String id) async {
    await _box.delete(id);
    
    final updatedProfiles = state.profiles.where((p) => p.id != id).toList();
    final newActive = state.activeProfile?.id == id
        ? (updatedProfiles.isNotEmpty ? updatedProfiles.first : null)
        : state.activeProfile;
    
    state = ProfilesState(
      profiles: updatedProfiles,
      activeProfile: newActive,
    );
  }
}

// Provider
final profilesProvider = StateNotifierProvider<ProfilesNotifier, ProfilesState>((ref) {
  final box = Hive.box<TripProfile>('profiles');
  return ProfilesNotifier(box);
});
```

---

### STEP 7: CREATE REUSABLE WIDGETS

#### Widget 1: Option Card

Create `lib/widgets/option_card.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OptionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentLight : AppTheme.bgPrimary,
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            // Checkmark
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Widget 2: Budget Selector

Create `lib/widgets/budget_selector.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BudgetOption {
  final String value;
  final String emoji;
  final String label;

  BudgetOption({
    required this.value,
    required this.emoji,
    required this.label,
  });
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Column(
                  children: [
                    Text(option.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
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
```

#### Widget 3: Context Toggle

Create `lib/widgets/context_toggle.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContextToggle extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const ContextToggle({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgPrimary,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: value ? AppTheme.accent : AppTheme.bgTertiary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Widget 4: Progress Header

Create `lib/widgets/progress_header.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back Button
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.bgSecondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Progress Bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.bgTertiary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: currentStep / totalSteps,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Text
              Text(
                'Step $currentStep of $totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

#### Widget 5: Continue Button

Create `lib/widgets/continue_button.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContinueButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const ContinueButton({
    super.key,
    this.text = 'Continue',
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent : AppTheme.bgTertiary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }
}
```

---

### STEP 8: CREATE CALIBRATION SCREENS

#### Screen 1: Group Selection

Create `lib/screens/calibration/step1_group.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/calibration_provider.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/option_card.dart';
import '../../widgets/continue_button.dart';

class Step1GroupScreen extends ConsumerWidget {
  const Step1GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibration = ref.watch(calibrationProvider);
    final notifier = ref.read(calibrationProvider.notifier);

    final options = [
      {'value': 'solo', 'emoji': '🎒', 'label': 'Solo', 'desc': 'Freedom mode'},
      {'value': 'couple', 'emoji': '💑', 'label': 'Couple', 'desc': 'Romance ready'},
      {'value': 'family', 'emoji': '👨‍👩‍👧‍👦', 'label': 'Family', 'desc': 'Kid-friendly'},
      {'value': 'friends', 'emoji': '🎉', 'label': 'Friends', 'desc': 'Squad goals'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Header
              ProgressHeader(
                currentStep: 1,
                totalSteps: 5,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),

              // Question
              Text(
                'IDENTITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Who's on this trip?",
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'This shapes pace, places & pricing',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Options Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: options.map((opt) {
                    return OptionCard(
                      emoji: opt['emoji']!,
                      label: opt['label']!,
                      description: opt['desc']!,
                      isSelected: calibration.group == opt['value'],
                      onTap: () => notifier.setGroup(opt['value']!),
                    );
                  }).toList(),
                ),
              ),

              // Continue Button
              ContinueButton(
                isActive: calibration.isGroupSelected,
                onPressed: () {
                  Navigator.pushNamed(context, '/calibrate/budget');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Create similar screens for:
- `step2_budget.dart` - Use BudgetSelector widget
- `step3_location.dart` - Add TextField with suggestions
- `step4_context.dart` - Use ContextToggle widgets
- `step5_name.dart` - TextField + suggestion chips
- `processing_screen.dart` - Animated loading + save profile

---

### STEP 9: UPDATE MAIN.DART

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'models/trip_profile.dart';
import 'screens/home/home_screen.dart';
import 'screens/calibration/step1_group.dart';
import 'screens/calibration/step2_budget.dart';
import 'screens/calibration/step3_location.dart';
import 'screens/calibration/step4_context.dart';
import 'screens/calibration/step5_name.dart';
import 'screens/calibration/processing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(TripProfileAdapter());
  
  // Open boxes
  await Hive.openBox<TripProfile>('profiles');
  await Hive.openBox('settings');

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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/calibrate/group': (context) => const Step1GroupScreen(),
        '/calibrate/budget': (context) => const Step2BudgetScreen(),
        '/calibrate/location': (context) => const Step3LocationScreen(),
        '/calibrate/context': (context) => const Step4ContextScreen(),
        '/calibrate/name': (context) => const Step5NameScreen(),
        '/calibrate/processing': (context) => const ProcessingScreen(),
      },
    );
  }
}
```

---

### STEP 10: ADD DEPENDENCIES

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Code Generation (for Hive)
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  
  # HTTP (for Weather API)
  http: ^1.1.0
  
  # Location
  geolocator: ^10.1.0
  geocoding: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  hive_generator: ^2.0.1

# Add Inter font
fonts:
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter-Regular.ttf
        weight: 400
      - asset: assets/fonts/Inter-Medium.ttf
        weight: 500
      - asset: assets/fonts/Inter-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/Inter-Bold.ttf
        weight: 700
```

---

## 📋 CHECKLIST FOR DEVELOPER

### Week 1: Setup
- [ ] Delete old files listed above
- [ ] Create new folder structure
- [ ] Create `app_theme.dart`
- [ ] Create `trip_profile.dart` model
- [ ] Run `flutter pub run build_runner build`
- [ ] Create providers (calibration, profiles)

### Week 2: Widgets
- [ ] Create `option_card.dart`
- [ ] Create `budget_selector.dart`
- [ ] Create `context_toggle.dart`
- [ ] Create `progress_header.dart`
- [ ] Create `continue_button.dart`
- [ ] Test each widget in isolation

### Week 3: Calibration Screens
- [ ] Create Step 1 (Group)
- [ ] Create Step 2 (Budget)
- [ ] Create Step 3 (Location)
- [ ] Create Step 4 (Context)
- [ ] Create Step 5 (Name)
- [ ] Create Processing screen
- [ ] Test full flow

### Week 4: Home Screen
- [ ] Create HomeScreen layout
- [ ] Create WeatherBanner widget
- [ ] Create ActiveTripCard widget
- [ ] Create ProfileCard widget
- [ ] Create horizontal profile scroll
- [ ] Connect to providers

### Week 5: Polish
- [ ] Add page transitions
- [ ] Add Weather API
- [ ] Add GPS functionality
- [ ] Test on multiple devices
- [ ] Fix bugs

---

## ⚠️ IMPORTANT NOTES

1. **DON'T skip the theme file** - Use `AppTheme.accent` everywhere, not `Colors.blue`

2. **DON'T use setState** - Use Riverpod for all state management

3. **DON'T hardcode strings** - Create constants or enums

4. **DO test each widget** before building screens

5. **DO match the HTML demo exactly** - Open it side by side while coding

6. **DO ask questions** if something is unclear

---

## Questions?

If stuck, share:
1. Which step you're on
2. The error message (if any)
3. Screenshot of what you see vs what it should look like

Good luck! 🚀
