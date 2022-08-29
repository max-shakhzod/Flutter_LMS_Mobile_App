import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/post/post_detail_controller.dart';
import 'package:nb_utils/nb_utils.dart';


Widget postMenuBS (BuildContext context, PostDetailController controller){

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
                  Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Course Edit',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600
                              ))
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Edit the Course detail',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey
                              ))
                      ),
                    ],
                  )
                ],
              ),
            ).onTap((){
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
                  Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Delete',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ))
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Delete this course.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.redAccent,
                            ),)
                      ),
                    ],
                  )
                ],
              ),
            ).onTap(() {
              Navigator.of(context).pop(2);
            }),

            Divider(
              height: 1,
              indent: 10,
              endIndent: 10,
            ),

          ],
        ),
      ),
    ),
  );

}