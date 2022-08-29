import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/web_service/model/course/course.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/dialog.dart';

class CourseListingController {
  //================================================VARIABLES======================================================
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _debounce;

  String? accountId;
  String? accountName;
  int? accountType;
  Account? user;

  List<Course> currentCourseList = List.empty(growable: true);
  List<Course> hideCourseList = List.empty(growable: true);

  bool isLoading = false, courseListingIsExpanded = true, previousCourseListingIsExpanded = false, editMode = false, editMode2 = false;

  TextEditingController searchController = TextEditingController();

  List<String> courseColorSelection = [
    'Yellow',
    'Orange',
    'Red',
    'Pink',
    'Deep Purple',
    'Blue',
    'Light Blue',
    'Green Accent',
    'Green',
    'Teal',
  ];

  List<Color> courseColorSelectionColor = [
    Colors.yellow[300]!,
    Colors.orange[300]!,
    Colors.red[300]!,
    Colors.pink[300]!,
    Colors.deepPurple[300]!,
    Colors.blue[300]!,
    Colors.lightBlue[300]!,
    Colors.greenAccent[200]!,
    Colors.green[300]!,
    Colors.teal[300]!,
  ];

  TextEditingController addCourseCode = TextEditingController();

  //==================================================METHODS======================================================

  fetchCurrentCourse(VoidCallback onCallback) async {
    isLoading = true;
    onCallback();

    print('======================================BEGIN FETCH ACCOUNT===========================================');
    //GET ACCOUNT COURSE ASSIGNED
    DocumentSnapshot account = await _db.collection('account').doc(accountId).get();
    print('======================================STOP FETCH ACCOUNT===========================================');
    //print('= ${account.data()} =');
    print('======================================ACCOUNT DATA===================================================');

    if (accountType == 1) {
      //GET ACCOUNT COURSE TAKEN
      List<String>? currentEnrolledCourseCode;
      List<String>? courseTaken;
      if (account.data() != null) {
        user = Account.fromJson(account.data() as Map<String, dynamic>);
        currentEnrolledCourseCode = Account.fromJson(account.data() as Map<String, dynamic>).currentEnrolledCourseCode;
        courseTaken = Account.fromJson(account.data() as Map<String, dynamic>).courseTaken;
      }
      currentCourseList.clear();
      hideCourseList.clear();
      if (currentEnrolledCourseCode != null) {
        currentEnrolledCourseCode.forEach((courseCode) async {
          print('======================================BEGIN FETCH COURSE LIST===========================================');
          DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

          print('======================================END FETCH COURSE LIST===========================================');
          //print('= ${snapshot.data()} =');
          print('======================================COURSE DATA===========================================');

          if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
            currentCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
          }
          onCallback();
        });
      }

      if (courseTaken != null) {
        courseTaken.forEach((courseCode) async {
          if (!currentEnrolledCourseCode!.contains(courseCode)) {
            print('======================================BEGIN FETCH COURSE LIST===========================================');
            DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

            print('======================================END FETCH COURSE LIST===========================================');
            //print('= ${snapshot.data()} =');
            print('======================================COURSE DATA===========================================');

            if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
              hideCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
            }
            onCallback();
          }
        });
      }

