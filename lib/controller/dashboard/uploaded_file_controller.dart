import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';

class UploadedFileController {
  //================================================VARIABLES======================================================
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  String? accountId;
  String? accountName;
  int? accountType;
  Account? user;

  bool isLoading = false;

  Map<String, dynamic> uploadedMaterialList = {};
  List<String> dateList = List.empty(growable: true);
  List<String> attachmentsLink = List.empty(growable: true);

  //==================================================METHODS======================================================

  Future<bool> getUploadedMaterial(BuildContext context) async {
    dateList.clear();
    attachmentsLink.clear();
    uploadedMaterialList.clear();

    print('====================================FETCH POST MATERIAL========================================');
    print('= AccountId: ${accountId} =');
    final QuerySnapshot postMaterialSnapshot = await _db.collection('post_material').where('uploadedBy', isEqualTo: accountId).get();

    print('====================================POST MATERIAL DATA========================================');
    print('= ${postMaterialSnapshot.docs} =');

    if (postMaterialSnapshot.docs.isNotEmpty) {
      //FIND ALL REFERENCE FROM THE SNAPSHOT
      for (var documentSnapshot in postMaterialSnapshot.docs) {
        print('=======================================POST MATERIAL DATA===========================================');
        print('= ${documentSnapshot.data()} =');
        String id = (documentSnapshot.data() as Map<String, dynamic>)['id'];
        String uploadedBy = (documentSnapshot.data() as Map<String, dynamic>)['uploadedBy'];
        String createdDate = (documentSnapshot.data() as Map<String, dynamic>)['createdDate'];
        dateList.add(createdDate);

        print('====================================GET POST MATERIAL DETAILS DATA========================================');
        final fileMaterialSnapshot = await _db.collection('post_material').doc(id).collection(id).get();
        print('====================================END POST MATERIAL DETAILS DATA========================================');

        if (fileMaterialSnapshot.docs.isNotEmpty) {
          List<CourseMaterial> fileReference = List.empty(growable: true);
          for (var fileSnapshot in fileMaterialSnapshot.docs) {
            print('====================================POST MATERIAL DETAILS============================================');
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