import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grow_buddy/features/login_screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile-screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _userName = '';
  late String _userEmail = '';
  late String _userPhone = '';
  late String _userState = '';
  late String _userCity = '';
  late String _userAge = '';
  late String _userMainCrops = '';
  late String _userLandArea = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  bool _isLoading = true;

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'] ?? 'No name';
            _userEmail = user.email ?? 'No email';
            _userPhone = userDoc['phone'] ?? 'No phone number';
            _userState = userDoc['state'] ?? 'No state';
            _userCity = userDoc['city'] ?? 'No city';
            _userAge = userDoc['age'] ?? 'No age';
            _userMainCrops = userDoc['main_crops'] ?? 'No crops listed';
            _userLandArea = userDoc['land_area'] ?? 'No land area listed';
          });
        } else {
          // Handle case where document doesn't exist
          setState(() {
            _userName = 'No name';
            _userEmail = 'No email';
            _userPhone = 'No phone number';
            _userState = 'No state';
            _userCity = 'No city';
            _userAge = 'No age';
            _userMainCrops = 'No crops listed';
            _userLandArea = 'No land area listed';
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
    setState(() {
      _isLoading = false; // Set loading flag to false in case of an error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Picture
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        "assets/images/profile.png",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userEmail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ProfileDetailRow(
                              icon: Icons.phone,
                              title: "Phone",
                              value: _userPhone,
                            ),
                            ProfileDetailRow(
                              icon: Icons.location_on,
                              title: "Location",
                              value: "$_userCity, $_userState",
                            ),
                            ProfileDetailRow(
                              icon: Icons.calendar_today,
                              title: "Age",
                              value: _userAge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Additional Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ProfileDetailRow(
                              icon: Icons.agriculture,
                              title: "Main Crops",
                              value: _userMainCrops,
                            ),
                            ProfileDetailRow(
                              icon: Icons.landscape,
                              title: "Area",
                              value: _userLandArea,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        });
                      },
                      child: const Text(
                        "Log Out",
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
