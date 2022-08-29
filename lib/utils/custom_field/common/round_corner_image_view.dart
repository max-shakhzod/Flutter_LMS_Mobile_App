import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';



Widget roundCornerImage(
    String path,
    Function(String path) onDelete,
    {var size = 70.0, var space = 6, var showDelete = true}){


  return Stack(
    children: [
      AbsorbPointer(
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!,width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(11))),
          margin: EdgeInsets.only(right: 6),
          child: imageWidget(path, size),
        ),
      ),

      showDelete ? Positioned(
        child: Container(
          height: 24,
          width: 24,
          alignment: Alignment.topRight,

          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
            ),
            child: Icon(
              Icons.cancel,
              color: Colors.red,
              size: 20,
            ),
          ).onTap((){
            onDelete(path);
          }),
        ),
        top: 3.5,
        right: 9.5,
      ) : SizedBox(),
    ],
  );
}

Widget imageWidget(String mPath,double size) {

  if (mPath.contains('http')) {
    String path = mPath;
    String path2 = mPath;
    String path3 = mPath;
    bool video = false;

    int extensionIndex = path.indexOf('?');

    if (extensionIndex > 0) {
      if (path2.substring(path2.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpg' &&
          path2.substring(path2.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'jpeg' &&
          path2.substring(path2.indexOf('.', extensionIndex - 5) + 1, extensionIndex) != 'png') {

        video = isVideo(path3.substring(0, extensionIndex));
      }
    } else {
      video = isVideo(path3);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Stack(
        children: [
          video ? Container(color: Colors.grey) : Image(
              image: CachedNetworkImageProvider(mPath),
              width: size,
              height: size,
              fit: BoxFit.cover),

          //DISPLAY PLAY ICON ON THE VIDEO THUMBNAIL
          video ? Positioned(
            child: Center(child: Icon(Icons.play_circle_outline, color: Colors.grey[600], size: 30)),
          ) : SizedBox(),
        ],
      ),
    ).onTap(() async {
      FocusManager.instance.primaryFocus!.unfocus();
    });
  }else{
    if(mPath.isEmpty){
      return ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
              width: size,
              height: size
          ));
    }else{
      return ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          children: [
            isVideo(mPath) ? Container(color: Colors.grey) : Image.file(File(mPath), width: size, height: size, fit: BoxFit.cover),

            isVideo(mPath) ? Positioned(
              child: Center(child: Icon(Icons.play_circle_outline, color: Colors.grey[600], size: 30)),
            ) : SizedBox(),
          ],
        ),
      ).onTap(() async {
        FocusManager.instance.primaryFocus!.unfocus();
      });
    }

  }


}

isVideo(String path){
  String video = r'.(mp4|MP4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv|mov|MOV)$';
  return hasMatch(path, video);
}