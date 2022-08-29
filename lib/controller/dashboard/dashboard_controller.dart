import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:fyp_lms/web_service/model/post/post.dart';

import '../../web_service/model/course/course.dart';
import '../../web_service/model/user/account.dart';

class DashboardController {
  //'==========================================VARIABLES=================================================='
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? accountId;
  String? accountName;
  int? accountType;
  Account? user;

  int pageNo = 1;
  bool allowNextPage = true,
      isLoading = true, hasInit = false;

  List<Course> upcomingCourseList = List.empty(growable: true);
  List<Map<String, dynamic>> upcomingDateList = List.empty(growable: true);

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

  List<Post> postList = List.empty(growable: true);
  Map<String, bool> postLikes = {};

  //'==========================================METHODS=================================================='


  Future<void> initRefresh(BuildContext context, VoidCallback onCallback) {
    //FETCH UPCOMING COURSE
    return fetchUpcomingCourse(context, onCallback);
  }

  Future fetchUpcomingCourse(BuildContext context, VoidCallback onCallback) async {
    upcomingCourseList.clear();
    upcomingDateList.clear();
    postList.clear();
    postLikes.clear();

    print(
        '======================================BEGIN FETCH ACCOUNT===========================================');
    //GET ACCOUNT COURSE ASSIGNED
    DocumentSnapshot account = await _db.collection('account').doc(accountId).get();

    print(
        '======================================STOP FETCH ACCOUNT===========================================');
    //print('= ${account.data()} =');
    print(
        '======================================ACCOUNT DATA===================================================');

    if (account.data() != null) {
      user = Account.fromJson(account.data() as Map<String, dynamic>);
    }

    List<String>? courseTaken;
    List<String>? courseAssigned;

    if (accountType == 1) {
      //GET ACCOUNT COURSE TAKEN
      if (account.data() != null) {
        courseTaken = Account.fromJson(account.data() as Map<String, dynamic>).courseTaken;
      }
    } else {
      if (account.data() != null) {
        courseAssigned = Account.fromJson(account.data() as Map<String, dynamic>).courseAssigned;
      }
    }

    if (accountType == 1) {
      if (courseTaken != null) {
        for (var courseCode in courseTaken) {
          print('======================================BEGIN FETCH COURSE LIST===========================================');
          DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

          print('======================================END FETCH COURSE LIST===========================================');
          print('= ${snapshot.data()} =');
          print('======================================COURSE DATA===========================================');

          if (snapshot.data() != null) {
            Course course = Course.fromJson(snapshot.data() as Map<String,dynamic>);
            upcomingCourseList.add(course);

            final DateTime courseCreatedDate = DateTime.parse(course.createdAt!);
            final DateTime today = DateTime.now();
            int dayDifference = today.difference(courseCreatedDate).inDays;
            for (int i = 0; i < dayDifference ~/ 7; i++) {
              courseCreatedDate.add(Duration(days: 7));
            }

            print('========================================= FETCH COURSE ACCORDING DATE ====================================');
            //print('= QUERY PARAMETERS =');
            //print('= ${DateUtil().getDateFormatServer().format(courseCreatedDate)} =');
            //print('= ${DateUtil().getDateFormatServer().format(courseCreatedDate)}_$courseCode =');
            print('==========================================================================================================');

            QuerySnapshot snapshotData = await _db.collection('Course').doc(courseCode).collection('${DateUtil().getDateFormatServer().format(courseCreatedDate)}_$courseCode').get();
            //print('= ${snapshotData.docs[0].data()} =');
            print('========================================= END FETCH COURSE ACCORDING DATE ====================================');
            if (snapshotData.docs.isNotEmpty) {
              Map<String, dynamic> data = snapshotData.docs[0].data() as Map<String,dynamic>;
              upcomingDateList.add({
                'date': data['date'],
                'duration': data['duration'],
                'createdAt': data['createdAt'],
              });

              upcomingDateList.sort((a,b) =>
              join(DateTime.now(), TimeOfDay(hour: int.tryParse(a['duration'].substring(0,2))!, minute: int.tryParse(a['duration'].substring(3,5))!))
                  .difference(
                  join(DateTime.now(), TimeOfDay(hour: int.tryParse(b['duration'].substring(0,2))!, minute: int.tryParse(b['duration'].substring(3,5))!)))
                  .inMilliseconds
              );
            }
          }
        }
      }
    } else {
      if (courseAssigned != null) {
        for (var courseCode in courseAssigned) {
          print(
              '======================================BEGIN FETCH COURSE LIST===========================================');
          DocumentSnapshot snapshot = await _db.collection('Course').doc(courseCode).get();

          print(
              '======================================END FETCH COURSE LIST===========================================');
          //print('= ${snapshot.data()} =');
          print(
              '======================================COURSE DATA===========================================');

          if (snapshot.data() != null) {
            Course course = Course.fromJson(snapshot.data() as Map<String,dynamic>);
            upcomingCourseList.add(course);

            final DateTime courseCreatedDate = DateTime.parse(course.createdAt!);
            final DateTime today = DateTime.now();
            int dayDifference = today.difference(courseCreatedDate).inDays;
            for (int i = 0; i < dayDifference ~/ 7; i++) {
              courseCreatedDate.add(Duration(days: 7));
            }

            print('========================================= FETCH COURSE ACCORDING DATE ====================================');
            print('= QUERY PARAMETERS =');
            print('= ${DateUtil().getDateFormatServer().format(courseCreatedDate)} =');
            print('= ${DateUtil().getDateFormatServer().format(courseCreatedDate)}_$courseCode =');
            print('==========================================================================================================');

            QuerySnapshot snapshotData = await _db.collection('Course').doc(courseCode).collection('${DateUtil().getDateFormatServer().format(courseCreatedDate)}_$courseCode').get();
            print('= ${snapshotData.docs[0].data()} =');
            print('========================================= END FETCH COURSE ACCORDING DATE ====================================');
            if (snapshotData.docs.isNotEmpty) {
              Map<String, dynamic> data = snapshotData.docs[0].data() as Map<String,dynamic>;
              upcomingDateList.add({
                'date': data['date'],
                'duration': data['duration'],
                'createdAt': data['createdAt'],
              });

              upcomingDateList.sort((a,b) =>
                join(DateTime.now(), TimeOfDay(hour: int.tryParse(a['duration'].substring(0,2))!, minute: int.tryParse(a['duration'].substring(3,5))!))
                    .difference(
                    join(DateTime.now(), TimeOfDay(hour: int.tryParse(b['duration'].substring(0,2))!, minute: int.tryParse(b['duration'].substring(3,5))!)))
                    .inMilliseconds
              );
            }
          }
        }
      }
      onCallback();
    }

    return fetchPost(context, onCallback);
  }

