import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_lloyd_web_app/view/screen/main_navigation_screen.dart';

import '../../utilities/common.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      checkLoggedIn();
    });
  }

  void checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(Common.isLoggedIn) ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainNavigationScreen()),
      );
    }
    else
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center, // Ensures all children are centered
        children: [

          Center(
            child: Lottie.asset(
              "assets/images/splash3.json",
              width: 250,  //Width
              height: 250,  //height
              fit: BoxFit.contain,
              repeat: true, // Keeps playing
            ),
          ),
          Center(
            child: Image.asset(

              'assets/images/loginlogo.png',
              width: 150,
              height: 150,
            ),
          ),

        ],
      ),
    );
  }

}
