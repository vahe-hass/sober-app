import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sober_journey/theme/sober_main_theme.dart';
import 'package:sober_journey/widgets/noti.dart';
import 'screens/home_screen.dart';
import 'screens/user_form_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await LocalNotifications.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _checkUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if user data (name and startDate) is stored in SharedPreferences
    bool hasName = prefs.containsKey('userName');
    bool hasStartDate = prefs.containsKey('sobrietyDate');
    return hasName && hasStartDate;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sober Journey',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: _checkUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading spinner while checking data
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  // If user data is found, show HomeScreen directly
                  return const HomeScreen();
                } else {
                  // If no user data is found, show the SplashScreen first
                  return const SplashScreen();
                }
              },
            ),
        '/home': (context) => const HomeScreen(),
        '/form': (context) => const UserFormScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
