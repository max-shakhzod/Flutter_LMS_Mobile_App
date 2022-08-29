import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:fyp_lms/controller/dashboard/course_listing_controller.dart';

import '../../utils/dialog.dart';

Widget courseListingBS(BuildContext context, CourseListingController controller, Function setState) {

  return Material(
    color: Colors.transparent,
    child: GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          margin: const EdgeInsets.all(large_padding),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: x_large_padding),
                child: Center(
                  child: Text(
                    'Enter Course Code',
                    style: GoogleFonts.poppins().copyWith(
                      fontSize: TITLE,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
              ),

              StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.all(large_padding),
                    child: TextField(
                      controller: controller.addCourseCode,
                      onChanged: (newValue){
                        setState(() {});
                      },
                      style: GoogleFonts.poppins().copyWith(
                          fontSize: 14, color: Colors.black
                      ),
                      minLines: 1,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 12),
                          suffixIcon: controller.addCourseCode.text.isEmpty ? null :
                          IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.cancel),
                            onPressed: (){
                              controller.addCourseCode.text = '';
                              setState(() {});
                            },
                          )
                      ),
                    ),
                  );
                }
              ),
              Divider(
                height: 1,
                indent: 10,
                endIndent: 10,
              ),

              Container(
                margin: const EdgeInsets.only(bottom: large_padding),
                padding: const EdgeInsets.only(left: x_large_padding, right: x_large_padding, top: normal_padding, bottom: normal_padding),
                width: MediaQuery.of(context).size.width * 0.5,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BG_COLOR_4,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text('Join Course', style: GoogleFonts.poppins().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
              ).onTap(() {
                Navigator.of(context).pop();
                controller.joinCourse(context, controller.addCourseCode.text).then((_) {
                  controller.fetchCurrentCourse(() {
                    setState(() {});
                  });


                }, onError: (e) {
                  print(e.toString());
                  if (e == 'elementExists') {
                    showInfoDialog(context, null, 'Course is already exists', callback: () {
                      Navigator.of(context).pop();
                    });
                  }
                });
              }),

            ],
          ),
        ),
      ),
    ),
  );

}