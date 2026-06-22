import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodJournalScreen extends StatefulWidget {
  const MoodJournalScreen({super.key});

  @override
  State<MoodJournalScreen> createState() => _MoodJournalScreenState();
}

class _MoodJournalScreenState extends State<MoodJournalScreen> {
  List<Map<String, dynamic>> journal = [];

  bool isLoading = true;

  int expandedIndex = -1;

  String? journalPin;

  final Map<String, String> moodEmojis = {
    'Difficult Day': '😞',
    'Average Day': '😐',
    'Good Day': '🙂',
    'Active Day': '⚡',
    'Amazing Day': '🔥',
  };

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await _loadJournal();

    if (mounted) {
      await _setupPin();
    }
  }

  Future<void> _loadJournal() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> entries =
        prefs.getStringList('dailyCheckIns') ?? [];

    journal = [];

    for (String item in entries) {
      journal.add(jsonDecode(item));
    }

    journal = journal.reversed.toList();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _setupPin() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('journalPin')) {
      journalPin = prefs.getString('journalPin');

      return;
    }

    final controller = TextEditingController();

    await showDialog(
      context: context,

      barrierDismissible: false,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Create Journal PIN',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Text(
                'This PIN cannot be recovered.\nDo not forget it.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,

                keyboardType:
                TextInputType.number,

                obscureText: true,

                maxLength: 4,

                decoration: const InputDecoration(
                  hintText: '4-digit PIN',
                ),
              ),
            ],
          ),

          actions: [
            ElevatedButton(
              onPressed: () async {

                if (controller.text.length != 4) {
                  return;
                }

                await prefs.setString(
                  'journalPin',
                  controller.text,
                );

                journalPin =
                    controller.text;

                if (mounted) {
                  Navigator.pop(context);
                }
              },

              child: const Text(
                'SAVE',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _unlockCard(
      int index,
      ) async {

    final controller =
    TextEditingController();

    await showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Unlock Journal',
          ),

          content: TextField(
            controller: controller,

            keyboardType:
            TextInputType.number,

            obscureText: true,

            decoration:
            const InputDecoration(
              hintText:
              'Enter 4-digit PIN',
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {

                if (controller.text ==
                    journalPin) {

                  setState(() {

                    if (expandedIndex ==
                        index) {

                      expandedIndex = -1;

                    } else {

                      expandedIndex = index;
                    }
                  });

                  Navigator.pop(context);

                } else {

                  Navigator.pop(context);

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Incorrect PIN',
                      ),
                    ),
                  );
                }
              },

              child: const Text(
                'Unlock',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mood Journal',
        ),
      ),

      body: journal.isEmpty

          ? const Center(
        child: Text(
          'No check-ins yet.',

          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )

          : ListView.builder(
        padding:
        const EdgeInsets.all(
          16,
        ),

        itemCount:
        journal.length,

        itemBuilder:
            (context, index) {

          final entry =
          journal[index];

          final mood =
          entry['mood'];

          final note =
              entry['note'] ??
                  '';

          final date =
          entry['date'];

          final isExpanded =
              expandedIndex ==
                  index;

          return Card(
            margin:
            const EdgeInsets
                .only(
              bottom: 15,
            ),

            child: InkWell(

              onTap: () {

                _unlockCard(
                  index,
                );
              },

              child: Padding(
                padding:
                const EdgeInsets
                    .all(
                  16,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Row(
                      children: [

                        Text(
                          moodEmojis[
                          mood] ??
                              '❤️',

                          style:
                          const TextStyle(
                            fontSize:
                            28,
                          ),
                        ),

                        const SizedBox(
                          width:
                          10,
                        ),

                        Expanded(
                          child:
                          Text(
                            mood,

                            style:
                            const TextStyle(
                              fontSize:
                              18,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),

                        Icon(
                          isExpanded

                              ? Icons
                              .expand_less

                              : Icons
                              .expand_more,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      date,

                      style:
                      const TextStyle(
                        color:
                        Colors.grey,
                      ),
                    ),

                    if (isExpanded)
                      ...[

                        const SizedBox(
                          height:
                          20,
                        ),

                        Text(
                          note
                              .isEmpty

                              ? 'No note'

                              : note,

                          style:
                          const TextStyle(
                            fontSize:
                            16,
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}