import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool get isGroupSelected => group != null;
  bool get isBudgetSelected => budget != null;
  bool get isLocationSelected => location != null;
  bool get isNameEntered => name != null && name!.isNotEmpty;
}

class CalibrationNotifier extends StateNotifier<CalibrationState> {
  CalibrationNotifier() : super(CalibrationState());

  void setGroup(String group) => state = state.copyWith(group: group);
  void setBudget(String budget) => state = state.copyWith(budget: budget);
  void setLocation(String location, String country) => 
      state = state.copyWith(location: location, country: country);
  void setWeatherFilter(bool value) => state = state.copyWith(weatherFilter: value);
  void setTimeAwareness(bool value) => state = state.copyWith(timeAwareness: value);
  void setCrowdAvoidance(bool value) => state = state.copyWith(crowdAvoidance: value);
  void setLiveAvailability(bool value) => state = state.copyWith(liveAvailability: value);
  void setName(String name) => state = state.copyWith(name: name);
  void reset() => state = CalibrationState();
}

final calibrationProvider = StateNotifierProvider<CalibrationNotifier, CalibrationState>((ref) {
  return CalibrationNotifier();
});
