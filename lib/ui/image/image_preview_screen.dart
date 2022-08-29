import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fyp_lms/controller/image/image_preview_controller.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/custom_field/common/round_corner_image_view.dart';
import 'package:fyp_lms/web_service/model/course_material/course_material.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;

import 'package:fyp_lms/utils/dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_menu_bs.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  ImagePreviewController controller = ImagePreviewController();
  SharedPreferences? _sPref;


  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        _sPref = value;
        controller.isLoading = true;
        initialize();
      });
    });
  }

  initialize() {
    //_sPref.setString('accountInfo', jsonEncode(createdUser));
    controller.accountId = _sPref!.getString('account');
    controller.accountName = _sPref!.getString('username');
    controller.user = Account.fromJson(jsonDecode(_sPref!.getString('accountInfo')!));
    controller.accountType = _sPref!.getInt('accountType');

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    if (arguments['currentIndex'] != null) {
      controller.currentIndex = arguments['currentIndex'];
      print('hello');
    }

    if (arguments['attachments'] != null) {

      controller.attachmentListOri = arguments['attachments'];
      controller.attachmentList = arguments['attachments'].map((String attachment) {
        if (attachment.contains('http')) {
          String? path = attachment;
          String? pathCopy = attachment;
          int extensionIndex = path.indexOf('?');

          if (extensionIndex > 0) {
            if (pathCopy.substring(pathCopy.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpg' &&
                pathCopy.substring(pathCopy.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpeg' &&
                pathCopy.substring(pathCopy.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'png') {

              bool video = isVideo(attachment.substring(0, extensionIndex));

              if (!video) {
                path = path.substring(0, extensionIndex);
              }

            }
          } else {
            path = path;
          }

          return path;
        } else {
          return attachment;
        }
      }).toList();

    }

    if (arguments['course'] != null) {
      controller.course = arguments['course'];
      controller.fromCourse = true;
    }

    if (arguments['post'] != null) {
      controller.post = arguments['post'];
      controller.fromPost = true;
    }

    controller.initialization(context, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('hello1');
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 24),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: CarouselSlider.builder(
                  key: ValueKey(1),
                  itemCount: controller.attachmentList.length,
                  itemBuilder: (BuildContext context, int itemIndex, int _) {
                    String copy = controller.attachmentList[itemIndex];
                    int extensionIndex = controller.attachmentList[itemIndex].indexOf('?');
                    bool video = false;

                    if (extensionIndex > 0 ) {
                      video = isVideo(copy.substring(0, extensionIndex));
                    } else {
                      video = isVideo(copy);
                    }

                    if (controller.attachmentList[itemIndex] == null) {
                      return Container(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            RotatedBox(
                                quarterTurns: 2,
                                child: Icon(Icons.downloading,
                                    color: Colors.white, size: 46)),
                            SizedBox(height: 10),
                            Text('Uploading...',
                                style: TextStyle(fontSize: 14, color: white),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    }

                    bool isDocument = controller.attachmentList[itemIndex].toString().isDoc ||
                        controller.attachmentList[itemIndex].toString().isExcel ||
                        controller.attachmentList[itemIndex].toString().isPdf ||
                        controller.attachmentList[itemIndex].toString().isPPT ||
                        controller.attachmentList[itemIndex].toString().isTxt ||
                        p.extension(controller.attachmentList[itemIndex].toString()) == '.csv';

                    return controller.isLoading
                        ? Center(
                            child: CircularProgressIndicator(color: BG_COLOR_4))
                        : Container(
                            child: isDocument
                                ? Container(
                                    padding:
                                        EdgeInsets.only(left: 24, right: 24),
                                    alignment: Alignment.center,
                                    child: documentWidget(
                                        context,
                                        controller.attachmentList[itemIndex].toString(),
                                        controller.attachmentListOri[itemIndex].toString(),
                                    ),
                                  )
                                :
                                //HANDLE IMAGE OR VIDEO
                                !video ? controller.attachmentList[itemIndex].toString().contains('http')
                                        ? InteractiveViewer.builder(
                                            maxScale: 2.5,
                                            minScale: 1.0,
                                            scaleEnabled: true,
                                            panEnabled: true,
                                            builder: (context, viewPort) {
                                              return Image(
                                                      image: CachedNetworkImageProvider(controller.attachmentList[itemIndex].toString()),
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width)
                                                  .onTap(() {
                                                setState(() {
                                                  controller.barVisible =
                                                      !controller.barVisible;
                                                });
                                              });
                                            })
                                        : InteractiveViewer.builder(
                                            minScale: 1.0,
                                            maxScale: 2.5,
                                            scaleEnabled: true,
                                            panEnabled: true,
                                            builder: (context, viewPort) {
                                              //top left - 0, top right - 1, bottom right - 2, bottom left - 3

                                              return Image.file(
                                                      File(controller.attachmentList[itemIndex]),
                                                      fit: BoxFit.cover,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .onTap(() {
                                                setState(() {
                                                  controller.barVisible =
                                                      !controller.barVisible;
                                                });
                                              });
                                            })
                                    : videoPlayer(context, itemIndex));
                  },


                  options: CarouselOptions(
                    viewportFraction: 1,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    initialPage: controller.currentIndex,
                    onPageChanged: (index, _) {
                      controller.onChangedPage(context, index, () {
                        setState(() {});
                      });
                    },
                    height: controller.scaleImageHeight,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: controller.attachmentList.map((image) {
                      int index = controller.attachmentList.indexOf(image);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentIndex == index
                                ? Color.fromRGBO(255, 255, 255, 0.9)
                                : Color.fromRGBO(255, 255, 255, 0.4)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              controller.barVisible
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop()),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  (controller.currentIndex + 1).toString() +
                                      '  ' +
                                      'Of' +
                                      '  ' +
                                      controller.attachmentList.length
                                          .toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(10.0)),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    isDismissible: true,
                                    builder: (ctx) =>
                                        imageMenuBS(context, controller)).then(
                                    (value) async {
                                  if (value != null && value is int) {
                                    if (value == 1) {
                                      if (controller.attachmentList[controller.currentIndex] == null) {
                                        showInfoDialog(context, null, 'File not available for download');
                                        return false;
                                      }

                                      Future<bool?> savedSuccess;
                                      showLoading(context);

                                      String? pathCopy = controller.attachmentList[controller.currentIndex].toString();
                                      int? extensionIndex = !pathCopy.contains('?') ? null : pathCopy.indexOf('?');
                                      String pathCut = pathCopy.substring(0, extensionIndex);

                                      if (isVideo(pathCut)) {
                                        savedSuccess = GallerySaver.saveVideo(Uri.parse(controller.attachmentList[controller.currentIndex]).toString());
                                      } else if (pathCut.isImage) {
                                        savedSuccess = GallerySaver.saveImage(Uri.parse(controller.attachmentList[controller.currentIndex]).toString());
                                      } else {
                                        FirebaseFirestore _db = FirebaseFirestore.instance;
                                        FirebaseStorage _storage = FirebaseStorage.instance;
                                        CourseMaterial? courseMaterial;

                                        //SEARCH DOCUMENT
                                        if (controller.fromCourse) {
                                          DocumentSnapshot reference = await _db.collection('course_material')
                                              .doc(controller.course!.id)
                                              .get();

                                          if (reference.data() != null) {
                                            String id = (reference.data() as Map<String, dynamic>)['fileList'][controller.currentIndex];
                                            DocumentSnapshot material = await _db.collection('course_material').doc(controller.course!.id).collection(controller.course!.id!).doc(id).get();

                                            if (material.data() != null) {
                                              courseMaterial = CourseMaterial.fromJson(material.data() as Map<String, dynamic>);
                                            }
                                          }
                                        } else {
                                          DocumentSnapshot reference = await _db.collection('post_material').doc(controller.post!.id).get();

                                          if (reference.data() != null) {
                                            String id = (reference.data() as Map<String, dynamic>)['fileList'][controller.currentIndex];
                                            DocumentSnapshot postMaterial = await _db.collection('post_material').doc(controller.post!.id).collection(controller.post!.id!).doc(id).get();

                                            if (postMaterial.data() != null) {
                                              courseMaterial = CourseMaterial.fromJson(postMaterial.data() as Map<String, dynamic>);
                                            }
                                          }
                                        }
                                        String downloadedLink = await _storage.ref(courseMaterial!.id).getDownloadURL();

                                        await launch(downloadedLink);
                                        savedSuccess = Future.value(true);
                                      }
                                      Navigator.of(context).pop();

                                      savedSuccess.then((success) {
                                        if (success != null && success) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(milliseconds: 500),
                                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1, left: large_padding, right: large_padding),
                                            content: Container(),
                                          ));

                                          // Get.snackbar('copied'.tr, 'address_copied'.tr,
                                          //     snackPosition: SnackPosition.BOTTOM,
                                          //     snackStyle: SnackStyle.FLOATING,
                                          //     backgroundColor: Colors.green,
                                          //     titleText: text('download_title'.tr, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                          //     messageText: text('download_desc'.tr, style: TextStyle(color: Colors.white, fontSize: 12)));
                                        } else {}
                                      });
                                    } else if (value == 2) {
                                      Share.share(Uri.encodeFull(controller.attachmentList[controller.currentIndex]));
                                    }
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          )),
    );
  }

  Widget videoPlayer(BuildContext context, int itemIndex) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: controller.customVideoPlayerController[itemIndex] == null
            ? SizedBox()
            : Chewie(
                controller: controller.customVideoPlayerController[itemIndex]!,
              ),
      ),
    );
  }

  Widget documentWidget(BuildContext context, String path, String oriPath) {
    //doc, docx, xls, xlsx, ppt, pptx, .txt, .csv, .pdf
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          getDocIcon(path),
          width: 80,
          height: 80,
        ),
        SizedBox(height: 10),
        Text(p.basename(path),
            style: TextStyle(fontSize: 14, color: white),
            textAlign: TextAlign.center),
      ],
    ).onTap(() async {

      String encodedPath = Uri.encodeFull(oriPath);
      if (encodedPath.contains('http')) {
        await canLaunch(encodedPath)
            ? await launch(encodedPath)
            : showInfoDialog(context, null, 'Could not launch $oriPath');
      } else {
        OpenFile.open(oriPath);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

String getDocIcon(String path) {
  if (p.extension(path) == '.pdf') {
    return 'assets/document/pdf.svg';
  } else if (p.extension(path) == '.doc' || p.extension(path) == '.docx') {
    return 'assets/document/doc.svg';
  } else if (p.extension(path) == '.xls' ||
      p.extension(path) == '.xlsx' ||
      p.extension(path) == '.csv') {
    return 'assets/document/xls.svg';
  } else if (p.extension(path) == '.ppt' || p.extension(path) == '.pptx') {
    return 'assets/document/ppt.svg';
  } else if (p.extension(path) == '.txt') {
    return 'assets/document/txt.svg';
  } else {
    return 'assets/document/txt.svg';
  }
}

isVideo(String path) {
  String video = r'.(mp4|MP4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv|mov|MOV)$';
  return hasMatch(path, video);
}
