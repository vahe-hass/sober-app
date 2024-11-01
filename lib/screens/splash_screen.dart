import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf2f2f2),
        centerTitle: true,
        title: SizedBox(
          width: 80.0,
          child: Image.asset('assets/images/navigation_start1.png'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.0,
              height: 250.0,
              child: Image.asset('assets/images/logo_Vertical.png'),
            ),
            const SizedBox(height: 80),
            const Text(
              'Welcome to Sober Journey',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ).animate().shake(duration: 800.ms, delay: 800.ms),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: const Text(
                'Your journey to a healthier, stronger you starts today. We’re here to support you every step of the way—one day at a time. Track your progress, celebrate your wins, and stay motivated as you take control of your life.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Noto-Sans',
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/form');
              },
              child: const Text(
                'GET STARTED',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
