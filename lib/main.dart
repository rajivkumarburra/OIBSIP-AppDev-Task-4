import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        secondaryHeaderColor: Colors.pink,
        fontFamily: 'Inter',
      ),
      home: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return const MyHomePage();
        },
        stream: Firebase.initializeApp().asStream(),
      ),
      routes: {
        MyHomePage.routeName: (context) => const MyHomePage(),
        QuizScreen.routeName: (context) => const QuizScreen(),
        ResultScreen.routeName: (context) => const ResultScreen(),
      },
    );
  }
}
