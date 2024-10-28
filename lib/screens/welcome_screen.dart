import 'package:flutter/material.dart';

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
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60.0),
            height: 30,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFa3c7e8),
                  width: 1.0,
                ),
              ),
            ),
          ),
          Image.asset('assets/images/sober_handshake.png'),
          const SizedBox(height: 20),
          Text(
            widget.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              "Today marks the beginning of your journey with us. Sober is more than just a health and lifestyle app—it’s your companion in tracking and maintaining your sobriety. We’re here to help you stay focused, motivated, and on track, every step of the way.",
              style: TextStyle(
                fontFamily: 'Noto-Sans',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              "At Sober, we believe in progress over perfection. Whether it's one day or one year, every milestone counts, and we’ll be here to celebrate each one with you. Remember, it’s not just about quitting; it’s about building a healthier, stronger future. Let’s take this journey together.",
              style: TextStyle(
                fontFamily: 'Noto-Sans',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
