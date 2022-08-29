import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:fyp_lms/web_service/model/post/post.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import '../../utils/date_util.dart';
import '../../web_service/model/course/course.dart';


class CourseDetailController {
  //'==========================================VARIABLES=================================================='

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? accountId;
  String? accountName;
  int? accountType;
  Account? user;

  bool isLoading = false, fetchPostIsLoading = false;

  Course? course;

  List<String> colorSelection = [
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

  List<Color> colorSelectionColor = [
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

  List attachmentList = List.empty(growable: true);
  List<Post> postList = List.empty(growable: true);
  Map<String, bool> postLikes = {};

  //'==========================================METHODS=================================================='

  refreshCourse(BuildContext context) async {
    isLoading = true;
    print('======================================BEGIN FETCH COURSE==================================================');
    DocumentSnapshot snapshot = await _db.collection('Course').doc(course!.id).get();
    print('======================================STOP FETCH COURSE==================================================');
    //print('= ${snapshot.data()} =');
    print('======================================COURSE DATA==================================================');

    Course courseRefresh = Course.fromJson(snapshot.data() as Map<String, dynamic>);
    course = courseRefresh;
    return true;
  }

  fetchCourse(BuildContext context, VoidCallback onCallback, String courseId) async {
    print('======================================BEGIN FETCH COURSE==================================================');
    DocumentSnapshot snapshot = await _db.collection('Course').doc(courseId).get();
    print('======================================STOP FETCH COURSE==================================================');
    //print('= ${snapshot.data()} =');
    print('======================================COURSE DATA==================================================');

    Course courseRefresh = Course.fromJson(snapshot.data() as Map<String, dynamic>);
    course = courseRefresh;
    return true;
  }

  fetchPost(BuildContext context, VoidCallback onCallback) async {
    postList.clear();
    print('======================================BEGIN FETCH POST==================================================');
    print('======================================QUERY PARAMETER===================================================');
    print('= QUERY PARAM: ${course!.id} =');
    QuerySnapshot snapshot = await _db.collection('post')
        .where('courseBelonging', isEqualTo: course!.id.toString())
        .get();
    print('======================================END FETCH POST==================================================');
    print('= ${snapshot.docs} =');
    print('======================================POST DATA ==================================================');


    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((QueryDocumentSnapshot document) async {
        Post post = Post.fromJson(document.data() as Map<String, dynamic>);
        postList.add(post);
        await _db.collection('post').doc(post.id).collection(user!.id.toString()).get().then((QuerySnapshot value) {
          if (value.docs.isNotEmpty) {
            postLikes[post.id!] = true;
          } else {
            postLikes[post.id!] = false;
          }
        });
        onCallback();
      });
    }
  }

  uploadFile(BuildContext context, PlatformFile file) async {

    showLoading(context);

    final uploadedFile = _storage.ref().child('${course!.courseCode}_${course!.courseName}_${file.name}').putFile(File(file.path!));
    uploadedFile.then((TaskSnapshot snapshot) async {
      final downloadLink = await snapshot.ref.getDownloadURL();

      CourseMaterial courseMaterial = CourseMaterial();
      courseMaterial.materialPath = downloadLink;
      courseMaterial.materialName = file.name;
      courseMaterial.id = '${course!.courseCode}_${course!.courseName}_${file.name}';
      courseMaterial.courseBelonging = course!.id;
      courseMaterial.createdDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
      courseMaterial.fileSize = file.size.toString();
      courseMaterial.materialType = file.path.isVideo ? 'video' : file.path.isImage ? 'image' : 'document';
      courseMaterial.submittedBy = accountId;

      print('================================================GET COURSE MATERIAL DATA=====================================');
      DocumentSnapshot courseMaterialSnapshot = await _db
          .collection('course_material')
          .doc('${course!.id}').get();

      List attachment = List.empty(growable: true);

      if (courseMaterialSnapshot.data() != null) {
        attachment = (courseMaterialSnapshot.data() as Map<String, dynamic>)['fileList'];
      }
      print('================================================END COURSE MATERIAL DATA=====================================');

      print('================================================BEGIN COURSE MATERIAL DATA UPLOAD=====================================');
      _db
          .collection('course_material')
          .doc('${course!.courseCode}_${course!.courseName}_${file.name}').set({
        'courseBelonging': '${course!.courseCode}_${course!.courseName}',
        'createdDate': DateUtil().getDatetimeFormatServer().format(DateTime.now()),
        'id': '${course!.courseCode}_${course!.courseName}_${file.name}',
        'fileList': [...attachment, '${course!.courseCode}_${course!.courseName}_${file.name}'],
        'uploadedBy': user!.id.toString(),
      });

      _db.collection('course_material')
          .doc('${course!.courseCode}_${course!.courseName}_${file.name}')
          .collection('${course!.courseCode}_${course!.courseName}_${file.name}')
          .doc('${course!.courseCode}_${course!.courseName}_${file.name}')
          .set(courseMaterial.toJson()).then((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              // ICON
              Container(
                padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: small_padding, bottom: small_padding),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Icon(Icons.done, color: Colors.greenAccent[700],),
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
          margin: const EdgeInsets.only(left: large_padding, right: large_padding, bottom: x_large_padding),
          backgroundColor: Colors.greenAccent,

        ),);
      },
        onError: (e) {
            Navigator.of(context).pop();
            showInfoDialog(context, null, e.toString(), callback: () {
              Navigator.of(context).pop();
            });
        }
      );
    });
  }

  Future<bool> addLikes(String postId, String likeBy, int likeCount, VoidCallback onCallback) async {
    if (postLikes[postId]!) {
      int index = postList.indexWhere((element) => element.id == postId);
      postList[index].likes = postList[index].likes! - 1;
      postLikes[postId] = false;
      onCallback();
    } else {
      int index = postList.indexWhere((element) => element.id == postId);
      postList[index].likes = postList[index].likes! + 1;
      postLikes[postId] = true;
      onCallback();
    }

    if (postLikes[postId]!) {
      print('======================================BEGIN DISLIKE POST==================================================');
      await _db.collection('post').doc(postId).update({
        'likes': likeCount--
      }).then((_) async {
        print('======================================BEGIN REMOVE POST LIKES COLLECTION==================================================');
        await _db.collection('post').doc(postId).collection(likeBy).where('likeBy', isEqualTo: likeBy).get().then((snapshot) {
          print('======================================DELETING POST LIKES COLLECTION==================================================');
          snapshot.docs.forEach((document) async {
            await document.reference.delete();
          });
          print('======================================DELETE SUCCESSFUL ==================================================');
          return true;
        }, onError: (e) => false);
        print('======================================STOP REMOVE POST LIKES COLLECTION==================================================');
      }, onError: (e) => false);
      return true;
    } else {
      print('======================================BEGIN ADD POST LIKES==================================================');

      await _db.collection('post').doc(postId).update({
        'likes': likeCount++
      }).then((_) {
        print('======================================BEGIN ADD POST LIKES COLLECTION==================================================');
        _db.collection('post').doc(postId).collection(likeBy).doc(likeBy).set({
          'likeBy': likeBy,
          'createdAt': DateUtil().getDatetimeFormatServer().format(DateTime.now()),
        }).then((__) {
          print('======================================LIKE POST COLLECTION CREATED==================================================');
          return true;
        }, onError: (e) => false);
      }, onError: (e) => false);
      print('======================================STOP ADD POST LIKES COLLECTION==================================================');

      return true;
    }

  }

  deleteCourse(BuildContext context) async {
    showLoading(context);

    //===============================================START DELETE THE COURSE===========================================================
    //DELETE COURSE
    await _db.collection('Course').doc(course!.id).delete();
    for (int i = 0; i < 4; i++) {
      QuerySnapshot courseSnapshot = await _db.collection('Course').doc(course!.id).collection('${DateUtil().getDateFormatServer().format(DateTime.parse(course!.createdAt!).add(Duration(days: 7 * i)))}_${course!.id}').get();
      for (var doc in courseSnapshot.docs) {
        doc.reference.delete();
      }
    }


    //DELETE RECORD IN EVERY ACCOUNT
    QuerySnapshot accountSnapshot = await _db.collection('account').get();
    for (var doc in accountSnapshot.docs) {
      Account account = Account.fromJson(doc.data() as Map<String,dynamic>);
      if (account.accountType == 1) {
        if (account.courseTaken != null && account.courseTaken!.isNotEmpty) {
          List<String> newCourseTaken = account.courseTaken!.where((e) => e != course!.id).toList();
          account.courseTaken = newCourseTaken;
          _db.collection('account').doc(account.id).set(account.toJson());
        }
        if (account.currentEnrolledCourseCode != null && account.currentEnrolledCourseCode!.isNotEmpty) {
          List<String> newCourseTaken = account.currentEnrolledCourseCode!.where((e) => e != course!.id).toList();
          account.currentEnrolledCourseCode = newCourseTaken;
          _db.collection('account').doc(account.id).set(account.toJson());
        }
      } else {
        if (account.courseAssigned != null && account.courseAssigned!.isNotEmpty) {
          List<String> newCourseAssigned = account.courseAssigned!.where((e) => e != course!.id).toList();
          account.courseTaken = newCourseAssigned;
          _db.collection('account').doc(account.id).set(account.toJson());
        }

        if (account.currentEnrolledCourseCode != null && account.currentEnrolledCourseCode!.isNotEmpty) {
          List<String> newCourseTaken = account.currentEnrolledCourseCode!.where((e) => e != course!.id).toList();
          account.currentEnrolledCourseCode = newCourseTaken;
          _db.collection('account').doc(account.id).set(account.toJson());
        }
      }
    }

    //DELETE RESPECTIVE POST
    QuerySnapshot postSnapshot = await _db.collection('post').where('courseBelonging', isEqualTo: course!.id).get();
    for (var doc in postSnapshot.docs) {
      doc.reference.delete();
    }

    Navigator.of(context).pop();
    showSuccessDialog(context, 'Delete Success', 'Course is Removed successfully', () {
      Navigator.of(context).pop();
    });

  }

}