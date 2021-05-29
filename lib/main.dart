import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:uportal/screens/welcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference studentRef =
    FirebaseDatabase.instance.reference().child("students");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPortal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff577CF5),
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/splash-logo.png'),
        nextScreen: WelcomeScreen(),
        splashTransition: SplashTransition.rotationTransition,
        duration: 3000,
      ),
    );
  }
}
