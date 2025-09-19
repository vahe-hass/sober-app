import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryEntry {
  int days;
  String? endedAt; // ISO string
  String note;

  HistoryEntry({required this.days, this.endedAt, this.note = ''});

  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
        days: (j['days'] is int)
            ? j['days'] as int
            : int.tryParse('${j['days']}') ?? 0,
        endedAt: j['endedAt'] as String?,
        note: j['note'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'days': days,
        if (endedAt != null) 'endedAt': endedAt,
        'note': note,
      };
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry> _history = [];
  bool _isLoading = true;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _loadStreaks();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadStreaks() async {
    _isLoading = true;
    if (mounted) setState(() {});

    final prefs = await SharedPreferences.getInstance();
    final keysToCheck = ['previousStreaks', 'resetHistory', 'sobrietyHistory'];

    final Set<String> rawSet = <String>{};
    for (final key in keysToCheck) {
      final List<String>? list = prefs.getStringList(key);
      if (list != null) rawSet.addAll(list);
    }

    final List<HistoryEntry> parsed = [];
    for (final item in rawSet) {
      if (item.trim().isEmpty) continue;

      try {
        final decoded = json.decode(item);
        if (decoded is Map<String, dynamic>) {
          parsed.add(HistoryEntry.fromJson(decoded));
          continue;
        }
        if (decoded is int) {
          parsed.add(HistoryEntry(days: decoded, endedAt: null, note: ''));
          continue;
        }
      } catch (_) {}

      final n = int.tryParse(item);
      if (n != null && n > 0) {
        parsed.add(HistoryEntry(days: n, endedAt: null, note: ''));
      }
    }

    for (final c in _controllers) c.dispose();
    _controllers.clear();
    for (final e in parsed) {
      _controllers.add(TextEditingController(text: e.note));
    }

    if (!mounted) return;
    setState(() {
      _history = parsed;
      _isLoading = false;
    });
  }

  Future<void> _saveHistoryToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded =
        _history.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('previousStreaks', encoded);
  }

  Future<void> _saveNoteForIndex(int index) async {
    if (index < 0 || index >= _history.length) return;
    final note = _controllers[index].text.trim();
    setState(() {
      _history[index].note = note;
    });
    await _saveHistoryToPrefs();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved')),
      );
    }
  }

  Future<void> _onRefresh() async {
    await _loadStreaks();
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Great job! No past sobriety streaks.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobriety History"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _history.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final entry = _history[index];
                  final controller = _controllers[index];
                  final String endedText = entry.endedAt != null
                      ? 'Ended: ${DateTime.tryParse(entry.endedAt!)?.toLocal().toString().split('.').first ?? entry.endedAt}'
                      : '';

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.history, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Streak: ${entry.days - 1} days",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (endedText.isNotEmpty)
                                      Text(
                                        endedText,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    Text(
                                      "Attempt ${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: 'Write a note about this attempt...',
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5, color: Color(0xFFa3c7e8)), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: Color(0xFFa8e6cf)), // Border color when focused
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => controller.clear(),
                                child: const Text('Clear',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _saveNoteForIndex(index),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                ),
                                child: const Text('Save',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
