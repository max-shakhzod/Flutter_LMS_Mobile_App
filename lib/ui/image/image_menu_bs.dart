import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/image/image_preview_controller.dart';
import 'package:nb_utils/nb_utils.dart';

Widget imageMenuBS(BuildContext context, ImagePreviewController controller) {
  return GestureDetector(
    onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },
    child: SingleChildScrollView(
      child: Container(
        //color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.drag_handle,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(top: 13, bottom: 10, left: 10),
              child: Row(
                children: [
                  Container(
                    child: Icon(
                      Icons.download,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10, top: 2, bottom: 2),
                      child: Text('Download',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600))),
                ],
              ),
            ).onTap(() {
              Navigator.of(context).pop(1);
            }),
            Divider(
              height: 1,
              indent: 10,
              endIndent: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 13, bottom: 10, left: 10),
              child: Row(
                children: [
                  Container(
                    child: Icon(
                      Icons.share,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 14, top: 4, bottom: 4),
                      child: Text('Share',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600))),
                ],
              ),
            ).onTap(() {
              Navigator.of(context).pop(2);
            }),
          ],
        ),
      ),
    ),
  );
}
