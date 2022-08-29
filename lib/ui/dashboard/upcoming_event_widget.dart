import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/general_utils.dart';
import 'package:fyp_lms/web_service/model/course/course.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:fyp_lms/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

Widget upcomingEventWidget(BuildContext context, pageController, Course course, Map<String, dynamic> date) {
  return Container(
    margin: const EdgeInsets.only(left: large_padding, right: large_padding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      boxShadow: const [
        BoxShadow(
          color: COLOR_INVALID,
          offset: Offset(1.5, 1.5),
          blurRadius: 5,
        ),
      ],
    ),
    child: Container(
      padding: const EdgeInsets.all(large_padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)],
            pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)].withOpacity(0.95),
            pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)].withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [
            0.0,
            0.8,
            1.0,
          ],
        ),
        //image: DecorationImage(image: AssetImage('assets/course_icon.png'), fit: BoxFit.cover, opacity: 0.3),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: normal_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Course Name: ', style: GoogleFonts.poppins().copyWith(
                    fontWeight: FontWeight.w600,
                    color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                    fontSize: TITLE,
                  )),
                  Text(course.courseName!, style: GoogleFonts.poppins().copyWith(
                    color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                  )),
                  const SizedBox(width: normal_padding),

                  Text('Course Code: ', style: GoogleFonts.poppins().copyWith(
                    fontWeight: FontWeight.w600,
                    color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                    fontSize: TITLE,
                  )),
                  Text(course.courseCode!, style: GoogleFonts.poppins().copyWith(
                    color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                  )),

                  const SizedBox(height: x_large_padding),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Time: ', style: GoogleFonts.poppins().copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: SUB_TITLE,
                              color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                            )),
                            const SizedBox(width: 2.0),

                            Text(date['date'] + ' ' + date['duration'].substring(0,5) + '-' + date['duration'].substring(11,16), style: GoogleFonts.poppins().copyWith(
                              fontSize: SUB_TITLE,
                              color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                            ), softWrap: true,),

                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Venue: ', style: GoogleFonts.poppins().copyWith(
                            fontWeight: FontWeight.w600,
                            color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                          )),
                          const SizedBox(width: 2.0),

                          Text(course.venue!, style: GoogleFonts.poppins().copyWith(
                            fontSize: SUB_TITLE,
                            color: GeneralUtil().getTextColor(pageController.colorSelectionColor[pageController.colorSelection.indexOf(course.color!)]),
                          ), softWrap: true,),

                        ],
                      ),
                      const SizedBox(width: large_padding),
                    ],
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: x_large_padding, right: x_large_padding, top: normal_padding),
                    padding: const EdgeInsets.only(top: normal_padding, bottom: normal_padding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Center(
                      child: Text('View More', style: GoogleFonts.poppins().copyWith(
                        fontSize: SUB_TITLE,
                      ),
                      ),
                    ),
                  ).onTap(() {
                    Navigator.of(context).pushNamed('/CourseDetailScreen', arguments: {
                      'course': course,
                    });
                  })
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}