import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../profile/profile_page.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data - NO email or full name
  String? _travelStyle;
  final List<String> _selectedInterests = [];

  final List<String> _interestOptions = [
    'Adventure',
    'Culture',
    'Food',
    'Nature',
    'Nightlife',
    'Relaxation',
    'Shopping',
    'Sports',
  ];

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    final userBox = Hive.box('user_data');
    userBox.put('travelStyle', _travelStyle);
    userBox.put('interests', _selectedInterests);
    userBox.put('profile_completed', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentPage + 1) / 2,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildTravelStylePage(),
                  _buildInterestsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelStylePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.flight_takeoff, size: 80, color: Colors.indigo),
          const SizedBox(height: 32),
          const Text(
            'How do you travel?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose one option',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ...[
            {'icon': Icons.person, 'label': 'Solo', 'value': 'Solo'},
            {'icon': Icons.family_restroom, 'label': 'With Family', 'value': 'With Family'},
            {'icon': Icons.group, 'label': 'With Friends', 'value': 'With Friends'},
            {'icon': Icons.groups, 'label': 'Group Tours', 'value': 'Group Tours'},
          ].map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _travelStyle = option['value'] as String;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _travelStyle == option['value'] 
                            ? Colors.indigo 
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: _travelStyle == option['value']
                          ? Colors.indigo.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          color: _travelStyle == option['value']
                              ? Colors.indigo
                              : Colors.grey,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          option['label'] as String,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: _travelStyle == option['value']
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _travelStyle == option['value']
                                ? Colors.indigo
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _travelStyle != null ? _nextPage : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Interests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Select all that apply', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: _interestOptions.length,
              itemBuilder: (context, index) {
                final interest = _interestOptions[index];
                final isSelected = _selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                  },
                  selectedColor: Colors.indigo,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: _previousPage,
                child: const Text('Back'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedInterests.isNotEmpty ? _completeOnboarding : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Complete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
