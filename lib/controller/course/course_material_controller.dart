import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fyp_lms/web_service/model/course/course.dart';
import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:flutter/material.dart';

class CourseMaterialController {
  //================================================VARIABLES======================================================
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  String? accountId;
  String? accountName;
  int? accountType;
  Account? user;

  Course? course;

  bool isLoading = false;

  Map<String, dynamic> uploadedMaterialList = {};
  List<String> dateList = List.empty(growable: true);
  List<String> attachmentsLink = List.empty(growable: true);

  //==================================================METHODS======================================================

  Future<bool> getUploadedMaterial(BuildContext context) async {
    dateList.clear();
    attachmentsLink.clear();
    uploadedMaterialList.clear();

    print('====================================FETCH COURSE MATERIAL========================================');
    final QuerySnapshot courseMaterialSnapshot = await _db.collection('course_material').where('courseBelonging', isEqualTo: course!.id).orderBy('createdDate', descending: true).get();

    print('====================================COURSE MATERIAL DATA========================================');
    print('= ${courseMaterialSnapshot.docs} =');

    if (courseMaterialSnapshot.docs.isNotEmpty) {
      //FIND ALL REFERENCE FROM THE SNAPSHOT
      for (var documentSnapshot in courseMaterialSnapshot.docs) {
        print('=======================================COURSE MATERIAL DATA===========================================');
        print('= ${documentSnapshot.data()} =');

        String id = (documentSnapshot.data() as Map<String, dynamic>)['id'];
        String uploadedBy = (documentSnapshot.data() as Map<String, dynamic>)['uploadedBy'];
        String createdDate = (documentSnapshot.data() as Map<String, dynamic>)['createdDate'];
        dateList.add(createdDate);

        print('====================================GET COURSE MATERIAL DETAILS DATA========================================');
        final fileMaterialSnapshot = await _db.collection('course_material').doc(id).collection(id).get();
        print('====================================END COURSE MATERIAL DETAILS DATA========================================');
        print('= ${fileMaterialSnapshot.docs} =');
        print('====================================COURSE MATERIAL DETAILS DATA============================================');

        if (fileMaterialSnapshot.docs.isNotEmpty) {
          List<CourseMaterial> fileReference = List.empty(growable: true);
          for (var fileSnapshot in fileMaterialSnapshot.docs) {
            print('====================================COURSE MATERIAL DETAILS============================================');
            print('= ${fileSnapshot.data()}=');
            CourseMaterial courseMaterial = CourseMaterial.fromJson(fileSnapshot.data());
            fileReference.add(courseMaterial);
            attachmentsLink.add(courseMaterial.materialPath!);
          }
          uploadedMaterialList[createdDate] = fileReference;
        }

        print('====================================COMPLETE PROCESS========================================');
      }
      return true;
    } else {
      return false;
    }

    return false;
  }
}