import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/course/course_material_controller.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/custom_field/common/round_corner_document_view.dart';
import 'package:fyp_lms/utils/custom_field/common/round_corner_image_view.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as p;

class CourseMaterialScreen extends StatefulWidget {
  const CourseMaterialScreen({Key? key}) : super(key: key);

  @override
  State<CourseMaterialScreen> createState() => _CourseMaterialPageState();
}

class _CourseMaterialPageState extends State<CourseMaterialScreen> {
  CourseMaterialController controller = CourseMaterialController();
  SharedPreferences? _sPref;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      _sPref = value;

      initialization();
    });

  }

  Future<void> initialization() async {
    controller.accountId = _sPref!.getString('account');
    controller.accountName = _sPref!.getString('username');
    controller.user = Account.fromJson(jsonDecode(_sPref!.getString('accountInfo')!));
    controller.accountType = _sPref!.getInt('accountType');

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['course'] != null) {
      controller.course = arguments['course'];
    }

    setState(() {
      controller.isLoading = true;
    });

    controller.getUploadedMaterial(context).then((value) {
      if (value) {
        setState(() {
          controller.isLoading = false;
        });
        return true;
      } else {
        setState(() {
          controller.isLoading = false;
        });
        showInfoDialog(context, null, 'Some unexpected error occurred.', callback: () {
          Navigator.of(context).pop();
        });
        return false;
      }

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body:controller.isLoading ? Center(child: CircularProgressIndicator(color: BG_COLOR_4,),) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(left: x_large_padding, top: x_large_padding, bottom: normal_padding),
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, size: 22.0),
                ),
                Text('Uploaded File', style: GoogleFonts.poppins().copyWith(
                  fontSize: TITLE,
                  fontWeight: FontWeight.w600,
                ),),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => initialization(),
              displacement: 60,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.dateList.length,
                itemBuilder: (BuildContext context, int index) {
                  print(controller.dateList[index]);
                  return Container(
                    margin: const EdgeInsets.only(left: x_large_padding, top: small_padding, bottom: small_padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Date
                        Text(DateUtil().getDateFormatDisplay().format(DateTime.parse(controller.dateList[index])), style: GoogleFonts.poppins().copyWith(
                          fontWeight: FontWeight.w600,
                        ),),

                        Container(
                          margin: const EdgeInsets.only(bottom: small_padding),
                          width: 80,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        ),

                        //Display attachment
                        Container(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.uploadedMaterialList[controller.dateList[index]].length,
                                itemBuilder: (BuildContext context, int attachmentIndex) {

                                  CourseMaterial courseMaterial = controller.uploadedMaterialList[controller.dateList[index]][attachmentIndex];

                                  String? path = courseMaterial.materialPath;
                                  String? pathCopy = courseMaterial.materialPath;

                                  int extensionIndex = path!.indexOf('?');
                                  if (pathCopy!.substring(pathCopy.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpg' &&
                                      pathCopy.substring(pathCopy.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpeg' &&
                                      pathCopy.substring(pathCopy.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'png') {
                                    path = path.substring(0, extensionIndex);
                                  }

                                  //RENDER DOC VIEW
                                  return path.isDoc || path.isExcel || path.isPdf || path.isPPT || path.isTxt || p.extension(path) == '.csv' ?
                                  roundCornerDocument(path, (path) {}, size: 100.0, space:6, showDelete: false).onTap(() async {
                                    if(path!.contains('http')){
                                      // FirebaseFirestore _db = FirebaseFirestore.instance;
                                      // FirebaseStorage _storage = FirebaseStorage.instance;
                                      // CourseMaterial? courseMaterial;
                                      //
                                      // final QuerySnapshot postMaterialSnapshot = await _db.collection('post_material').where('uploadedBy', isEqualTo: controller.accountId).get();
                                      //
                                      // if (postMaterialSnapshot.docs.isNotEmpty) {
                                      //
                                      // }
                                      // if (reference.data() != null) {
                                      //   String id = (reference.data() as Map<String, dynamic>)['fileList'][attachmentIndex];
                                      //   DocumentSnapshot postMaterial = await _db.collection('post_material').doc(controller.post!.id).collection(controller.post!.id!).doc(id).get();
                                      //
                                      //   if (postMaterial.data() != null) {
                                      //     courseMaterial = CourseMaterial.fromJson(postMaterial.data() as Map<String, dynamic>);
                                      //   }
                                      // }
                                      //
                                      // String downloadedLink = await _storage.ref(courseMaterial!.id).getDownloadURL();


                                      await launch(controller.attachmentsLink[attachmentIndex]);
                                    }else {
                                      OpenFile.open(controller.attachmentsLink[attachmentIndex]);
                                    }
                                  }) :
                                  //RENDER IMAGE VIEW
                                  roundCornerImage(path, (path) {}, size: 100.0, space: 6, showDelete: false).onTap(() {
                                    Navigator.of(context).pushNamed('/ImagePreviewScreen', arguments: {
                                      'attachments': controller.attachmentsLink,
                                      'currentIndex': attachmentIndex,
                                    });
                                  });
                                }
                            )
                        )

                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
  }
}
