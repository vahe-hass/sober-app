import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // PayPal donation link
  final String _donationUrl = 'https://www.paypal.com/donate?hosted_button_id=YOUR_BUTTON_ID';

  // Function to launch the URL
  Future<void> _launchDonationUrl() async {
    if (await canLaunch(_donationUrl)) {
      await launch(_donationUrl);
    } else {
      throw 'Could not launch $_donationUrl';
    }
  }

  int soberDays = 0; // Placeholder for the number of sober days

  // Define achievements with their respective unlock days
  final List<Map<String, dynamic>> achievements = [
    {'text': 'First week sober', 'daysRequired': 7},
    {'text': 'Two weeks sober', 'daysRequired': 14},
    {'text': 'One month sober', 'daysRequired': 30},
    {'text': 'Three months sober', 'daysRequired': 90},
    {'text': 'Six months sober', 'daysRequired': 180},
    {'text': 'One year sober', 'daysRequired': 365},
  ];

  @override
  void initState() {
    super.initState();
    // Normally you'd load soberDays here, e.g., from SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            height: 80,
          ),
          const SizedBox(height: 20),

          // Expanded list of achievements
          Expanded(
            child: ListView.builder(
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                bool isUnlocked = soberDays >= achievement['daysRequired'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(
                      Icons.emoji_events,
                      color: isUnlocked ? Colors.green : Colors.grey,  // Highlight icon based on unlock status
                      size: 40,
                    ),
                    title: Text(
                      achievement['text'],
                      style: TextStyle(
                        fontSize: 18,
                        color: isUnlocked ? Colors.black : Colors.grey,  // Grey out text if not unlocked
                      ),
                    ),
                    subtitle: Text(
                      '${achievement['daysRequired']} days required',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          // Donate Button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: _launchDonationUrl,
              child: const Text(
                'Donate',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
