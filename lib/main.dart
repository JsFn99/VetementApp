import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/cart/cart.dart';
import 'Screens/home/details.dart';
import 'Screens/home/home.dart';
import 'Screens/login/login.dart';
import 'Screens/profil/profil.dart';
import 'Screens/register/register.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clothing Store',
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/details': (context) => const DetailScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}