      isLoading = false;
      onCallback();
    } else {
      List<String>? courseAssigned;
      List<String>? currentEnrolledCourseCode;
      if (account.data() != null) {
        courseAssigned = Account.fromJson(account.data() as Map<String, dynamic>).courseAssigned;
        currentEnrolledCourseCode = Account.fromJson(account.data() as Map<String, dynamic>).currentEnrolledCourseCode;
      }
      currentCourseList.clear();
      hideCourseList.clear();

      if (currentEnrolledCourseCode != null) {
        currentEnrolledCourseCode.forEach((courseCode) async {
          print('======================================BEGIN FETCH COURSE LIST===========================================');
          DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

          print('======================================END FETCH COURSE LIST===========================================');
          //print('= ${snapshot.data()} =');
          print('======================================COURSE DATA===========================================');

          if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
            currentCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
          }
          onCallback();
        });

        if (courseAssigned != null) {
          courseAssigned.forEach((courseCode) async {

            if (!currentEnrolledCourseCode!.contains(courseCode)) {
              print('======================================BEGIN FETCH COURSE LIST===========================================');
              DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

              print('======================================END FETCH COURSE LIST===========================================');
              //print('= ${snapshot.data()} =');
              print('======================================COURSE DATA===========================================');

              if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
                hideCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
              }
            }
            onCallback();
          });
        }
      }

      isLoading = false;
      onCallback();
    }

  }

  joinCourse(BuildContext context, String courseCode) async {
    showLoading(context);

    print('======================================BEGIN FETCH SELECTED COURSE===========================================');
    final QuerySnapshot snapshot = await _db.collection('Course').where('courseCode', isEqualTo: courseCode).get();

    print('======================================STOP FETCH SELECTED COURSE===========================================');
    print('= ${snapshot.docs.isNotEmpty ? snapshot.docs[0].data() : '[]'} =');
    print('======================================FETCH SELECTED COURSE DATA===========================================');

    if (snapshot.docs.isNotEmpty) {
      Course course = Course.fromJson(snapshot.docs[0].data() as Map<String, dynamic>);

      if (user!.courseTaken != null) {
        if (user!.courseTaken!.contains('${course.courseCode}_${course.courseName}')) {
          throw 'elementExists';
        }
        user!.courseTaken!.add('${course.courseCode}_${course.courseName}');
      } else {
        user!.courseTaken = ['${course.courseCode}_${course.courseName}'];
      }

      _db.collection('account').doc(accountId).update({
        'courseTaken': user!.courseTaken,
        'currentEnrolledCourseCode': user!.courseTaken,
      }).then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              // ICON
              Container(
                padding: const EdgeInsets.all(large_padding),
                decoration: ShapeDecoration(
                  color: Colors.white10,
                  shape: CircleBorder(),
                ),
                child: Icon(Icons.done, color: Colors.greenAccent,),
              ),
              const SizedBox(width: normal_padding),
              // TEXT
              Text('File Upload Succeed.', style: GoogleFonts.poppins().copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 1500),
          margin: const EdgeInsets.only(left: small_padding, right: small_padding, bottom: small_padding),
          backgroundColor: Colors.greenAccent,
        ));
        addCourseCode.clear();
      }, onError: (error) {
        Navigator.of(context).pop();
        showInfoDialog(context, null, error, callback: () {
          Navigator.of(context).pop();
        });

      });
    } else {
      addCourseCode.clear();
      showInfoDialog(context, null, 'No Course is Found', callback: () {
        Navigator.of(context).pop();
      });
    }
  }

  showCourse(BuildContext context, Course course, VoidCallback onCallback) {

    hideCourseList.remove(course);
    currentCourseList.add(course);

    _db.collection('account').doc(user!.id).update({
      'currentEnrolledCourseCode': accountType == 1 ? [...user!.courseTaken!, course.id] : [...user!.courseAssigned!, course.id],
    });

    onCallback();
  }

  hideCourse(BuildContext context, Course course, VoidCallback onCallback) {

    List<String> currentList = List.empty(growable: true);
    if (accountType == 1) {
      currentList = user!.currentEnrolledCourseCode!.where((element) => element != course.id).toList();
    } else {
      currentList = user!.currentEnrolledCourseCode!.where((element) => element != course.id).toList();

    }

    currentCourseList.remove(course);
    hideCourseList.add(course);

    _db.collection('account').doc(user!.id).update({
      'currentEnrolledCourseCode': currentList
    });

    onCallback();
  }

  onSearchChanged(BuildContext context, String query, VoidCallback onCallback) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: SEARCH_DELAY), () {
      searchCourse(context, onCallback);
    });
  }

  searchCourse(BuildContext context, VoidCallback onCallback) async {
    isLoading = true;
    onCallback();

    print('======================================BEGIN FETCH ACCOUNT===========================================');
    //GET ACCOUNT COURSE ASSIGNED
    DocumentSnapshot account = await _db.collection('account').doc(accountId).get();
    print('======================================STOP FETCH ACCOUNT===========================================');
    //print('= ${account.data()} =');
    print('======================================ACCOUNT DATA===================================================');

    if (accountType == 1) {
      //GET ACCOUNT COURSE TAKEN
      List<String>? currentEnrolledCourseCode;
      List<String>? courseTaken;
      if (account.data() != null) {
        user = Account.fromJson(account.data() as Map<String, dynamic>);
        currentEnrolledCourseCode = Account.fromJson(account.data() as Map<String, dynamic>).currentEnrolledCourseCode;
        courseTaken = Account.fromJson(account.data() as Map<String, dynamic>).courseTaken;
      }

      //FILTER DATA
      currentEnrolledCourseCode = currentEnrolledCourseCode!.where((element) => element.contains(searchController.text)).toList();
      courseTaken = courseTaken!.where((element) => element.contains(searchController.text)).toList();

      currentCourseList.clear();
      hideCourseList.clear();
      currentEnrolledCourseCode.forEach((courseCode) async {
        print('======================================BEGIN FETCH COURSE LIST===========================================');
        DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

        print('======================================END FETCH COURSE LIST===========================================');
        //print('= ${snapshot.data()} =');
        print('======================================COURSE DATA===========================================');

        if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
          currentCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
        }
        onCallback();
      });

      courseTaken.forEach((courseCode) async {
        if (!currentEnrolledCourseCode!.contains(courseCode)) {
          print('======================================BEGIN FETCH COURSE LIST===========================================');
          DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

          print('======================================END FETCH COURSE LIST===========================================');
          //print('= ${snapshot.data()} =');
          print('======================================COURSE DATA===========================================');

          if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
            hideCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
          }
          onCallback();
        }
      });

      isLoading = false;
      onCallback();
    } else {
      List<String>? courseAssigned;
      List<String>? currentEnrolledCourseCode;
      if (account.data() != null) {
        courseAssigned = Account.fromJson(account.data() as Map<String, dynamic>).courseAssigned;
        currentEnrolledCourseCode = Account.fromJson(account.data() as Map<String, dynamic>).currentEnrolledCourseCode;
      }
      currentCourseList.clear();
      hideCourseList.clear();

      courseAssigned = courseAssigned!.where((element) => element.contains(searchController.text)).toList();
      currentEnrolledCourseCode = currentEnrolledCourseCode!.where((element) => element.contains(searchController.text)).toList();

      currentEnrolledCourseCode.forEach((courseCode) async {
        print('======================================BEGIN FETCH COURSE LIST===========================================');
        DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

        print('======================================END FETCH COURSE LIST===========================================');
        //print('= ${snapshot.data()} =');
        print('======================================COURSE DATA===========================================');

        if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
          currentCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
        }
        onCallback();
      });

      courseAssigned.forEach((courseCode) async {

        if (!currentEnrolledCourseCode!.contains(courseCode)) {
          print('======================================BEGIN FETCH COURSE LIST===========================================');
          DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

          print('======================================END FETCH COURSE LIST===========================================');
          //print('= ${snapshot.data()} =');
          print('======================================COURSE DATA===========================================');

          if (snapshot.data() != null && !(snapshot.data() as Map<String,dynamic>)['isHide']) {
            hideCourseList.add(Course.fromJson((snapshot.data() as Map<String,dynamic>)));
          }
        }
        onCallback();
      });

      isLoading = false;
      onCallback();
    }
  }
}