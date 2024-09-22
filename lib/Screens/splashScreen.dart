import 'package:flutter/material.dart';
import 'package:student_app/Screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    GoToDataScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 20,fontStyle: FontStyle.italic ),)
          ],
        ),
      ),
    );
  }

  Future<void> GoToDataScreen() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) =>  HomeScreen(),
      ),
    );
  }
}
