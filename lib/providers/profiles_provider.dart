import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/trip_profile.dart';
import 'dart:convert';

class ProfilesState {
  final List<TripProfile> profiles;
  final TripProfile? activeProfile;

  ProfilesState({this.profiles = const [], this.activeProfile});

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
  ProfilesNotifier() : super(ProfilesState()) {
    _loadProfiles();
  }

  void _loadProfiles() {
    final box = Hive.box('user_data');
    final profilesJson = box.get('profiles', defaultValue: '[]');
    final activeId = box.get('activeProfileId');
    
    final List<dynamic> decoded = json.decode(profilesJson);
    final profiles = decoded.map((json) => TripProfile.fromJson(json)).toList();
    
    final activeProfile = profiles.isEmpty ? null :
        (activeId != null ? profiles.firstWhere((p) => p.id == activeId, orElse: () => profiles.first) : profiles.first);
    
    state = ProfilesState(profiles: profiles, activeProfile: activeProfile);
  }

  Future<void> addProfile(TripProfile profile) async {
    final updatedProfiles = [...state.profiles, profile];
    await _saveProfiles(updatedProfiles);
    
    final box = Hive.box('user_data');
    await box.put('activeProfileId', profile.id);
    
    state = state.copyWith(profiles: updatedProfiles, activeProfile: profile);
  }

  Future<void> setActiveProfile(String id) async {
    final profile = state.profiles.firstWhere((p) => p.id == id);
    await Hive.box('user_data').put('activeProfileId', id);
    state = state.copyWith(activeProfile: profile);
  }

  Future<void> deleteProfile(String id) async {
    final updatedProfiles = state.profiles.where((p) => p.id != id).toList();
    await _saveProfiles(updatedProfiles);
    
    final newActive = updatedProfiles.isEmpty ? null :
        (state.activeProfile?.id == id ? updatedProfiles.first : state.activeProfile);
    
    if (newActive != null) {
      await Hive.box('user_data').put('activeProfileId', newActive.id);
    }
    
    state = state.copyWith(profiles: updatedProfiles, activeProfile: newActive);
  }

  Future<void> _saveProfiles(List<TripProfile> profiles) async {
    final encoded = json.encode(profiles.map((p) => p.toJson()).toList());
    await Hive.box('user_data').put('profiles', encoded);
  }
}

final profilesProvider = StateNotifierProvider<ProfilesNotifier, ProfilesState>((ref) {
  return ProfilesNotifier();
});
