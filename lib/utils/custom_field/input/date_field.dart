import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../date_util.dart';

Widget dateField(BuildContext context, TextEditingController controller, VoidCallback onChanges, String label){

  DateTime mDate = DateTime.now();

  if(controller.toString().isNotEmpty){
    mDate = DateUtil().getDateFormatServer().parse(controller.toString());
    controller.text = DateUtil().getDateFormatDisplay().format(mDate);
  }

  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        padding: EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
        child: Row(
          children: [
            Icon(
              Icons.insert_invitation_rounded,
              color: Colors.grey,
              size: 18,
            ),
            SizedBox(width: 10),
            Flexible(
                child: RichText(
                    text: TextSpan(
                        text: label,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey),
                        ),
                        children: [
                          TextSpan(
                              text: '*',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.red),
                              )),
                        ]))
                    )
          ],
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        padding: EdgeInsets.only(left: 14, bottom: 7, right: 14),
        child: Stack(
          alignment: Alignment.center,
          children: [
            TextField(
                autofocus: false,
                readOnly: true,
                controller: controller,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 14, color: Colors.black)
                ),
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]!)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]!)
                    ),
                    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 12),
                    suffixIcon: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        controller.text.isEmpty ? SizedBox(width: 12)
                            : Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.cancel,size: 20,),
                        ).onTap(() {

                          controller.text = '';
                          onChanges();
                        }),
                        Container(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_drop_down),
                        ).onTap(() async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          final result = await showDatePicker(
                            context: context,
                            initialDate: mDate,
                            firstDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                            lastDate: DateTime.now().add(Duration(days: 900)),
                          );

                          if (result != null) {
                            controller.text = DateUtil().getDateFormatServer().format(result);
                            onChanges();
                          }
                        })
                      ],
                    )
                )
            ),
            Row(
              children: [
                Container(
                  width: controller.text.isNotEmpty ? MediaQuery.of(context).size.width - 98 : MediaQuery.of(context).size.width - 28,
                  height: 42,
                ).onTap(() async {

                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }

                  final result = await showDatePicker(
                    context: context,
                    initialDate: mDate,
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                    lastDate: DateTime.now().add(Duration(days: 900)),
                  );

                  if (result != null) {

                    controller.text = DateUtil().getDateFormatServer().format(result);
                    onChanges();
                  }

                }),

              ],
            )
          ],
        ),
      )
    ],
  );
}