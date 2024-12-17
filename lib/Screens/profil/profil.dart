import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/bottomBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('users');
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  User? _user;
  bool _isLoading = true;
  int _selectedIndex = 2; // Set the initial index to 2 for the profile screen

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      final userData = await _dbRef.child(_user!.uid).get();
      if (userData.exists) {
        final userInfo = userData.value as Map;
        _addressController.text = userInfo['address'] ?? '';
        _cityController.text = userInfo['city'] ?? '';
        _postalCodeController.text = userInfo['postalCode'] ?? '';
        _birthdayController.text = userInfo['birthday'] ?? '';
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_user != null) {
      await _dbRef.child(_user!.uid).update({
        'address': _addressController.text,
        'city': _cityController.text,
        'postalCode': _postalCodeController.text,
        'birthday': _birthdayController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile mis à jour')),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/cart');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text('Votre profil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF2661FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Icon at the top
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Email (Read-only)
            TextFormField(
              initialValue: _user!.email,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
              ),
              readOnly: true,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Password (Read-only)
            TextFormField(
              initialValue: '********',
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Colors.black),
              ),
              readOnly: true,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Birthday Field
            TextFormField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                labelText: 'Date de naissance',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Address Field
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // City Field
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ville',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Postal Code Field
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Code postal',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: const Text('Valider', style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2661FA),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}