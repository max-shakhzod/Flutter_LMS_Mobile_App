import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:nb_utils/nb_utils.dart';

Widget roundCornerDocument(
    String path,
    Function(String path) onDelete,
    {var size = 80.0,
      space = 6.0,
      iconSize = 35.0,
      showDelete = true}) {
  return Stack(
    children: [
      AbsorbPointer(
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!,width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(11))),
          margin: EdgeInsets.only(right: 6),
          child: documentWidget(path, size, iconSize),
        ),
      ),

      showDelete ?
      Positioned(
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
      ) : SizedBox()

    ],
  );
}

Widget documentWidget(String path, double size, double iconSize) {

  //doc, docx, xls, xlsx, ppt, pptx, .txt, .csv, .pdf
  return Container(
    margin: EdgeInsets.only(top: 6.0),
    width: size,
    height: size,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          getDocIcon(path),
          width: iconSize,
          height: iconSize,
        ),
        Padding(
          padding: EdgeInsets.all(4),
          child: Text(p.basename(path), style: TextStyle(
              fontSize: 9), overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

}

String getDocIcon(String path){
  if (p.extension(path) == '.pdf') {
    return 'assets/document/pdf.svg';
  } else if (p.extension(path) == '.doc' || p.extension(path) == '.docx') {
    return 'assets/document/doc.svg';
  } else if (p.extension(path) == '.xls' || p.extension(path) == '.xlsx' || p.extension(path) == '.csv') {
    return 'assets/document/xls.svg';
  } else if (p.extension(path) == '.ppt' || p.extension(path) == '.pptx') {
    return 'assets/document/ppt.svg';
  } else if (p.extension(path) == '.txt') {
    return 'assets/document/txt.svg';
  } else {
    return 'assets/document/txt.svg';
  }
}