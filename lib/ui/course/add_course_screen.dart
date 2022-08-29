import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/course/add_course_controller.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/custom_field/input/datetime_field.dart';
import 'package:fyp_lms/utils/custom_field/input/dropdown_field.dart';
import 'package:fyp_lms/utils/custom_field/input/number_input_field.dart';
import 'package:fyp_lms/utils/custom_field/input/text_input_field.dart';
import 'package:fyp_lms/utils/custom_field/input/textarea_input_field.dart';
import 'package:fyp_lms/utils/custom_field/input/time_range_field.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../web_service/model/course/course.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  AddCourseController controller = AddCourseController();
  SharedPreferences? _sPref;

  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController courseDescription = TextEditingController();
  TextEditingController timeStart = TextEditingController();
  TextEditingController timeEnd = TextEditingController();
  TextEditingController courseOverview = TextEditingController();
  TextEditingController courseAnnouncement = TextEditingController();
  TextEditingController courseMidtermDate = TextEditingController();
  TextEditingController courseAssignmentDate = TextEditingController();
  TextEditingController courseFinal = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController courseVenue = TextEditingController();
  TextEditingController studentEnrolled = TextEditingController();

  int colorSelection = 0;

  String? timeStartDisplay;
  String? timeEndDisplay;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _sPref = value;
        initializeData();
      });
    });

    colorController.text = controller.courseColorSelection[0];
    timeStartDisplay = DateUtil().getDatetimeFormatServer().format(DateTime.now());
    timeEndDisplay = DateUtil().getDatetimeFormatServer().format(DateTime.now().add(Duration(hours: 2)));
    controller.courseMidtermDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
    controller.courseAssignmentDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
    controller.courseFinalDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
  }

  initializeData() {
    //_sPref.setString('accountInfo', jsonEncode(createdUser));

    controller.assignedTo = _sPref!.getString('account');
    controller.assignedToName = _sPref!.getString('username');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
      if (arguments['course'] != null) {
        setState(() {
          controller.isEdit = true;
          Course course = arguments['course'];
          controller.courseId = course.id;
          controller.course = course;
          controller.populateData(course);

          codeController.text = course.courseCode!;
          nameController.text = course.courseName!;
          courseDescription.text = course.courseDescription!;
          timeStart.text = course.courseHour![0];
          timeEnd.text = course.courseHour![1];

          DateTime now = DateTime.now();
          List<String> start = course.courseHour![0].split(':');
          List<String> end = course.courseHour![1].split(':');
          timeStartDisplay = DateUtil().getDatetimeFormatServer().format(DateTime(now.year,now.month,now.day,int.tryParse(start[0])!,int.tryParse(start[1])!));
          timeEndDisplay = DateUtil().getDatetimeFormatServer().format(DateTime(now.year,now.month,now.day,int.tryParse(end[0])!,int.tryParse(end[1])!));

          courseOverview.text = course.courseOverview!;
          courseAnnouncement.text = course.courseAnnouncement!;
          courseMidtermDate.text = DateUtil().getDatetimeFormatDisplay().format(DateTime.parse(course.courseMidtermDate!));
          courseAssignmentDate.text = DateUtil().getDatetimeFormatDisplay().format(DateTime.parse(course.courseAssignmentDate!));
          courseFinal.text = DateUtil().getDatetimeFormatDisplay().format(DateTime.parse(course.courseFinal!));
          colorController.text = course.color!;
          controller.color = controller.courseColorSelectionColor[controller.courseColorSelection.indexOf(course.color!)];
          courseVenue.text = course.venue!;
          studentEnrolled.text = course.studentEnrolled!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: controller.color ?? BG_COLOR_4,
        leading: Icon(Icons.arrow_back, color: Colors.white,).onTap(() {
          Navigator.of(context).pop();
        }),
        centerTitle: true,
        title: Text(controller.isEdit ? 'Edit Course' : 'Add New Course', style: GoogleFonts.poppins().copyWith(
          fontSize: TITLE,
          fontWeight: FontWeight.bold,
        ),),
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.all(normal_padding),
            alignment: Alignment.center,
            child: Text('Done', style: GoogleFonts.poppins().copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          ).onTap(() {
            controller.compileData(
              context,
              codeController.text,
              nameController.text,
              courseDescription.text,
              courseOverview.text,
              courseAnnouncement.text,
              courseMidtermDate.text,
              courseAssignmentDate.text,
              courseFinal.text,
              colorSelection,
              timeStartDisplay!,
              timeEndDisplay!,
              courseVenue.text,
              studentEnrolled.text,
            );
          })
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.color ?? BG_COLOR_4,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(10.0),
                  //   bottomRight: Radius.circular(10.0),
                  // ),
                ),
                padding: const EdgeInsets.all(large_padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //CODE
                    Text('Course Code:', style: GoogleFonts.poppins().copyWith(
                      fontSize: TITLE,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),),
                    //TextField
                    Container(
                        margin: const EdgeInsets.all(normal_padding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: codeController,
                          onChanged: (value) {
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
                              suffixIcon: codeController.text.isEmpty ? null :
                              IconButton(
                                iconSize: 20,
                                icon: const Icon(Icons.cancel),
                                onPressed: (){
                                  setState(() {
                                    codeController.text = '';
                                  });
                                },
                              )
                          ),
                        )
                    ),
                    const SizedBox(height: 7),


                    //TITLE
                    Text('Course Name:', style: GoogleFonts.poppins().copyWith(
                      fontSize: TITLE,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),),
                    //TextField
                    Container(
                      margin: const EdgeInsets.all(normal_padding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: nameController,
                        onChanged: (value) {
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
                            suffixIcon: nameController.text.isEmpty ? null :
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.cancel),
                              onPressed: (){
                                setState(() {
                                  nameController.text = '';
                                });
                              },
                            )
                        ),
                      )
                    ),
                  ],
                )
              ),
              const SizedBox(height: 7),

              //ASSIGNED_TO
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 7),
                padding: EdgeInsets.only(top: 12, left: 14, bottom: 12, right: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_pin_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(('Assigned To'.toUpperCase()),
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 7),
                            //ASSIGNED CHIP VIEW
                            Container(
                                width: 110,
                                margin: EdgeInsets.only(right: small_padding, top: small_padding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[200]!),
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey[200],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        height: 17,
                                        width: 17,
                                        margin: EdgeInsets.only(right: 5, left: 4, top: 4, bottom: 4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.pink,
                                        ),
                                        child: Icon(Icons.business,color: white,size: 10)
                                    ),
                                    Flexible(child: Text(controller.assignedToName ?? 'Empty', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600, color: Colors.black54))),
                                    SizedBox(width: 7),
                                  ],
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),

              Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: large_padding,bottom: normal_padding),
                alignment: Alignment.center,
                child: Text('Course Detail', style: TextStyle(
                    fontWeight: FontWeight.w600
                )),
              ),

              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    textareaInputField(courseDescription, () {}, 'Course Description', ),
                    timeRangeField(context, timeStart, timeEnd, timeStartDisplay, timeEndDisplay, (value) {
                      setState(() {
                        timeStartDisplay = value;
                      });
                    }, (value) {
                      setState(() {
                        print(value);
                        timeEndDisplay = value;
                      });
                    }, 'Course Duration', fieldIcon: Icons.calendar_today),
                    textareaInputField(courseOverview, () {}, 'Course Overview', fieldIcon: Icons.comment_outlined),
                    textareaInputField(courseAnnouncement, () {}, 'Course Announcement'),
                    datetimeField(context, courseMidtermDate, controller.courseMidtermDate, (value) {
                      setState(() {
                        controller.courseMidtermDate = value;
                      });
                    }, 'Course Mid Term Date'),
                    datetimeField(context, courseAssignmentDate, controller.courseAssignmentDate, (value) {
                      setState(() {
                        controller.courseAssignmentDate = value;
                      });
                    }, 'Course Assignment'),
                    datetimeField(context, courseFinal, controller.courseFinalDate, (value) {
                      setState(() {
                        controller.courseFinalDate = value;
                      });
                    }, 'Course Final Examination'),

                    textInputField(courseVenue, () {
                      setState(() {});
                    }, 'Course Venue', fieldIcon: Icons.apartment),

                    numberInputField(studentEnrolled, () {
                      setState(() {});
                    }, 'Number of Student Enrolled', fieldIcon: Icons.emoji_people),

                    //DROPDOWN SELECT COLOR
                    dropdownField(context, controller.courseColorSelection, controller.courseColorSelectionColor, colorController, () {
                      setState(() {
                        colorSelection = controller.courseColorSelection.indexOf(colorController.text.toString());
                        controller.color = controller.courseColorSelectionColor[colorSelection];
                      });
                    }, 'Course Color'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
