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
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Column(
      children: [
        SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
          ),
        ),
        SizedBox(height: 20),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.amber,
                padding: EdgeInsets.all(10.0),
                child: const Text(
                  'DAY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Container(
                child: Text(
                  '$soberDays',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(),
      ],
    ),
    DashboardScreen(), // Second screen (dashboard)
  ];

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
      });
    }
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
      body: _screens[
      _currentIndex], // Switches between Home and Dashboard based on the index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Tracks the current index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change screen based on tap
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
        color: Theme.of(context).primaryColor, // Custom divider color
      ),
    );
  }
}
