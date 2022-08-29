import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/course/course_detail_controller.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/general_utils.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:fyp_lms/ui/dashboard/post_item.dart';
import 'course_menu_bs.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  CourseDetailController controller = CourseDetailController();
  SharedPreferences? _sPref;


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _sPref = value;
        initializeData();

      });
    });
  }

  initializeData() async {
    controller.isLoading = true;

    //_sPref.setString('accountInfo', jsonEncode(createdUser));
    controller.accountId = _sPref!.getString('account');
    controller.accountName = _sPref!.getString('username');
    controller.user = Account.fromJson(jsonDecode(_sPref!.getString('accountInfo')!));
    controller.accountType = _sPref!.getInt('accountType');


    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['course'] != null) {
      setState(() {
        controller.course = arguments['course'];
        fetchPosts();
      });
    }
    if (arguments['courseId'] != null) {
      fetchCourse(arguments['courseId']);
    }

  }

  fetchCourse(String courseId) async {
    setState(() {
      controller.isLoading = true;
    });
    await controller.fetchCourse(context, () {setState(() {});}, courseId).then((_) async {
      await fetchPosts();
    });
  }

  fetchPosts() async {
    await controller.fetchPost(context, () {
      setState(() {});
    }).then((result) {
      setState(() {
        controller.isLoading = false;
      });
      return true;
    });
  }

  refreshCourse(BuildContext context) async {
    setState(() {
      controller.isLoading = true;
    });
    await controller.refreshCourse(context).then((_) async {
      await fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(controller.course!.id);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 400),
            height: controller.isLoading ? 0 : MediaQuery.of(context).size.height,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.3,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    leadingWidth: 56,
                    leading: Icon(
                      Icons.arrow_back,
                      color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                    ).onTap(() => Navigator.of(context).pop()),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0)),
                              ),
                              isScrollControlled: true,
                              context: context,
                              isDismissible: true,
                              builder: (ctx) => courseMenuBS(context, controller)).then((value) async {

                                if (value != null && value is int) {
                                  switch(value) {
                                    case 1:
                                      //BROWSE COURSE MATERIAL
                                      Navigator.of(context).pushNamed('/CourseMaterialScreen', arguments: {
                                        'course': controller.course,
                                      });
                                      break;

                                    case 2:
                                      //TODO: EDIT COURSE
                                      Navigator.of(context).pushNamed('/AddCourseScreen', arguments: {
                                        'course': controller.course,
                                      }).then((value) async {
                                        print(value);
                                        if (value != null && (value as Map)['result'] == 200) {
                                          controller.course!.id = value['newCourseId'];
                                        }

                                        final result = await controller.refreshCourse(context);
                                        if (result) {
                                          setState(() {
                                            controller.isLoading = false;
                                          });
                                        }
                                      });
                                      break;

                                    case 3:
                                      //DELETE COURSE
                                      controller.deleteCourse(context);
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              }
                          );
                        },
                      ),
                    ],
                    centerTitle: true,
                    title: Column(
                      children: [
                        //COURSE TITLE
                        Text(controller.course!.courseName ?? '-', style: GoogleFonts.poppins().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)])
                        ),),
                        //COURSE CODE
                        Text(controller.course!.courseCode ?? '-', style: GoogleFonts.poppins().copyWith(
                          fontSize: HINT_TEXT,
                          fontWeight: FontWeight.w500,
                          color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                        ),),
                      ],
                    ),
                    backgroundColor: controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)].withOpacity(0.8),
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext ctx, BoxConstraints constraints) {
                        return FlexibleSpaceBar(
                          background: Container(
                            margin: EdgeInsets.only(top: constraints.maxHeight * 0.2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //DISPLAY COURSE DUE DATE
                                controller.course!.courseMidtermDate == null ? const SizedBox() : Container(
                                  padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: normal_padding, bottom: normal_padding),
                                  decoration: BoxDecoration(
                                    color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]) == Colors.white ? Colors.white10 : Colors.black12,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Mid Term:',style: GoogleFonts.poppins().copyWith(
                                        color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                                        fontSize: SUB_TITLE,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text(controller.course!.courseMidtermDate!,style: GoogleFonts.poppins().copyWith(
                                        color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                                        fontWeight: FontWeight.w600,
                                      ),),

                                    ],
                                  ),
                                ),
                                const SizedBox(height: large_padding),

                                Container(
                                  margin: const EdgeInsets.only(left: x_large_padding, right: x_large_padding),
                                  child: Row(
                                    children: [
                                      controller.course!.courseAssignmentDate == null ? const SizedBox() : Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: normal_padding, bottom: normal_padding),
                                          decoration: BoxDecoration(
                                            color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]) == Colors.white ? Colors.white10 : Colors.black12,
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Assignment: ',style: GoogleFonts.poppins().copyWith(
                                                color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                                                fontSize: SUB_TITLE,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                              Text(controller.course!.courseAssignmentDate!,style: GoogleFonts.poppins().copyWith(
                                                color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                                                fontWeight: FontWeight.w600,
                                              ),),

                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: x_large_padding),
                                      controller.course!.courseFinal == null ? const SizedBox() : Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: normal_padding, bottom: normal_padding),
                                          decoration: BoxDecoration(
                                            color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]) == Colors.white ? Colors.white10 : Colors.black12,
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Final Exam:',style: GoogleFonts.poppins().copyWith(
                                                color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                                                fontSize: SUB_TITLE,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                              Text(controller.course!.courseFinal!,style: GoogleFonts.poppins().copyWith(
                                                color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)]),
                                                fontWeight: FontWeight.w600,
                                              ),),

                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ];
              },
              //CONTENT HERE
              body: RefreshIndicator(
                onRefresh: () => refreshCourse(context),
                displacement: 60,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //ANNOUNCEMENT
                      Container(
                        padding: const EdgeInsets.all(normal_padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.announcement,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  margin: EdgeInsets.only(right: 10),
                                ),

                                Text('Announcement > ',
                                    style: GoogleFonts.poppins().copyWith(
                                        fontSize: SUB_TITLE,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),

                            Container(
                              margin: const EdgeInsets.all(normal_padding),
                              child: Text(controller.course!.courseAnnouncement!,
                                  style: GoogleFonts.poppins().copyWith(
                                      fontWeight: FontWeight.w500)),
                            ),

                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: x_large_padding, right: x_large_padding),
                        //padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)].withOpacity(0.15),
                            borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 4,
                                decoration: BoxDecoration(
                                    color: controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)],
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), topLeft: Radius.circular(6))
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(top: normal_padding, bottom: normal_padding, left: large_padding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Lecturer:',style: GoogleFonts.poppins().copyWith(
                                              fontSize: SUB_TITLE,
                                              fontWeight: FontWeight.w500,
                                            ),),
                                            Text(controller.course!.assignedToName!, style: GoogleFonts.poppins().copyWith(

                                              fontWeight: FontWeight.w600,
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 12),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      //STUDENT ENROLLED
                      Container(
                        margin: EdgeInsets.only(left: x_large_padding, right: x_large_padding),
                        //padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 4,
                                decoration: BoxDecoration(
                                    color: controller.colorSelectionColor[controller.colorSelection.indexOf(controller.course!.color!)],
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), topLeft: Radius.circular(6))
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(top: normal_padding, bottom: normal_padding, left: large_padding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Student Enrolled:',style: GoogleFonts.poppins().copyWith(
                                              fontSize: SUB_TITLE,
                                              fontWeight: FontWeight.w500,
                                            ),),
                                            Text(controller.course!.studentEnrolled!, style: GoogleFonts.poppins().copyWith(

                                              fontWeight: FontWeight.w600,
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 12),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Container(
                        margin: const EdgeInsets.all(normal_padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.category,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  margin: EdgeInsets.only(right: 10),
                                ),

                                Text('Course Overview > ',
                                    style: GoogleFonts.poppins().copyWith(
                                        fontSize: SUB_TITLE,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(controller.course!.courseOverview!, style: GoogleFonts.poppins().copyWith(
                                fontSize: SUB_TITLE,
                              ),),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      Divider(
                        color: Colors.grey[100],
                        height: 10,
                        thickness: 10,
                      ),

                      //POST
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: large_padding, top: large_padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.article,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      margin: EdgeInsets.only(right: 10),
                                    ),

                                    Text('Course Feed > ',
                                        style: GoogleFonts.poppins().copyWith(
                                            fontSize: SUB_TITLE,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: large_padding, top: large_padding),
                            padding: const EdgeInsets.only(left: normal_padding, right: normal_padding, top: small_padding, bottom: small_padding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              color: BG_COLOR_4.withOpacity(0.2),
                            ),
                            child: Icon(Icons.add, size: 18,),
                          ).onTap((){
                            Navigator.of(context).pushNamed('/AddPostScreen', arguments: {
                              'courseId': controller.course!.id!,
                            });
                          })
                        ],
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.postList.length,
                        itemBuilder: (context, index) {
                          return postItem(context, controller.postList[index], controller, () {
                            setState(() {});
                          }, controller.postLikes[controller.postList[index].id]!).onTap(() {
                            Navigator.of(context).pushNamed('/PostDetailScreen', arguments: {
                              'post': controller.postList[index],
                              'isLiked': controller.postLikes[controller.postList[index].id],
                            });
                          });
                        }
                      ),
                      SizedBox(height:10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 400),
              height: controller.isLoading ? MediaQuery.of(context).size.height : 0,
              child: controller.isLoading ? Center(
                child: CircularProgressIndicator(),
              ) : SizedBox()
          ),
        ],
      ),
    );
  }
}
