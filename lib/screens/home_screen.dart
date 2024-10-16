import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  DateTime? sobrietyStartDate;
  int soberDays = 0;

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
        appBar: AppBar(
          title: Text("Welcome!"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            // add container
          ),
          Container(
            // date container to show date
          ),
          Container(
            // space for adding quotes
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dash' ),
        ],
      ),
    );
  }
}
