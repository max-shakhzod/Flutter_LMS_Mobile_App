import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/custom_field/common/round_corner_document_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

import '../../constant.dart';
import '../../dialog.dart';
import '../common/round_corner_image_view.dart';

//ADD ATTACHMENT

Widget attachmentField(
    BuildContext context,
    dynamic controller,
    String? label,
    List<String> attachmentItem,
    List<String> attachmentsFull,
    VoidCallback onChanged,
    {Key? key, IconData? fieldIcon, bool editable = true}) {

  List<String> attachmentList = attachmentItem;

  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        margin: const EdgeInsets.only(top: large_padding, bottom: large_padding),
        padding: EdgeInsets.only(top: 12, left: 14, right: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.attachment,
              color: Colors.grey,
              size: 18,
            ),
            SizedBox(width: 10),
            Expanded(
                child: RichText(
                    text: TextSpan(
                        text: label,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SUB_TITLE,
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
            Container(
              height: 28,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: BG_COLOR_3,
                  borderRadius: BorderRadius.circular(6.0)),
              child: Text('+ Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ).onTap(() async {
                FilePickerResult? pickResult = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                    allowMultiple: true,
                );

                if (pickResult != null) {
                  pickResult.files.forEach((file) {
                    attachmentsFull.add(file.path!);
                    attachmentList.add(file.name);
                    onChanged();
                  });
                }
            })
          ],
        ),
      ),

      getDisplayWidget(controller.attachmentsFull, controller, editable, onChanged),
      Container(height: 10,color: Colors.white,)

    ],
  );
}

Widget getDisplayWidget(List<String> attachmentList, dynamic controller, editable, VoidCallback onChanged) {
  return attachmentList.isEmpty ? SizedBox(height: 0) : Container(
    alignment: Alignment.topLeft,
    color: Colors.white,
    height: 90,
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachmentList.length,
        itemExtent: 76,
        padding: EdgeInsets.only(left: 14, right: 4),
        itemBuilder: (context, index) {

          String path = attachmentList[index];
          String pathCopy = attachmentList[index];
          String path2 = controller.attachments[index];

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
          roundCornerDocument(path, (path) {
            if(!editable){
              showInfoDialog(context, null, 'This file is uneditable');
              return;
            }

            attachmentList.remove(path);
            controller.attachments.remove(path2);
            onChanged();
          }).onTap(() async {
            OpenFile.open(path);
          }) :
          //RENDER IMAGE VIEW
          roundCornerImage(path, (path) {

            if(!editable){
              showInfoDialog(context, null, 'This file is uneditable');
              return;
            }
            attachmentList.remove(path);
            controller.attachments.remove(path2);
            onChanged();

          }, size: 70.0, space: 6).onTap(() {
            Navigator.of(context).pushNamed('/ImagePreviewScreen', arguments: {
              'attachments': attachmentList,
              'currentIndex': index,
            });
          });
        }),
  );
}



isVideo(String path){
  String video = r'.(mp4|MP4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv|mov|MOV)$';
  return hasMatch(path, video);
}

