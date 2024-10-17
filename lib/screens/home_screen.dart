import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  DateTime? sobrietyStartDate;
  int soberDays = 0;
  int _currentIndex = 0;  // To keep track of the selected bottom nav item

  // Screens for the bottom navigation items
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        soberDays = DateTime.now().difference(date).inDays;
        _setUpScreens();  // Initialize the screens after loading data
      });
    }
  }

  // Set up the screens after the user data has been loaded
  void _setUpScreens() {
    _screens.add(
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              height: 80,
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              clipBehavior: Clip.hardEdge,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).hintColor,
                    padding: EdgeInsets.all(10.0),
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
                    child: Center(
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
                        child: Icon(Icons.format_quote_rounded, size: 80),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Text(
                      'Strength doesn’t come from what you can do, but from overcoming the things you thought you couldn’t.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
    );
    _screens.add(DashboardScreen());  // Add dashboard screen
  }

  @override
  Widget build(BuildContext context) {
    // If user data is not loaded yet
    if (userName.isEmpty || sobrietyStartDate == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],  // Switches between Home and Dashboard based on the index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,  // Tracks the current index
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Change screen based on tap
          });
        },
        selectedItemColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dash'),
        ],
      ),
      bottomSheet: Container(
        height: 1,
        color: Color(0xFFa3c7e8),  // Custom divider color
      ),
    );
  }
}
