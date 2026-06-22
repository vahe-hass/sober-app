import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, String>> moods = [
    {'emoji': '😞', 'title': 'Difficult Day'},
    {'emoji': '😐', 'title': 'Average Day'},
    {'emoji': '🙂', 'title': 'Good Day'},
    {'emoji': '⚡', 'title': 'Active Day'},
    {'emoji': '🔥', 'title': 'Amazing Day'},
  ];

  String selectedMood = '';

  bool alreadyCheckedToday = false;

  Map<String, int> stats = {
    'Difficult Day': 0,
    'Average Day': 0,
    'Good Day': 0,
    'Active Day': 0,
    'Amazing Day': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _today() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> entries =
        prefs.getStringList('dailyCheckIns') ?? [];

    alreadyCheckedToday = false;

    stats.updateAll((key, value) => 0);

    for (String item in entries) {
      Map<String, dynamic> entry = jsonDecode(item);

      if (entry['date'] == _today()) {
        alreadyCheckedToday = true;
      }

      String mood = entry['mood'];

      if (stats.containsKey(mood)) {
        stats[mood] = stats[mood]! + 1;
      }
    }

    setState(() {});
  }

  Future<void> _saveToday() async {
    if (selectedMood.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    List<String> entries =
        prefs.getStringList('dailyCheckIns') ?? [];

    if (alreadyCheckedToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You already completed today\'s check-in.',
          ),
        ),
      );

      return;
    }

    Map<String, dynamic> entry = {
      'date': _today(),
      'mood': selectedMood,
      'note': _noteController.text.trim(),
    };

    entries.add(jsonEncode(entry));

    await prefs.setStringList(
      'dailyCheckIns',
      entries,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Today saved successfully.'),
      ),
    );

    selectedMood = '';
    _noteController.clear();

    await _loadData();
  }

  Widget _buildStat(String title, String emoji) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 5),
        Text(
          '${stats[title]}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-In'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          const Text(
            'How was today?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,

            children: [
              _buildStat('Difficult Day', '😞'),
              _buildStat('Average Day', '😐'),
              _buildStat('Good Day', '🙂'),
              _buildStat('Active Day', '⚡'),
              _buildStat('Amazing Day', '🔥'),
            ],
          ),

          const SizedBox(height: 35),

          ...moods.map((mood) {
            bool selected =
                selectedMood == mood['title'];

            return Card(
              color: selected
                  ? const Color(0xFFa3c7e8)
                  : Colors.white,

              child: ListTile(
                leading: Text(
                  mood['emoji']!,
                  style:
                  const TextStyle(fontSize: 28),
                ),

                title: Text(
                  mood['title']!,
                ),

                onTap: () {
                  setState(() {
                    selectedMood = mood['title']!;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 30),

          TextField(
            controller: _noteController,

            maxLines: 3,

            decoration: const InputDecoration(
              labelText: 'Optional Note',

              hintText:
              'What made today difficult or successful?',

              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed:
            alreadyCheckedToday ? null : _saveToday,

            child: Text(
              alreadyCheckedToday
                  ? 'CHECK-IN COMPLETED'
                  : 'SAVE TODAY',
            ),
          ),
        ],
      ),
    );
  }
}