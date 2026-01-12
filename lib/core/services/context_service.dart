import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContextState {
  final bool isRaining;
  final bool isNight;
  final bool isCrowded;

  ContextState({
    required this.isRaining,
    required this.isNight,
    required this.isCrowded,
  });

  @override
  String toString() => 'Raining: $isRaining, Night: $isNight, Crowded: $isCrowded';
}

class ContextService {
  // Simulate fetching sensors
  Future<ContextState> getCurrentContext() async {
    // In a real app, this would use Geolocator and Weather API
    // For now, we mock "Rainy Night" to test our algo
    await Future.delayed(const Duration(milliseconds: 500)); 
    return ContextState(
      isRaining: true,
      isNight: true,
      isCrowded: false,
    );
  }
}

final contextServiceProvider = Provider((ref) => ContextService());

final currentContextProvider = FutureProvider<ContextState>((ref) async {
  final service = ref.read(contextServiceProvider);
  return service.getCurrentContext();
});
