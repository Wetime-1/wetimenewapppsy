import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/models/video_model.dart';
import 'dart:convert';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBox = Hive.box('user_data');
    final tripsBox = Hive.box('trips');
    
    final name = userBox.get('name', defaultValue: 'Traveler');
    final email = userBox.get('email', defaultValue: '');
    final travelStyle = userBox.get('travelStyle', defaultValue: 'Solo');
    final interests = List<String>.from(userBox.get('interests', defaultValue: []));
    final budgetRange = userBox.get('budgetRange', defaultValue: 'Not set');
    
    final tripsList = tripsBox.values.map((e) {
      return Trip.fromJson(Map<String, dynamic>.from(json.decode(e)));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userBox.clear();
              tripsBox.clear();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.indigo,
                        child: Text(
                          name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildInfoRow(Icons.groups, 'Travel Style', travelStyle),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.attach_money, 'Budget', budgetRange),
                  const SizedBox(height: 16),
                  const Text(
                    'Interests',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: interests.map((interest) => Chip(
                      label: Text(interest),
                      backgroundColor: Colors.indigo[50],
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Trips Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Trips',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddTripDialog(context, tripsBox),
                icon: const Icon(Icons.add),
                label: const Text('Add Trip'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Trips List
          if (tripsList.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.luggage, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No trips yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap "Add Trip" to start planning',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ...tripsList.map((trip) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.place, color: Colors.white),
                ),
                title: Text(
                  trip.destination,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${_formatDate(trip.startDate)} - ${_formatDate(trip.endDate)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    tripsBox.delete(trip.id);
                  },
                ),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.indigo),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(value),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddTripDialog(BuildContext context, Box tripsBox) {
    final destinationController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    String? travelType;
    String? budget;
    final selectedInterests = <String>[];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Trip'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(startDate?.toString().split(' ')[0] ?? 'Not selected'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => startDate = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('End Date'),
                  subtitle: Text(endDate?.toString().split(' ')[0] ?? 'Not selected'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => endDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Travel Type',
                    border: OutlineInputBorder(),
                  ),
                  value: travelType,
                  items: ['Solo', 'Family', 'Friends', 'Group'].map((type) => 
                    DropdownMenuItem(value: type, child: Text(type))
                  ).toList(),
                  onChanged: (value) => setState(() => travelType = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Budget',
                    border: OutlineInputBorder(),
                  ),
                  value: budget,
                  items: ['Budget', 'Mid-range', 'Luxury'].map((b) => 
                    DropdownMenuItem(value: b, child: Text(b))
                  ).toList(),
                  onChanged: (value) => setState(() => budget = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (destinationController.text.isNotEmpty &&
                    startDate != null &&
                    endDate != null &&
                    travelType != null &&
                    budget != null) {
                  final trip = Trip(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    destination: destinationController.text,
                    startDate: startDate!,
                    endDate: endDate!,
                    travelType: travelType!,
                    budget: budget!,
                    interests: selectedInterests,
                  );
                  tripsBox.put(trip.id, json.encode(trip.toJson()));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
