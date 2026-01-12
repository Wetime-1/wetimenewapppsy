import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final bool? isSolo;
  final int tokens;
  final Map<String, int> vibeScores;
  final int explorerLevel;

  UserProfile({
    this.isSolo,
    this.tokens = 0,
    this.vibeScores = const {},
    this.explorerLevel = 1,
  });

  UserProfile copyWith({
    bool? isSolo,
    int? tokens,
    Map<String, int>? vibeScores,
    int? explorerLevel,
  }) {
    return UserProfile(
      isSolo: isSolo ?? this.isSolo,
      tokens: tokens ?? this.tokens,
      vibeScores: vibeScores ?? this.vibeScores,
      explorerLevel: explorerLevel ?? this.explorerLevel,
    );
  }
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile());

  void setTravelGroup({required bool isSolo}) {
    state = state.copyWith(isSolo: isSolo);
    // Reward for answering
    addTokens(10);
  }

  void addTokens(int amount) {
    state = state.copyWith(tokens: state.tokens + amount);
  }

  void updateVibe(String tag, int change) {
    final newScores = Map<String, int>.from(state.vibeScores);
    newScores[tag] = (newScores[tag] ?? 0) + change;
    state = state.copyWith(vibeScores: newScores);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