  Future fetchPost(BuildContext context, VoidCallback onCallback) async {
    print('======================================BEGIN FETCH POST==================================================');

    if (accountType == 1) {
      if (user!.courseTaken != null && user!.courseTaken!.isNotEmpty) {
        for(var element in user!.courseTaken!) {
          print('======================================QUERY PARAMETER===================================================');
          print('= $element =');
          QuerySnapshot snapshot = await _db.collection('post')
              .where('courseBelonging', isEqualTo: element)
              .get();

          print('======================================END FETCH POST==================================================');
          print('= ${user!.courseTaken} =');
          print('= ${snapshot.docs} =');
          print('======================================POST DATA ==================================================');


          if (snapshot.docs.isNotEmpty) {
            for (var document in snapshot.docs) {
              Post post = Post.fromJson(document.data() as Map<String, dynamic>);
              postList.add(post);
              await _db.collection('post').doc(post.id).collection(user!.id.toString()).get().then((QuerySnapshot value) {
                if (value.docs.isNotEmpty) {
                  postLikes[post.id.toString()] = true;
                } else {
                  postLikes[post.id.toString()] = false;
                }

              });
            }
          }
        }
        isLoading = false;
        onCallback();
      }
    } else {
      if (user!.courseAssigned != null && user!.courseAssigned!.isNotEmpty) {
        for (var element in user!.courseAssigned!) {
          QuerySnapshot snapshot = await _db.collection('post')
              .where('courseBelonging', isEqualTo: element)
              .get();

          print('======================================END FETCH POST==================================================');
          print('= ${snapshot.docs} =');
          print('======================================POST DATA ==================================================');


          if (snapshot.docs.isNotEmpty) {
            for (var document in snapshot.docs) {
              Post post = Post.fromJson(document.data() as Map<String, dynamic>);
              postList.add(post);
              await _db.collection('post').doc(post.id).collection(user!.id.toString()).get().then((QuerySnapshot value) {
                if (value.docs.isNotEmpty) {
                  postLikes[post.id!] = true;
                } else {
                  postLikes[post.id!] = false;
                }
              });
            }
          }
        }
        isLoading = false;
        onCallback();
      }
    }
  }

  Future<bool> addLikes(String postId, String likeBy, int likeCount, VoidCallback onCallback) async {

    if (postLikes[postId]!) {
      int index = postList.indexWhere((element) => element.id == postId);
      postList[index].likes = postList[index].likes! - 1;
      postLikes[postId] = false;
      onCallback();

      print('======================================BEGIN DISLIKE POST==================================================');
      await _db.collection('post').doc(postId).update({
        'likes': likeCount--
      }).then((_) async {
        print('======================================BEGIN REMOVE POST LIKES COLLECTION==================================================');
        print('= $likeBy} =');
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
      int index = postList.indexWhere((element) => element.id == postId);
      postList[index].likes = postList[index].likes! + 1;
      postLikes[postId] = true;
      onCallback();

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

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}