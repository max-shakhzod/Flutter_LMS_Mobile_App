import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/post/post_detail_controller.dart';
import 'package:fyp_lms/ui/post/post_menu_bs.dart';
import 'package:fyp_lms/utils/custom_field/common/attachment_comment.dart';
import 'package:fyp_lms/utils/custom_field/input/attachment_field.dart';
import 'package:fyp_lms/utils/custom_field/input/textarea_input_field.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:fyp_lms/utils/dialog.dart';
import 'package:fyp_lms/web_service/model/post/comment.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';
import '../../utils/general_utils.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostDetailController controller = PostDetailController();
  late SharedPreferences _sPref;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller.isLoading = true;
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _sPref = value;
        initializeData();

      });
    });
  }

  initializeData() async {
    //_sPref.setString('accountInfo', jsonEncode(createdUser));
    controller.accountId = _sPref.getString('account');
    controller.accountName = _sPref.getString('username');
    controller.user = Account.fromJson(jsonDecode(_sPref.getString('accountInfo')!));
    controller.accountType = _sPref.getInt('accountType');


    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['post'] != null) {
      setState(() {
        controller.post = arguments['post'];
        controller.postId = controller.post!.id;
      });
    }
    if (arguments['isLiked'] != null) {
      setState(() {
        controller.isLiked = arguments['isLiked'];

      });
    }
    fetchComment();
    setState(() {
      controller.isLoading = false;
    });
  }

  fetchComment() async {
    setState(() {
      controller.commentLoading = true;
    });
    controller.getComment(context, controller.post!).then((value) {
      setState(() {
        controller.commentLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
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
                          color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]),
                        ).onTap(() => Navigator.of(context).pop()),
                        actions: [
                          controller.accountType == 1 ? const SizedBox() : IconButton(
                            icon: Icon(Icons.more_vert, color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)])),
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
                                  builder: (ctx) => postMenuBS(context, controller)).then((value) async {

                                if (value != null && value is int) {
                                  switch(value) {
                                    case 1:

                                      Navigator.of(context).pushNamed('/AddPostScreen', arguments: {
                                        'post': controller.post,
                                        'courseId': controller.post!.courseBelonging,
                                      }).then((value) {
                                        controller.refreshPost(context, () { });
                                      });
                                      break;

                                    case 2:
                                    //DELETE POST
                                      controller.deletePost(context, controller.post!);
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              }
                              );
                            },
                          )
                        ],
                        centerTitle: true,
                        title: Column(
                          children: <Widget>[
                            //COURSE TITLE
                            Text(controller.post!.title ?? '-', style: GoogleFonts.poppins().copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)])
                            ),),
                            //COURSE CODE
                            Text(controller.post!.courseBelonging!, style: GoogleFonts.poppins().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]),
                            ),),
                          ],
                        ),
                        backgroundColor: controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)].withOpacity(0.8),
                        flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return FlexibleSpaceBar(
                              background: Container(
                                margin: EdgeInsets.only(top: constraints.maxHeight *  0.35),
                                child: Column(
                                  children: <Widget>[
                                    //DISPLAY POST
                                    Container(
                                      height: 75,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(GeneralUtil().getShortName(controller.post!.createdByName ?? 'A').toUpperCase(), style: GoogleFonts.poppins().copyWith(
                                        fontSize: BIG_TITLE,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),),
                                    ),

                                    //ROW DISPLAYED
                                    Container(
                                      margin: const EdgeInsets.only(top: large_padding),
                                      child: Row(
                                        children: <Widget>[
                                          //DATE
                                          Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.only(left: large_padding, right: large_padding),
                                                padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: normal_padding, bottom: normal_padding),
                                              decoration: BoxDecoration(
                                                color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]) == Colors.white ? Colors.white10 : Colors.black12,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Created Date:', style: GoogleFonts.poppins().copyWith(
                                                    color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]),
                                                    fontSize: SUB_TITLE,
                                                    fontWeight: FontWeight.w500,
                                                  ),),
                                                  Text(DateUtil().getDatetimeFormatDisplay().format(DateTime.parse(controller.post!.createdDate!)),style: GoogleFonts.poppins().copyWith(
                                                    color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]),
                                                    fontWeight: FontWeight.w600,
                                                  ),),
                                                ],
                                              )
                                            ),
                                          ),

                                          //POST TYPE
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(left: large_padding, right: large_padding),
                                                padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: normal_padding, bottom: normal_padding),
                                                decoration: BoxDecoration(
                                                  color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]) == Colors.white ? Colors.white10 : Colors.black12,
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Post Type:', style: GoogleFonts.poppins().copyWith(
                                                      color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]),
                                                      fontSize: SUB_TITLE,
                                                      fontWeight: FontWeight.w500,
                                                    ),),
                                                    Text(controller.post!.type!,style: GoogleFonts.poppins().copyWith(
                                                      color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)]),
                                                      fontWeight: FontWeight.w600,
                                                    ),),
                                                  ],
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            );
                          }
                        ),

                      )
                    ];
                  },
                  body: RefreshIndicator(
                    onRefresh: () => controller.refreshPost(context,() {
                      setState(() {});
                    }),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //ANNOUNCEMENT
                          Container(
                            padding: const EdgeInsets.all(large_padding),
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

                                    Text('Post Notes > ',
                                        style: GoogleFonts.poppins().copyWith(
                                            fontSize: SUB_TITLE,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                                Container(
                                  margin: const EdgeInsets.all(normal_padding),
                                  child: Text(controller.post!.notes!,
                                      style: GoogleFonts.poppins().copyWith(
                                          fontWeight: FontWeight.w500)),
                                ),

                              ],
                            ),
                          ),

                          //COURSE BELONGING
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
                                        color: controller.colorSelectionColor[controller.colorSelection.indexOf(controller.post!.color!)],
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
                                                Text('Course Belongs To:',style: GoogleFonts.poppins().copyWith(
                                                  fontSize: SUB_TITLE,
                                                  fontWeight: FontWeight.w500,
                                                ),),
                                                Text(controller.post!.courseBelonging!, style: GoogleFonts.poppins().copyWith(
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
                          ).onTap(() {
                            Navigator.of(context).pushNamed('/CourseDetailScreen', arguments: {
                              'courseId': controller.post!.courseBelonging,
                            });
                          }),
                          SizedBox(height: 10),

                          //ATTACHMENTS
                          Container(
                            padding: const EdgeInsets.all(large_padding),
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

                                    Text('Post Attachments > ',
                                        style: GoogleFonts.poppins().copyWith(
                                            fontSize: SUB_TITLE,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                                Container(
                                  margin: const EdgeInsets.all(normal_padding),
                                  height: 75.0,
                                  child: attachmentComment(context, controller.post!.attachments, controller),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            height: 10,
                            thickness: 10,
                            color: Colors.grey[100],
                          ),

                          //ATTACHMENTS
                          Container(
                            padding: const EdgeInsets.all(large_padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.comment,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      margin: EdgeInsets.only(right: 10),
                                    ),

                                    Text('Post Comment [${controller.post!.commentsCount}] > ',
                                        style: GoogleFonts.poppins().copyWith(
                                            fontSize: SUB_TITLE,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                                controller.commentLoading ? const Center(child: CircularProgressIndicator(color: BG_COLOR_4)) :
                                Container(
                                  margin: const EdgeInsets.only(left: normal_padding, right: normal_padding, bottom: 32),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.commentList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      Comment comment = controller.commentList[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: normal_padding),
                                        padding: const EdgeInsets.all(normal_padding),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[400]!, width: 0.5),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                //SHORT NAME
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.all(normal_padding),
                                                  width: 35,
                                                  height: 35,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.blue,
                                                    shape: CircleBorder(),
                                                  ),
                                                  child: Text(GeneralUtil().getShortName(comment.createdByName).toUpperCase(), style: GoogleFonts.poppins().copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),),
                                                ),

                                                // POST CREATOR INFORMATION
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(comment.createdByName?.toUpperCase() ?? controller.user!.displayName!.toUpperCase(), style: GoogleFonts.poppins().copyWith(
                                                        fontSize: SUB_TITLE,
                                                        fontWeight: FontWeight.w600,

                                                      ),),
                                                      Text(DateUtil().getDatetimeFormatDisplay().format(DateTime.parse(comment.createdDate!)), style: GoogleFonts.poppins().copyWith(
                                                        color: Colors.grey,
                                                        fontSize: SUB_TITLE,
                                                      ),),
                                                      Text(comment.courseBelonging!, style: GoogleFonts.poppins().copyWith(
                                                        fontSize: SUB_TITLE,
                                                        color: BG_COLOR_4,
                                                      )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),

                                            //Comment Content
                                            const SizedBox(height: small_padding),

                                            //DESCRIPTION
                                            Container(
                                              margin: const EdgeInsets.all(normal_padding),
                                              child: Text(comment.notes!, style: GoogleFonts.poppins().copyWith(
                                                fontSize: SUB_TITLE,
                                              ) ,overflow: TextOverflow.ellipsis),
                                            ),

                                            // DOCS, IMAGE DISPLAY
                                            comment.attachments == null || comment.attachments!.isEmpty ? const SizedBox() : Container(
                                              height: 75,
                                              child: attachmentComment(context, comment.attachments, controller),
                                            ),


                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      )
                    ),
                  ),
                )
              ),
              AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 400),
                  height: controller.isLoading ? MediaQuery.of(context).size.height : 0,
                  child: controller.isLoading ? Center(
                    child: CircularProgressIndicator(),
                  ) : SizedBox()
              ),
            ]
          ),
        ),

        Positioned(
          left: 0,
          bottom: 0,
          child: Material(
            child: Container(
              margin: const EdgeInsetsDirectional.only(start: 2, top: 3),
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.grey[200]!),
                ]
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                  ),

                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: small_padding),
                      child: Row(
                        children: <Widget>[
                          //LIKES ICONS
                          Container(
                            margin: const EdgeInsets.only(left: large_padding, right: large_padding),
                            child: Icon(Icons.favorite, size: 28, color: controller.isLiked ? Colors.red : Colors.grey,).onTap(() {
                              controller.addLikes(controller.postId!, controller.user!.id!, controller.post!.likes!, () {
                                setState(() {});
                              });
                            }),
                          ),

                          //VERTICAL DIVIDER
                          Padding(
                            padding: const EdgeInsets.only(top: small_padding, bottom: small_padding),
                            child: VerticalDivider(
                              width: 5,
                              color: Colors.grey[200],
                              thickness: 2,
                            ),
                          ),

                          // COMMENT BAR
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: large_padding, right: large_padding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Comment ', style: GoogleFonts.poppins().copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,

                                        ),
                                        children: [
                                          TextSpan(
                                            text: '(${controller.post!.commentsCount})', style: GoogleFonts.poppins().copyWith(
                                              fontSize: SUB_TITLE,
                                            ),
                                          )
                                        ]
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreenAccent[100],
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                    ),
                                    child: Icon(Icons.add, color: Colors.green[400], size: 20),
                                  ).onTap(() {
                                    //ENTER ADD COMMENT SCREEN
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(10.0),
                                            topRight: const Radius.circular(10.0)),
                                      ),
                                      isScrollControlled: true,
                                      context: context,
                                      isDismissible: true,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setState1) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScopeNode currentFocus = FocusScope.of(context);
                                                if (!currentFocus.hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(left: normal_padding, right: normal_padding, bottom: MediaQuery.of(context).viewInsets.bottom),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: const Radius.circular(10.0),
                                                      topRight: const Radius.circular(10.0),
                                                    ),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.drag_handle,
                                                      color: Colors.grey,
                                                    ),

                                                    //To Post:
                                                    Container(
                                                      margin: const EdgeInsets.only(left: large_padding, bottom: normal_padding),
                                                      child: Row(
                                                        children: [
                                                          Text('Post To: ', style: GoogleFonts.poppins().copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: SUB_TITLE,
                                                          )),

                                                          const SizedBox(width: small_padding),

                                                          Expanded(
                                                            child: Text(controller.post!.title!, style: GoogleFonts.poppins().copyWith()),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Divider(
                                                      indent: 10,
                                                      endIndent: 10,
                                                      height: 1,
                                                      color: Colors.grey[300],
                                                      thickness: 1,
                                                    ),

                                                    textareaInputField(controller.commentController, () {
                                                      setState1(() {});
                                                    }, 'Comment', fieldIcon: Icons.comment),

                                                    attachmentField(context, controller, 'Upload Material', controller.attachments, controller.attachmentsFull, () {
                                                      setState1(() {});
                                                    }, fieldIcon: Icons.file_present),

                                                    //SUBMIT BUTTON
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        Container(
                                                          width: 65,
                                                          padding: const EdgeInsets.only(left: x_large_padding, right: x_large_padding, top: normal_padding, bottom: normal_padding),
                                                          margin: const EdgeInsets.only(bottom: large_padding, right: large_padding),
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              stops: const [
                                                                0.0,
                                                                0.2,
                                                                0.8
                                                              ],
                                                              colors: const [
                                                                BG_COLOR_3,
                                                                BG_COLOR_2,
                                                                BG_COLOR_4
                                                              ]
                                                            ),
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                          alignment: Alignment.centerRight,
                                                          child: Icon(Icons.send, color: Colors.white, size: 18.0),
                                                        ).onTap(() {
                                                          if (controller.commentController.text.isNotEmpty) {
                                                            controller.addComment(context, controller.post!, controller.commentController.text, () {
                                                              setState(() {});
                                                            }).then((value) {
                                                              controller.commentController.clear();
                                                              controller.attachments.clear();
                                                              controller.attachmentsFull.clear();

                                                            });
                                                          } else {
                                                            showInfoDialog(context, null, 'Comment cannot be empty');
                                                          }
                                                        }),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                    ).whenComplete(() {
                                      //DISPOSE THE COMMENT FIELD

                                    });
                                  }),
                                ],
                              ),
                            ),
                          )

                        ]
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        )
      ],
    );
  }
}
