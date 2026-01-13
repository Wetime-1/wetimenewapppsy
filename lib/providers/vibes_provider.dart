import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class VibesState {
  final int balance;
  final List<VibeTransaction> history;

  VibesState({this.balance = 0, this.history = const []});

  VibesState copyWith({
    int? balance,
    List<VibeTransaction>? history,
  }) {
    return VibesState(
      balance: balance ?? this.balance,
      history: history ?? this.history,
    );
  }
}

class VibeTransaction {
  final String id;
  final int amount;
  final String reason;
  final DateTime timestamp;

  VibeTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'reason': reason,
    'timestamp': timestamp.toIso8601String(),
  };

  factory VibeTransaction.fromJson(Map<String, dynamic> json) => VibeTransaction(
    id: json['id'],
    amount: json['amount'],
    reason: json['reason'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class VibesNotifier extends StateNotifier<VibesState> {
  VibesNotifier() : super(VibesState()) {
    _loadVibes();
  }

  void _loadVibes() {
    final box = Hive.box('user_data');
    final balance = box.get('vibesBalance', defaultValue: 0);
    state = state.copyWith(balance: balance);
  }

  Future<void> earnVibes(int amount, String reason) async {
    final newBalance = state.balance + amount;
    final transaction = VibeTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      reason: reason,
      timestamp: DateTime.now(),
    );
    
    final box = Hive.box('user_data');
    await box.put('vibesBalance', newBalance);
    
    state = state.copyWith(
      balance: newBalance,
      history: [...state.history, transaction],
    );
  }

  Future<void> spendVibes(int amount, String reason) async {
    if (state.balance < amount) return;
    
    final newBalance = state.balance - amount;
    final transaction = VibeTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: -amount,
      reason: reason,
      timestamp: DateTime.now(),
    );
    
    final box = Hive.box('user_data');
    await box.put('vibesBalance', newBalance);
    
    state = state.copyWith(
      balance: newBalance,
      history: [...state.history, transaction],
    );
  }
}

final vibesProvider = StateNotifierProvider<VibesNotifier, VibesState>((ref) {
  return VibesNotifier();
});
