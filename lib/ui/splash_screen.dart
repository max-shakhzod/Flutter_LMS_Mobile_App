import 'package:flutter/material.dart';
import 'package:fyp_lms/ui/home/home_screen.dart';
import 'package:fyp_lms/ui/auth_screen/intro_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  initializeApp() async {
    SharedPreferences _sPrefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = _sPrefs.getBool('isLoggedIn');

    if (isLoggedIn != null && isLoggedIn) {
      Future.delayed(const Duration(milliseconds: 300));
      Navigator.of(context).pushReplacementNamed('/');
    }

    if (isLoggedIn == null || (!isLoggedIn)) {
      Future.delayed(const Duration(milliseconds: 300));
      Navigator.of(context).pushReplacementNamed('/Login');
    }

  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
