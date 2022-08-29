import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:fyp_lms/web_service/model/course/course.dart';
import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:fyp_lms/web_service/model/post/comment.dart';
import 'package:fyp_lms/web_service/model/post/post.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class PostDetailController {
  //=================================VARIABLES===================================
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? accountId, accountName;
  int? accountType;
  Account? user;

  Post? post;
  String? postId;

  Course? course;

  bool isLoading = false, isLiked = false, commentLoading = false;

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

  List<Comment> commentList = List.empty(growable: true);

  TextEditingController commentController = TextEditingController();
  //DOCUMENT FULL PATH
  List<String> attachments = List.empty(growable: true);
  //DOCUMENT NAME
  List<String> attachmentsFull = List.empty(growable: true);

  //====================================METHODS===================================

  refreshPost(BuildContext context, VoidCallback onCallback) async {
    isLoading = true;
    onCallback();

    print('======================================BEGIN FETCH POST==================================================');
    final DocumentSnapshot snapshot = await _db.collection('post').doc(postId).get();
    print('======================================END FETCH POST==================================================');
    print('= ${snapshot.data()} =');
    print('======================================POST DATA==================================================');
    if (snapshot.data() != null) {
      post = Post.fromJson(snapshot.data() as Map<String, dynamic>);
      onCallback();
    }

    final value = await getComment(context, post!);
    if (value) {
      isLoading = false;
      onCallback();
    } else {
      isLoading = false;
      onCallback();
    }
  }

  getComment(BuildContext context, Post post) async {
    print('======================================BEGIN FETCH COMMENT==================================================');

    QuerySnapshot snapshot = await _db.collection('comment').where('postId', isEqualTo: post.id).get();
    print('======================================END FETCH COMMENT==================================================');
    print('= ${snapshot.docs} =');
    print('======================================COMMENT DATA==================================================');
    if (snapshot.docs.isNotEmpty) {
      commentList = snapshot.docs.map((e) => Comment.fromJson(e.data() as Map<String, dynamic>)).toList();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addLikes(String postId, String likeBy, int likeCount, VoidCallback onCallback) async {
    if (isLiked) {
      isLiked = false;
      post!.likes = post!.likes! - 1;
      onCallback();
    } else {
      isLiked = true;
      post!.likes = post!.likes! + 1;
      onCallback();
    }

    if (!isLiked) {
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

  deletePost(BuildContext context, Post post) async {
    showLoading(context);

    //DELETE POST
    print('========================================================START DELETE POST=======================================================');
    await _db.collection('post').doc(post.id).delete();
    print('========================================================END DELETE POST=======================================================');

    //DELETE POST MATERIAL
    print('========================================================START DELETE POST MATERIAL=======================================================');
    await _db.collection('post_material').doc(post.id).delete();
    QuerySnapshot postMaterialSnapshot = await _db.collection('post_material').doc(post.id).collection(post.id!).get();
    for (var postMaterial in postMaterialSnapshot.docs) {
      postMaterial.reference.delete();
    }
    print('========================================================END DELETE POST MATERIAL=======================================================');

    showSuccessDialog(context, 'Delete Success', 'Post is Removed successfully', () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  addComment(BuildContext context, Post post, String commentText, VoidCallback onCallback) async {
    showLoading(context);

    List<String> uploadedAttachment = List.empty(growable: true);

    int index = 0;
    final createdDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
    for (var attachment in attachments) {
      //UPLOAD FILE
      final uploaded =
      await uploadFile(context, File(attachments[index]), index, createdDate);
      index++;

      //REPLACE ATTACHMENTS DATA INSIDE POST COLLECTION
      uploadedAttachment.add(uploaded);
    }


    Comment newComment = Comment();
    newComment.createdDate = createdDate;
    newComment.createdBy = user!.id.toString();
    newComment.createdByName = user!.displayName;
    newComment.id = '${post.id}_$createdDate';
    newComment.lastUpdate = createdDate;
    newComment.courseBelonging = post.courseBelonging;
    newComment.notes = commentText;
    newComment.postId = post.id;
    newComment.attachments = uploadedAttachment;

    print('======================================BEGIN ADD COMMENT==================================================');

    _db.collection('comment').doc('${post.id}_$createdDate').set(newComment.toJson()).then((document) {
      print('======================================COMMENT ADDED SUCCESSFUL==================================================');
      int commentsCount = post.commentsCount! + 1;
      print('======================================UPDATE POST COMMENTS COUNT==================================================');
      _db.collection('post').doc(post.id).update({
        'commentsCount': commentsCount,
      }).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        //success handled
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(left: large_padding, right: large_padding, bottom: MediaQuery.of(context).size.height * 0.2),
          duration: Duration(milliseconds: 1000),
          content: Container(
            child: Row(
              children: [
                //Icon
                Container(
                  padding: const EdgeInsets.all(small_padding),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.done, color: Colors.white),),

                Expanded(
                  child: Text('Comment Succeed', style: GoogleFonts.poppins().copyWith(
                    color: Colors.white,
                    fontSize: SUB_TITLE,
                    fontWeight: FontWeight.bold,
                  )),
                )
              ],
            ),
          ),
        ));


        //refresh post detail screen
        refreshPost(context, onCallback);
        return true;
      }, onError: (e) {
        showInfoDialog(context, null, e.toString());
        return false;
      });

    }, onError: (e) {
      // failed handled
      showInfoDialog(context, null, e.toString());
      return false;
    });
  }


  deleteComment(BuildContext context, Comment comment) {

  }

  uploadFile(BuildContext context, File file, int index, String createdDate) async {
    print('=========================================PUTTING FILE INTO FIRECLOUD============================================');

    final TaskSnapshot uploadedFile = await _storage
        .ref()
        .child('${post!.courseBelonging}_${createdDate}_${file.path}')
        .putFile(File(attachmentsFull[index]));
    final downloadLink = await uploadedFile.ref.getDownloadURL();

    CourseMaterial courseMaterial = CourseMaterial();
    courseMaterial.materialPath = downloadLink;
    courseMaterial.materialName = file.path;
    courseMaterial.id = '${post!.courseBelonging}_${createdDate}_${file.path}';
    courseMaterial.courseBelonging = post!.courseBelonging;
    courseMaterial.createdDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
    courseMaterial.fileSize =
        File(attachmentsFull[index]).readAsBytesSync().length.toString();
    courseMaterial.materialType = file.path.isVideo
        ? 'video'
        : file.path.isImage
        ? 'image'
        : 'document';
    courseMaterial.submittedBy = accountName;
    print('===============================================ADD POST MATERIAL===================================================');
    DocumentSnapshot snapshot = await _db
        .collection('post_material')
        .doc('${post!.courseBelonging}_${createdDate}_${file.path}').get();

    List attachment = List.empty(growable: true);
    if (snapshot.data() != null) {
      attachment = (snapshot.data() as Map<String, dynamic>)['fileList'];
    }

    _db
        .collection('post_material')
        .doc('${post!.courseBelonging}_${createdDate}_${file.path}').set({
      'courseBelonging': post!.courseBelonging,
      'createdDate': post!.createdDate,
      'id': '${post!.courseBelonging}_${createdDate}_${file.path}',
      'fileList': [...attachment, '${post!.courseBelonging}_${createdDate}_${file.path}'],
      'uploadedBy': user!.id,
    });
    _db
        .collection('post_material')
        .doc('${post!.courseBelonging}_${createdDate}_${file.path}')
        .collection('${post!.courseBelonging}_${createdDate}_${file.path}')
        .doc('${post!.courseBelonging}_${createdDate}_${file.path}')
        .set(courseMaterial.toJson())
        .then((_) {}, onError: (e) {
      Navigator.of(context).pop();
    });
    return downloadLink;
  }

}