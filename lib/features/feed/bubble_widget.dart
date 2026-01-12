import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/profile_service.dart';

class ContextBubble extends ConsumerStatefulWidget {
  const ContextBubble({super.key});

  @override
  ConsumerState<ContextBubble> createState() => _ContextBubbleState();
}

class _ContextBubbleState extends ConsumerState<ContextBubble> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // "One-Tap" Adjustment: Show after 5 seconds of engagement
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  void _handleSelection(bool isSolo) {
    ref.read(profileProvider.notifier).setTravelGroup(isSolo: isSolo);
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If already answered (null check), don't show, unless we want to allow re-selection
    // For now, only show if null.
    final currentPref = ref.watch(profileProvider).isSolo;
    if (currentPref != null) return const SizedBox.shrink();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      bottom: _isVisible ? 120 : -100, // Slide up from bottom
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Traveling?", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _handleSelection(true),
                child: const Chip(
                  label: Text("Solo 🧍"),
                  backgroundColor: Colors.blueAccent,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _handleSelection(false),
                child: const Chip(
                  label: Text("Group 👨‍👩‍👧‍👦"),
                  backgroundColor: Colors.purpleAccent,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
