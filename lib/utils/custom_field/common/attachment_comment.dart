import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/course/course_detail_controller.dart';
import 'package:fyp_lms/controller/post/post_detail_controller.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/custom_field/common/round_corner_document_view.dart';
import 'package:fyp_lms/utils/custom_field/common/round_corner_image_view.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:fyp_lms/utils/general_utils.dart';
import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

//ATTACHMENT DISPLAY

Widget attachmentComment(
    BuildContext context,
    commentAttachment,
    dynamic controller){

  List<dynamic> attachmentList = commentAttachment;

  return attachmentList.isEmpty ? Container(
    alignment: Alignment.topLeft,
    height: 120,
    child: Container(
      height: 120.0,
      width: 120.0,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!,width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(11))),
      margin: EdgeInsets.only(right: 6),
      padding: EdgeInsets.only(left: small_padding, right: small_padding, top: large_padding, bottom: large_padding),
      child: Column(
        children: const [
          Icon(Icons.priority_high_rounded),
          SizedBox(height: normal_padding),
          Text('No Attachment'),
        ],
      ),
    ),
  ) : Container(
    alignment: Alignment.topLeft,
    height: 60,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachmentList.length,
        itemExtent: 56,
        padding: EdgeInsets.only(left: 14, right: 14),
        physics: attachmentList.length <= 6 ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          String path = attachmentList[index];
          String pathCopy = attachmentList[index];
          String path2 = attachmentList[index];

          if (attachmentList[index].contains('http')) {
            int extensionIndex = path.indexOf('?');
            if (path2.substring(path2.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpg' &&
                path2.substring(path2.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpeg' &&
                path2.substring(path2.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'png') {

              bool video = isVideo(pathCopy.substring(0, extensionIndex));

              if (!video) {
                path = path.substring(0, extensionIndex);
              }

            }
          }

          //RENDER DOC VIEW
          return path.isDoc || path.isExcel || path.isPdf || path.isPPT || path.isTxt || p.extension(path) == '.csv' ?
          roundCornerDocument(path, (path) => null, size: 50.0, iconSize: 20.0, showDelete: false).onTap(() async {

            if(path.contains('http')){
              FirebaseFirestore _db = FirebaseFirestore.instance;
              FirebaseStorage _storage = FirebaseStorage.instance;
              CourseMaterial? courseMaterial;

              //SEARCH DOCUMENT
              if (controller is CourseDetailController) {
                DocumentSnapshot reference = await _db.collection('course_material')
                    .doc(controller.course!.id)
                    .get();

                if (reference.data() != null) {
                  String id = (reference.data() as Map<String, dynamic>)['fileList'][index];
                  DocumentSnapshot material = await _db.collection('course_material').doc(controller.course!.id).collection(controller.course!.id!).doc(id).get();

                  if (material.data() != null) {
                    courseMaterial = CourseMaterial.fromJson(material.data() as Map<String, dynamic>);
                  }
                }
              } else {
                DocumentSnapshot reference = await _db.collection('post_material')
                    .doc(controller.post!.id)
                    .get();

                if (reference.data() != null) {
                  String id = (reference.data() as Map<String, dynamic>)['fileList'][index];
                  DocumentSnapshot postMaterial = await _db.collection('post_material').doc(controller.post!.id).collection(controller.post!.id!).doc(id).get();

                  if (postMaterial.data() != null) {
                    courseMaterial = CourseMaterial.fromJson(postMaterial.data() as Map<String, dynamic>);
                  }
                }
              }

              String downloadedLink = await _storage.ref(courseMaterial!.id).getDownloadURL();

              await launch(downloadedLink);
            }else {
              OpenFile.open(attachmentList[index]);
            }

          }) :
          //RENDER IMAGE VIEW
          roundCornerImage(path, (path) => null, size: 50.0, space: 6, showDelete: false).onTap(() {
            Navigator.of(context).pushNamed('/ImagePreviewScreen', arguments: {
              'attachments': attachmentList,
              'currentIndex': index,
              'course': controller.course,
              'post': controller.post,
            });
          });
        }),
  );
}