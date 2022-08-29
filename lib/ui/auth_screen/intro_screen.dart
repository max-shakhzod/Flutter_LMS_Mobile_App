import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:fyp_lms/controller/auth/auth_services.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin{
  //====================== VARIABLES =================================

  final AuthService _auth = AuthService();
  bool _registerState = false;

  TextEditingController? _usernameController;
  String? usernameErrorMessage;

  TextEditingController? _passwordController;
  String? passwordErrorMessage;
  bool passwordVisibility = false;

  TextEditingController? _confirmPasswordController;
  String? confirmPasswordErrorMessage;
  bool confirmPasswordVisibility2 = false;

  //bool _nameAutoFocus = true;


  //===================== METHODS ====================================
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  loginViaEmail(BuildContext context) {
    usernameErrorMessage = null; passwordErrorMessage = null;

    if (_usernameController!.text.validateEmail() == false) usernameErrorMessage = 'Please enter valid email address';
    if (_passwordController!.text.length < 8) passwordErrorMessage = 'Password Must be at least 8 characters';

    setState(() {});
    if (passwordErrorMessage != null || usernameErrorMessage != null) return;
    if (passwordErrorMessage == null || usernameErrorMessage == null) {
      showLoading(context);
      final result = _auth.signInWithEmailAndPassword(_usernameController!.text, _passwordController!.text);
      result.then((value) async {
        switch(value) {
          case 1:
            Navigator.of(context).pushNamed('/VerificationScreen');
            break;

          case 2:
            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
            FirebaseFirestore _database = FirebaseFirestore.instance;

            DocumentSnapshot data = await _database.collection('account').doc(firebaseAuth.currentUser!.uid).get();

            if (data.data() == null || (data.data() as Map<String, dynamic>)['displayName'] == null) {
              Navigator.of(context).pushNamed('/CreateAccountScreen');
            } else {
              Account createdUser = Account.fromJson(data.data() as Map<String,dynamic>);
              SharedPreferences _sPref = await SharedPreferences.getInstance();
              _sPref.setBool('isLoggedIn', true);
              _sPref.setString('account', createdUser.id.toString());
              _sPref.setString('username', createdUser.displayName!);
              _sPref.setInt('accountType', createdUser.accountType!);
              _sPref.setBool('verified', firebaseAuth.currentUser!.emailVerified);
              _sPref.setString('accountInfo', jsonEncode(createdUser));

              Navigator.of(context).pushReplacementNamed('/');
            }
            break;

          default:
            break;
        }
      },onError: (e) {
        showInfoDialog(context, null, e.toString(), callback: () {
          Navigator.of(context).pop();
        });
      });
    }
  }

  registerViaEmail(BuildContext context) async {
    usernameErrorMessage = null; passwordErrorMessage = null; confirmPasswordErrorMessage = null;

    if (_usernameController!.text.validateEmail() == false) usernameErrorMessage = 'Please enter valid email address';
    if (_passwordController!.text.length < 8) passwordErrorMessage = 'Password Must be at least 8 characters';
    if (_confirmPasswordController!.text.length < 8 || _confirmPasswordController!.text != _passwordController!.text) confirmPasswordErrorMessage = 'Confirm Password must be the same as password.';

    setState(() {});
    if (passwordErrorMessage != null || usernameErrorMessage != null || confirmPasswordErrorMessage != null) return;

    final result = _auth.registerWithEmailAndPassword(_usernameController!.text, _passwordController!.text);
    result.then((response) {
      if (response) {
        Navigator.of(context).pushNamed('/VerificationScreen');
      } else {
        showInfoDialog(context, null, 'Something went wrong. Please try again.', callback: () {
          Navigator.of(context).pop();
        });
      }
    }, onError: (e) {
      if (e is FirebaseAuthException) {
        setState(() {
          usernameErrorMessage = 'Email already taken.';
        });
        return;
      } else {
        showInfoDialog(context, null, 'Something went wrong. Please try again.', callback: () {
          Navigator.of(context).pop();
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2.0,
            colors: [
              BG_COLOR_1,
              BG_COLOR_1,
              BG_COLOR_4,
            ],
            stops: [
              0.0,
              0.9,
              1.0,
            ]
          )
        ),
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: 24.0, right: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // LOGO
                Center(
                  child: Image(
                    image: AssetImage('assets/lmsMainLogo-removebg.png'),
                    height: 270
                  ),
                ),
                const SizedBox(height: large_padding,),
                // USERNAME
                Container(
                  height: usernameErrorMessage != null ? 80 : 56,
                  margin: const EdgeInsets.only(top: large_padding, bottom: small_padding),
                  child: TextField(
                    controller: _usernameController,
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: BORDER_BLUE, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: BORDER_BLUE, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: BORDER_BLUE, width: 2.0),
                      ),
                      hintText: 'e.g: xxx@gmail.com',
                      hintStyle: GoogleFonts.poppins().copyWith(color: HINT_TEXT_COLOR),
                      labelText: 'Email',
                      labelStyle: GoogleFonts.poppins().copyWith(color: BORDER_BLUE),
                      errorStyle: GoogleFonts.poppins().copyWith(
                        color: ERROR_RED,
                        fontSize: SUB_TITLE,
                      ),
                      errorText: usernameErrorMessage,
                      prefixIcon: const Icon(Icons.email, color: BORDER_BLUE, size: 22,),
                      suffixIcon: _usernameController!.text.isEmpty ? const SizedBox() :
                      const Icon(Icons.cancel, color: Colors.grey, size: 18).onTap(() {
                        setState(() {
                          _usernameController!.text = '';
                        });
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: normal_padding),

                // PASSWORD
                Container(
                  height: passwordErrorMessage != null ? 80 : 56,
                  margin: const EdgeInsets.only(top: large_padding, bottom: small_padding),
                  child: TextField(
                    controller: _passwordController,
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !passwordVisibility,
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: BORDER_BLUE, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: BORDER_BLUE, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: BORDER_BLUE, width: 2.0),
                      ),
                      errorStyle: GoogleFonts.poppins().copyWith(
                        color: ERROR_RED,
                        fontSize: SUB_TITLE,
                      ),
                      hintText: 'e.g: xxxxxxxx',
                      hintStyle: GoogleFonts.poppins().copyWith(color: HINT_TEXT_COLOR),
                      labelText: 'Password',
                      labelStyle: GoogleFonts.poppins().copyWith(color: BORDER_BLUE),
                      errorText: passwordErrorMessage,
                      prefixIcon: const Icon(Icons.lock, color: BORDER_BLUE, size: 22,),
                      suffixIcon: Icon(passwordVisibility ? Icons.visibility : Icons.visibility_off, color: BORDER_BLUE, size: 18).onTap(() {
                        setState(() {
                          passwordVisibility = !passwordVisibility;
                        });
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: normal_padding),

                // CONFIRM PASSWORD
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: ANIMATION_DURATION),
                  height: _registerState && confirmPasswordErrorMessage != null ? 72 + x_large_padding : _registerState ? 72 : 0,
                  child: !_registerState ? const SizedBox() : Container(
                    height: 80,
                    margin: const EdgeInsets.only(top: large_padding, bottom: small_padding),
                    child: TextField(
                      controller: _confirmPasswordController,
                      maxLines: 1,
                      minLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !confirmPasswordVisibility2,
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: BORDER_BLUE, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: BORDER_BLUE, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: BORDER_BLUE, width: 2.0),
                        ),
                        errorStyle: GoogleFonts.poppins().copyWith(
                          color: ERROR_RED,
                          fontSize: SUB_TITLE,
                        ),
                        hintText: 'e.g: xxxxxxxx',
                        hintStyle: GoogleFonts.poppins().copyWith(color: HINT_TEXT_COLOR),
                        labelText: 'Confirm Password',
                        labelStyle: GoogleFonts.poppins().copyWith(color: BORDER_BLUE),
                        errorText: confirmPasswordErrorMessage,
                        prefixIcon: const Icon(Icons.lock, color: BORDER_BLUE, size: 22,),
                        suffixIcon: Icon(confirmPasswordVisibility2 ? Icons.visibility : Icons.visibility_off, color: BORDER_BLUE, size: 18).onTap(() {
                          setState(() {
                            confirmPasswordVisibility2 = !confirmPasswordVisibility2;
                          });
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: x_large_padding),

                //LOGIN BUTTON
                Container(
                  padding: const EdgeInsets.only(left: x_large_padding, right: x_large_padding, top: normal_padding, bottom: normal_padding),
                  decoration: const BoxDecoration(
                    color: BG_COLOR_4,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(_registerState ? 'REGISTER VIA EMAIL' : 'LOGIN VIA EMAIL', style: GoogleFonts.poppins().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),),
                ).onTap(() {
                  if (_registerState) {
                    registerViaEmail(context);
                  } else {
                    loginViaEmail(context);
                  }
                }),

                const SizedBox(height: x_large_padding,),
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  constraints: _registerState
                      ? const BoxConstraints(maxHeight: 0.0)
                      : const BoxConstraints(maxHeight: 25),
                  duration: const Duration(milliseconds: ANIMATION_DURATION),
                  child: _registerState ? const SizedBox() : Center(
                    child: Text('Don\'t have an account?', style: GoogleFonts.poppins().copyWith(
                      color: HINT_TEXT_COLOR,
                      fontSize: HINT_TEXT,
                    ),),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  constraints: _registerState
                      ? const BoxConstraints(maxHeight: 0.0)
                      : const BoxConstraints(maxHeight: 25),
                  duration: const Duration(milliseconds: ANIMATION_DURATION),
                  child: _registerState ? const SizedBox() : Center(
                    child: Text('Register Here', style: GoogleFonts.poppins().copyWith(
                      color: BG_COLOR_2,
                      fontSize: SUB_TITLE,
                    )),
                  ).onTap(() {
                    //ENABLE REGISTER FIELD
                    setState(() {
                      _registerState = true;
                    });
                  }),
                ),

                AnimatedContainer(
                  curve: Curves.easeInOut,
                  constraints: _registerState
                      ? const BoxConstraints(maxHeight: 25)
                      : const BoxConstraints(maxHeight: 0.0),
                  duration: const Duration(milliseconds: ANIMATION_DURATION),
                  child: !_registerState ? const SizedBox() : Center(
                    child: Text('Already have an account?', style: GoogleFonts.poppins().copyWith(
                      color: HINT_TEXT_COLOR,
                      fontSize: HINT_TEXT,
                    )),
                  ).onTap(() {
                    //DISABLE REGISTER FIELD
                    setState(() {
                      _registerState = false;
                    });
                  }),
                ),

                AnimatedContainer(
                  curve: Curves.easeInOut,
                  constraints: _registerState
                      ? const BoxConstraints(maxHeight: 25)
                      : const BoxConstraints(maxHeight: 0.0),
                  duration: const Duration(milliseconds: ANIMATION_DURATION),
                  child: !_registerState ? const SizedBox() : Center(
                    child: Text('Login Here', style: GoogleFonts.poppins().copyWith(
                      color: BG_COLOR_2,
                      fontSize: SUB_TITLE,
                    )),
                  ).onTap(() {
                    //DISABLE REGISTER FIELD
                    setState(() {
                      _registerState = false;
                    });
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController!.dispose();
    _passwordController!.dispose();
    _confirmPasswordController!.dispose();
    super.dispose();
  }
}
