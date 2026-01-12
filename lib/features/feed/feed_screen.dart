import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/context_service.dart';
import '../../core/models/video_model.dart';
import '../../core/services/profile_service.dart';
import 'video_item.dart';
import 'bubble_widget.dart';
import '../profile/profile_summary.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextProvider);
    final userProfile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Video Feed
          contextAsync.when(
            data: (contextState) {
              // Context-Aware Filtering Logic
              final filteredVideos = mockVideos.where((video) {
                // If raining, hide strictly outdoor activities unless they have 'rain' tag
                if (contextState.isRaining &&
                    video.tags.contains('outdoor') &&
                    !video.tags.contains('rain')) {
                  return false;
                }
                // If night, hide strictly day activities
                if (contextState.isNight && video.tags.contains('day')) {
                  return false;
                }
                return true;
              }).toList();

              if (filteredVideos.isEmpty) {
                return const Center(child: Text("No gems found nearby...", style: TextStyle(color: Colors.white)));
              }

              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filteredVideos.length,
                onPageChanged: (index) {
                  // Silent Learning: User swiped to a new video
                  // Logic: If they spent time on previous, increase that vibe.
                  // For simplicity: Just log "Viewed" for now.
                  final video = filteredVideos[index];
                  // If it's the first swipe, maybe give a token
                  if (index > 0) ref.read(profileProvider.notifier).addTokens(1);
                },
                itemBuilder: (context, index) {
                  return VideoItem(video: filteredVideos[index]);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
          ),

          // 2. The "One-Tap" Adjustment Bubble
          const ContextBubble(),

          // 3. Top Bar (Profile / Tokens)
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
               onTap: () {
                 // Open Profile Modal
                 showModalBottomSheet(
                   context: context, 
                   backgroundColor: Colors.transparent,
                   builder: (_) => const ProfileSummary()
                 );
               },
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                 decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.5),
                   borderRadius: BorderRadius.circular(20),
                   border: Border.all(color: Colors.yellowAccent.withOpacity(0.5)),
                 ),
                 child: Row(
                   children: [
                     const Icon(Icons.wallet, color: Colors.yellowAccent, size: 16),
                     const SizedBox(width: 8),
                     Text(
                       "${userProfile.tokens} Tokens",
                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),
            ),
          ),
          
          // Debug Info (Remove in prod)
          Positioned(
             top: 50,
             left: 20,
             child: contextAsync.maybeWhen(
               data: (c) => Text(
                 "🌧️ ${c.isRaining ? 'Rain' : 'Clear'} | 🌙 ${c.isNight ? 'Night' : 'Day'}",
                 style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
               ),
               orElse: () => const SizedBox.shrink(),
             ),
          ),
        ],
      ),
    );
  }
}
