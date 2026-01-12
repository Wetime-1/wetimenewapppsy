class Trip {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String travelType; // Solo, Family, Friends, etc.
  final String budget;
  final List<String> interests;

  Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelType,
    required this.budget,
    required this.interests,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'destination': destination,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'travelType': travelType,
    'budget': budget,
    'interests': interests,
  };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json['id'],
    destination: json['destination'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    travelType: json['travelType'],
    budget: json['budget'],
    interests: List<String>.from(json['interests']),
  );
}

class UserProfile {
  final String name;
  final String email;
  final String preferredTravelStyle;
  final List<String> interests;
  final String budgetRange;

  UserProfile({
    required this.name,
    required this.email,
    required this.preferredTravelStyle,
    required this.interests,
    required this.budgetRange,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'preferredTravelStyle': preferredTravelStyle,
    'interests': interests,
    'budgetRange': budgetRange,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'],
    email: json['email'],
    preferredTravelStyle: json['preferredTravelStyle'],
    interests: List<String>.from(json['interests']),
    budgetRange: json['budgetRange'],
  );
}
