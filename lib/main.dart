
import 'package:chat_app/pages/splashscreen.dart';
import 'package:chat_app/shared.dart/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Constante().prioritycolor,
          scaffoldBackgroundColor: Colors.white),
      // home:_isSignedIn ? HomePage() : LoginPage(),
      home: SplashScreen(),
    );
  }
}
