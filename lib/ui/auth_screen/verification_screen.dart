import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_lms/controller/auth/auth_services.dart';
import 'dart:async';

import 'package:fyp_lms/utils/constant.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  final AuthService _auth = AuthService();
  User? userCredential;

  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();
    checkIsUserLogin();
  }

  checkIsUserLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        userCredential = user;
        canResendEmail = true;
      });

      if (userCredential != null) {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

        if(!isEmailVerified){
          sendVerificationEmail();
          timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified(),);
        }
      }

    });
  }

  Future sendVerificationEmail() async{
    print(canResendEmail);
    if(canResendEmail == true){
      try{
        final user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();

        setState(() => canResendEmail = false);
        await Future.delayed(Duration(seconds: 5));
        setState(() => canResendEmail = true);
      } catch (e){
        print(e);
      }
    }
  }

  Future checkEmailVerified() async{
    //call afer email verification!
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) {
      timer?.cancel();
      Navigator.of(context).pushReplacementNamed('/CreateAccountScreen');
    }
  }


  @override
  void dispose() {
    _auth.signOut();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A Verification email has been sent to your email Address WOOHOOOHOHOHOHOHOH',
              style: TextStyle(fontSize:20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              icon: Icon(Icons.email, size: 32),
              label: Text('Resent Email', style: TextStyle(fontSize: 24),
              ),
              onPressed: (){
                sendVerificationEmail();
              },
            ),
            TextButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),

            canResendEmail ? const SizedBox() : const Center(
              child: CircularProgressIndicator(color: BG_COLOR_4,),
            )
          ],

        ),
      ),
    );
  }
}
