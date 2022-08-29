import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/custom_field/common/attachment_comment.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:fyp_lms/utils/general_utils.dart';
import 'package:fyp_lms/web_service/model/post/post.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

Widget postItem(BuildContext context, Post post, dynamic controller, VoidCallback onRefresh, bool isLiked) {
  return Container(
    margin: const EdgeInsets.only(left: large_padding, right: large_padding, top: normal_padding),
    padding: const EdgeInsets.all(normal_padding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0.0, 1.0),
          color: Colors.grey,
          blurRadius: 1,
        )
      ]
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //USER ACCOUNT
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
              child: Text(GeneralUtil().getShortName(post.createdByName).toUpperCase(), style: GoogleFonts.poppins().copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
            ),

            // POST CREATOR INFORMATION
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.createdByName?.toUpperCase() ?? controller.user.displayName?.toUpperCase(), style: GoogleFonts.poppins().copyWith(
                          fontSize: SUB_TITLE,
                          fontWeight: FontWeight.w600,

                        ),),
                        Text(DateUtil().getDatetimeFormatDisplay().format(DateTime.parse(post.createdDate!)), style: GoogleFonts.poppins().copyWith(
                          color: Colors.grey,
                          fontSize: SUB_TITLE,
                        ),),
                        Text(post.courseBelonging!, style: GoogleFonts.poppins().copyWith(
                          fontSize: SUB_TITLE,
                          color: BG_COLOR_4,
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: normal_padding, right: normal_padding),
                    decoration: BoxDecoration(
                      color: GeneralUtil().getTextColor(controller.colorSelectionColor[controller.colorSelection.indexOf(post.typeColor)]) == Colors.white ? Colors.grey[100] : Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Text(post.type!, style: GoogleFonts.poppins().copyWith(
                      fontSize: SUB_TITLE,
                      color: controller.colorSelectionColor[controller.colorSelection.indexOf(post.typeColor)],
                    )),
                  ),

                ],
              ),
            )
          ],
        ),

        const SizedBox(height: small_padding),

        //DESCRIPTION
        Container(
          margin: const EdgeInsets.all(normal_padding),
          child: Text(post.notes!, style: GoogleFonts.poppins().copyWith(
            fontSize: SUB_TITLE,
          ) ,overflow: TextOverflow.ellipsis),
        ),

        // DOCS, IMAGE DISPLAY
        post.attachments == null || post.attachments!.isEmpty ? const SizedBox() : Container(
          height: 50,
          child: attachmentComment(context, post.attachments, controller),
        ),

        Container(
          margin: const EdgeInsets.only(bottom: normal_padding, top: large_padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //LIKES
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //ICON
                      Icon(Icons.favorite, size: 18, color: isLiked ? Colors.red : Colors.grey,),
                      const SizedBox(width: normal_padding,),
                      //TEXT
                      Text('Like ${post.likes}', style: GoogleFonts.poppins().copyWith(
                        fontSize: SUB_TITLE,
                      ),),
                    ],
                  ),
                ).onTap(() async {
                  final result = await controller.addLikes(post.id!, controller.user.id!, post.likes, onRefresh);
                  if (result) {
                    onRefresh();
                  }
                }),
              ),
              //COMMENT
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //ICON
                    Icon(Icons.message, size: 18, color: Colors.grey,),
                    const SizedBox(width: normal_padding,),
                    //TEXT
                    Text('Comment ${post.commentsCount}', style: GoogleFonts.poppins().copyWith(
                      fontSize: SUB_TITLE,
                    ),)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}