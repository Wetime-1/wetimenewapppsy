class TripProfile {
  final String id;
  final String group; // solo, couple, family, friends
  final String budget; // budget, mid, premium, luxury
  final String location;
  final String country;
  final String name;
  final String icon;
  final bool weatherFilter;
  final bool timeAwareness;
  final bool crowdAvoidance;
  final bool liveAvailability;
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

  static String getIconForGroup(String group) {
    switch (group) {
      case 'solo': return '🎒';
      case 'couple': return '💑';
      case 'family': return '👨‍👩‍👧‍👦';
      case 'friends': return '🎉';
      default: return '✈️';
    }
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group': group,
      'budget': budget,
      'location': location,
      'country': country,
      'name': name,
      'icon': icon,
      'weatherFilter': weatherFilter,
      'timeAwareness': timeAwareness,
      'crowdAvoidance': crowdAvoidance,
      'liveAvailability': liveAvailability,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TripProfile.fromJson(Map<String, dynamic> json) {
    return TripProfile(
      id: json['id'],
      group: json['group'],
      budget: json['budget'],
      location: json['location'],
      country: json['country'],
      name: json['name'],
      icon: json['icon'],
      weatherFilter: json['weatherFilter'] ?? true,
      timeAwareness: json['timeAwareness'] ?? true,
      crowdAvoidance: json['crowdAvoidance'] ?? false,
      liveAvailability: json['liveAvailability'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
