import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fyp_lms/web_service/model/user/account.dart';


import 'package:fyp_lms/utils/custom_field/input/number_input_field.dart';
import 'package:fyp_lms/utils/custom_field/input/number_two_input_field.dart';
import 'package:fyp_lms/utils/custom_field/input/text_input_field.dart';

import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  List<String> genderSelection = ['male', 'female', 'others'];

  String genderSelect = 'male';

  compileData(BuildContext context) async {
    print('hello');
    if (_usernameController.text.isEmpty) {
      showInfoDialog(context, null, 'Username cannot be empty.');
      return;
    }

    if (_phoneController.text.isEmpty) {
      showInfoDialog(context, null, 'Phone number cannot be empty.');
      return;
    }

    if (_yearController.text.isEmpty) {
      showInfoDialog(context, null, 'Academic Year cannot be empty.');
      return;
    }

    if (_semesterController.text.isEmpty) {
      showInfoDialog(context, null, 'Semester cannot be empty.');
      return;
    }

    Account account = Account();
    account.id = _auth.currentUser!.uid;
    account.displayName = _usernameController.text;
    account.currentAcademicYear = 'Year ${_yearController.text} Semester ${_semesterController.text}';
    account.gender = genderSelect;
    account.phoneNumber = _phoneController.text;
    account.accountType = 1;
    account.verified = _auth.currentUser!.emailVerified.toString();


    showLoading(context);
    await _database.collection('account').doc(_auth.currentUser!.uid).set(account.toJson()).then((value) async {
      DocumentSnapshot data = await _database.collection('account').doc(_auth.currentUser!.uid).get();

      Account createdUser = Account.fromJson(data.data() as Map<String,dynamic>);
      SharedPreferences _sPref = await SharedPreferences.getInstance();
      _sPref.setBool('isLoggedIn', true);
      _sPref.setString('account', createdUser.id.toString());
      _sPref.setString('username', createdUser.displayName!);
      _sPref.setInt('accountType', 1);
      _sPref.setString('accountInfo', json.encode(createdUser));
      _sPref.setBool('verified', _auth.currentUser!.emailVerified);

      Navigator.of(context).pushReplacementNamed('/SplashScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_COLOR_4,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: BG_COLOR_4,
        leading: const SizedBox(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 32.0, right: 32.0),
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: large_padding),
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Center(
                    child: Text('Fill Up Account Details', style: GoogleFonts.poppins().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    )),
                  ),

                  //USERNAME
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                      child: textInputField(_usernameController, () {}, 'USERNAME', fieldIcon: Icons.contact_page)),

                  //PHONE NUMBER
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: numberInputField(_phoneController, () {setState(() {});}, 'PHONE NUMBER', fieldIcon: Icons.phone)),

                  //GENDER
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.male,
                                color: Colors.grey,
                                size: 18,
                              ),
                              SizedBox(width: 2),
                              VerticalDivider(color: Colors.grey, width: 1, thickness: 1.5,),
                              SizedBox(width: 10),
                              Flexible(
                                  child: RichText(
                                      text: TextSpan(
                                          text: 'GENDER',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          children: [
                                            TextSpan(
                                                text: '*',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 13,
                                                      color: Colors.red),
                                                )),
                                          ]))
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.female,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(right: 12.0,bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //MALE
                              Row(
                                children: [
                                  Radio(
                                    onChanged: (value) {
                                      setState(() {
                                        genderSelect = genderSelection[0];
                                      });
                                    },
                                    groupValue: genderSelect,
                                    value: genderSelection[0],
                                    visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                                  ),
                                  Text('MALE'),
                                ],
                              ),

                              //FEMALE
                              Row(
                                children: [
                                  Radio(
                                    onChanged: (value) {
                                      setState(() {
                                        genderSelect = genderSelection[1];
                                      });
                                    },
                                    groupValue: genderSelect,
                                    value: genderSelection[1],
                                    visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                                  ),
                                  Text('FEMALE'),
                                ],
                              ),

                              //OTHERS
                              Row(
                                children: [
                                  Radio(
                                    onChanged: (value) {
                                      setState(() {
                                        genderSelect = genderSelection[2];
                                      });
                                    },
                                    groupValue: genderSelect,
                                    value: genderSelection[2],
                                    visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                                  ),
                                  Text('OTHERS'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  //ACADEMIC YEAR
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: numberTwoInputField(context, _yearController, _semesterController, (){}, 'ACADEMIC YEAR', inputLabel1: 'Year', inputLabel2: 'Semester', fieldIcon: Icons.book),
                  ),
                  const SizedBox(height: x_large_padding),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: const [
                            BG_COLOR_3,
                            BG_COLOR_2,
                            BG_COLOR_4,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [
                            0.0,
                            0.5,
                            0.8,
                          ]
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                    ).onTap(() {
                      compileData(context);
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
