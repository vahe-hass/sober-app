import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // PayPal donation link
  final String _donationUrl =
      'https://www.paypal.com/donate?hosted_button_id=YOUR_BUTTON_ID';

  int soberDays = 0;

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
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.emoji_events,
                        color: isUnlocked
                            ? Theme.of(context).primaryColorLight
                            : Colors
                                .grey, // Highlight icon based on unlock status
                        size: 60,
                      ),
                      title: Text(
                        achievement['text'],
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: isUnlocked
                              ? Theme.of(context).primaryColorLight
                              : Colors.grey, // Grey out text if not unlocked
                        ),
                      ),
                      subtitle: Text(
                        '${achievement['daysRequired']} days required',
                        style: const TextStyle(
                          fontFamily: 'Noto-Sans',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Support Our Mission',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Your donation helps us improve Sober and continue supporting more people on their journey to sobriety. Every contribution makes a difference!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto-Sans',
              ),
            ),
          ),
          // Donate Button at the bottom
          ElevatedButton(
            onPressed: _launchDonationUrl,
            child: const Text(
              'Donate',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to launch the URL
  Future<void> _launchDonationUrl() async {
    if (await canLaunch(_donationUrl)) {
      await launch(_donationUrl);
    } else {
      throw 'Could not launch $_donationUrl';
    }
  }

  // Function to load user data (soberDays) from local storage
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString('sobrietyDate');
    if (dateString != null) {
      DateTime sobrietyStartDate = DateTime.parse(dateString);
      setState(() {
        soberDays = DateTime.now().difference(sobrietyStartDate).inDays;
      });
    }
  }
}
