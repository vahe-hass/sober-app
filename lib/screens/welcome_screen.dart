import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: SizedBox(
          width: 80.0,
          child: Image.asset('assets/images/main_txt_logo.png'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFa3c7e8)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/form');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            height: 5,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFa3c7e8),
                  width: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 260,
            height: 220,
            child: Image.asset(
                'assets/images/sober_handshake.png',
            ).animate().fadeIn(duration: 700.ms),
          ),
          Text(
            'Welcome, ${widget.userName}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Today marks the beginning of your journey with us. Sober is more than just a health and lifestyle app—it’s your companion in tracking and maintaining your sobriety. We’re here to help you stay focused, motivated, and on track, every step of the way.",
              style: TextStyle(
                fontFamily: 'Noto-Sans',
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "At Sober, we believe in progress over perfection. Whether it's one day or one year, every milestone counts, and we’ll be here to celebrate each one with you. Remember, it’s not just about quitting; it’s about building a healthier, stronger future. Let’s take this journey together.",
              style: TextStyle(
                fontFamily: 'Noto-Sans',
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              "LET'S START",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
