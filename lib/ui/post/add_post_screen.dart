import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_lms/controller/post/add_post_controller.dart';
import 'package:fyp_lms/utils/constant.dart';
import 'package:fyp_lms/utils/custom_field/input/attachment_field.dart';
import 'package:fyp_lms/utils/custom_field/input/dropdown_field.dart';
import 'package:fyp_lms/utils/custom_field/input/textarea_input_field.dart';
import 'package:fyp_lms/utils/custom_picker/dropdown_picker.dart';
import 'package:fyp_lms/utils/date_util.dart';
import 'package:fyp_lms/utils/general_utils.dart';
import 'package:fyp_lms/web_service/model/user/account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../web_service/model/course/course.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  AddPostController controller = AddPostController();
  SharedPreferences? _sPref;

  TextEditingController titleController = TextEditingController();
  TextEditingController notesDescription = TextEditingController();
  TextEditingController postTypeController = TextEditingController();
  TextEditingController postTypeColorController = TextEditingController();

  TextEditingController postColorController = TextEditingController();

  int postTypeSelection = 0;


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
    controller.createdBy = _sPref!.getString('account');
    controller.createdByName = _sPref!.getString('username');
    controller.accountType = _sPref!.getInt('accountType');
    controller.user = Account.fromJson(json.decode(_sPref!.getString('accountInfo')!) as Map<String, dynamic>);
    controller.createdDate = DateUtil().getDatetimeFormatServer().format(DateTime.now());
    controller.lastUpdate = DateUtil().getDatetimeFormatServer().format(DateTime.now());

    postTypeController.text = controller.postTypeSelection[0];
    controller.type = controller.postTypeSelection[0];
    controller.typeColor = controller.postColorSelectionColor[0];
    postTypeColorController.text = controller.postColorSelection[0];

    controller.color = controller.postColorSelectionColor[0];
    postColorController.text = controller.postColorSelection[0];



    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['courseId'] != null) {
      setState(() {
        controller.courseBelonging = arguments['courseId'];
      });
    } else {
      await controller.fetchCourse(() { setState(() {});});
    }

    if (arguments['post'] != null) {
      await controller.fetchCourse(() { setState(() {});});
      controller.populateData(arguments['post']);

      titleController.text = controller.title!;
      notesDescription.text = controller.notes!;
      postTypeController.text = controller.postTypeSelection.firstWhere((element) => element == controller.type);
      postTypeColorController.text = controller.postColorSelection[controller.postColorSelectionColor.indexOf(controller.typeColor!)];
      postColorController.text = controller.postColorSelection[controller.postColorSelectionColor.indexOf(controller.color!)];

      setState(() {
        controller.isEdit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: controller.color ?? BG_COLOR_4,
        leading: Icon(Icons.arrow_back, color: GeneralUtil().getTextColor(controller.color!),).onTap(() {
          Navigator.of(context).pop();
        }),
        centerTitle: true,
        title: Text(controller.isEdit ? 'Edit Post' : 'Add New Post', style: GoogleFonts.poppins().copyWith(
          fontSize: TITLE,
          fontWeight: FontWeight.bold,
          color: GeneralUtil().getTextColor(controller.color!),
        ),),
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.all(normal_padding),
            alignment: Alignment.center,
            child: Text('Done', style: GoogleFonts.poppins().copyWith(
              color: GeneralUtil().getTextColor(controller.color!),
              fontWeight: FontWeight.bold,
            ),),
          ).onTap(() {
            controller.compileData(
              context, titleController.text, notesDescription.text,
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
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(large_padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget> [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Type
                                Text('Post Type:', style: GoogleFonts.poppins().copyWith(
                                  fontSize: TITLE,
                                  fontWeight: FontWeight.w600,
                                  color: GeneralUtil().getTextColor(controller.color!),
                                ),),
                                //TextField
                                Container(
                                  margin: const EdgeInsets.all(normal_padding),
                                  padding: const EdgeInsets.all(large_padding),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(postTypeController.text, style: GoogleFonts.poppins().copyWith(
                                          fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                      Icon(Icons.arrow_drop_down, color: Colors.black54),
                                    ],
                                  ),
                                ).onTap(() {
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext ctx) => DropdownPicker(controller.postTypeSelection, 'Post Type')
                                  ).then((newValue) {
                                    if (newValue != null && newValue is int) {
                                      setState(() {
                                        postTypeController.text = controller.postTypeSelection[newValue];
                                        controller.type = controller.postTypeSelection[newValue];
                                      });
                                    }
                                  });
                                }),
                              ]
                            ),
                          ),

                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //Type
                                    Text('Post Type Color:', style: GoogleFonts.poppins().copyWith(
                                      fontSize: TITLE,
                                      fontWeight: FontWeight.w600,
                                      color: GeneralUtil().getTextColor(controller.color!),
                                    ),),
                                    //TextField
                                    Container(
                                      margin: const EdgeInsets.all(normal_padding),
                                      padding: const EdgeInsets.all(large_padding),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(postTypeColorController.text, style: GoogleFonts.poppins().copyWith(
                                              fontWeight: FontWeight.w600,
                                            )),
                                          ),
                                          Icon(Icons.arrow_drop_down, color: Colors.black54),
                                        ],
                                      ),
                                    ).onTap(() {
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (BuildContext ctx) => DropdownPicker(controller.postColorSelection, 'Post Type')
                                      ).then((newValue) {
                                        if (newValue != null && newValue is int) {
                                          setState(() {
                                            postTypeColorController.text = controller.postColorSelection[newValue];
                                            controller.typeColor = controller.postColorSelectionColor[newValue];
                                          });
                                        }
                                      });
                                    }),
                                  ]
                              ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 7),


                      //TITLE
                      Text('Post Title:', style: GoogleFonts.poppins().copyWith(
                        fontSize: TITLE,
                        fontWeight: FontWeight.w600,
                        color: GeneralUtil().getTextColor(controller.color!),
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
                            controller: titleController,
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
                                suffixIcon: titleController.text.isEmpty ? null :
                                IconButton(
                                  iconSize: 20,
                                  icon: const Icon(Icons.cancel),
                                  onPressed: (){
                                    setState(() {
                                      titleController.text = '';
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

              //COURSE SELECTED
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 12, left: 14, bottom: 12, right: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: controller.isLoading ? Center(child: CircularProgressIndicator(color: BG_COLOR_4)) : Container(
                          child: Text(controller.courseBelonging ?? 'Empty', overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins().copyWith(
                            fontSize: SUB_TITLE,
                            fontWeight: FontWeight.w600,
                          ),),
                        ).onTap(() {
                          List<String> courseCode = controller.courseList.map((e) => e.id!).toList();

                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext ctx) => DropdownPicker(courseCode, 'Course Selection')
                          ).then((newValue) {
                            if (newValue != null && newValue is int) {
                              setState(() {
                                controller.courseBelonging = controller.courseList[newValue].id;
                              });
                            }
                          });
                        }),
                    ),
                  ],
                ),
              ),

              //ASSIGNED_TO
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 7),
                padding: EdgeInsets.only(top: 12, left: 14, bottom: 12, right: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_pin_rounded,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //ASSIGNED CHIP VIEW
                            Text(controller.createdByName ?? 'Empty', overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins().copyWith(
                                fontSize: SUB_TITLE,
                                fontWeight: FontWeight.w600,
                            ),),
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
                child: Text('Post Detail', style: TextStyle(
                    fontWeight: FontWeight.w600
                )),
              ),

              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    textareaInputField(notesDescription, () {}, 'Post Description:', ),


                    //DROPDOWN SELECT COLOR
                    dropdownField(context, controller.postColorSelection, controller.postColorSelectionColor, postColorController, () {
                      setState(() {
                        int? colorSelection = controller.postColorSelection.indexOf(postColorController.text.toString());
                        controller.color = controller.postColorSelectionColor[colorSelection];
                      });
                    }, 'Post Color'),

                    //ATTACHMENT UPLOAD
                    attachmentField(context, controller, 'Post Material', controller.attachments!, controller.attachmentsFull!, () {
                     setState(() {});
                    }),
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
    //nameController.dispose();
    super.dispose();
  }
}
