import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:math';

import 'dashboard_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  DateTime? sobrietyStartDate;
  int soberDays = 0;
  int _currentIndex = 0;

  // Screens for the bottom navigation items
  final List<Widget> _screens = [];
  String dailyQuote = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setDailyQuote();
  }

  // Function to load user data from local storage
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('userName');
    String? dateString = prefs.getString('sobrietyDate');

    if (name != null && dateString != null) {
      DateTime date = DateTime.parse(dateString);
      setState(() {
        userName = name;
        sobrietyStartDate = date;
        soberDays = DateTime.now().difference(date).inDays + 1;
      });
    }
  }

  Future<Map<String, dynamic>> _loadQuotes() async {
    final jsonString =
        await rootBundle.rootBundle.loadString('assets/quotes.json');
    return jsonDecode(jsonString);
  }

  Future<String> _getQuote() async {
    Map<String, dynamic> quotes = await _loadQuotes();
    Random random = Random();
    int randomNumber = random.nextInt(312);
    List<String> quoteList = List<String>.from(quotes['quotes']);
    return quoteList[randomNumber];
  }

  Future<void> _setDailyQuote() async {
    String quote = await _getQuote();
    setState(() {
      dailyQuote = quote;
      _setUpScreens(); // Initialize the screens after loading data
    });
  }

  // Reset sobriety counter and save streak to history
  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();

    if (sobrietyStartDate != null) {
      final int streak = DateTime.now().difference(sobrietyStartDate!).inDays + 1;
      final Map<String, dynamic> entry = {
        'days': streak,
        'endedAt': DateTime.now().toIso8601String(),
        'note': ''
      };

      final List<String> list = prefs.getStringList('previousStreaks') ?? [];
      list.add(json.encode(entry));
      await prefs.setStringList('previousStreaks', list);
    }

    // Normalize to date only
    DateTime dateOnly(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day);
    }

    // Reset counter
    DateTime now = DateTime.now();
    DateTime adjustednow = dateOnly(now);
    await prefs.setString('sobrietyDate', adjustednow.toIso8601String());

    setState(() {
      sobrietyStartDate = adjustednow;
      soberDays = DateTime.now().difference(adjustednow).inDays + 1;
      _currentIndex = 0;
    });
  }

  // Set up the screens after the user data has been loaded
  void _setUpScreens() {
    _screens.clear();
    _screens.add(
      LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 46),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Theme.of(context).hintColor,
                            padding: const EdgeInsets.all(10.0),
                            child: const Text(
                              'DAY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 250,
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '$soberDays',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 112,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Transform.flip(
                                flipX: true,
                                flipY: true,
                                child: const Icon(Icons.format_quote_rounded,
                                    size: 80),
                              ),
                            ],
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              dailyQuote,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.format_quote_rounded, size: 80),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    _screens.add(const DashboardScreen());
    _screens.add(const HistoryScreen());
    _screens.add(Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'Great job! Your journey is still strong. Keep building your streak.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'When you reset your sobriety date, your current streak will be safely saved in your history as a reminder of your progress. Then, you’ll get a fresh start from Day One. Another chance to grow stronger.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Noto-Sans",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _resetCounter,
            child: const Text(
              "Restart Journey",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (userName.isEmpty || sobrietyStartDate == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dailyQuote.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Sobriety'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Achievements'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Reset'),
        ],
      ),
      bottomSheet: Container(
        height: 1,
        color: const Color(0xFFa3c7e8),
      ),
    );
  }
}
