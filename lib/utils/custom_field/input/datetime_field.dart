import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../date_util.dart';

Widget datetimeField(BuildContext context, TextEditingController controller, String? datetimeValue, ValueChanged<String> onChanges, String label){

  DateTime mDate = DateTime.now();

  if(datetimeValue != null && datetimeValue.isNotEmpty){
    mDate = DateTime.parse(datetimeValue.toString());
    controller.text = DateUtil().getDatetimeFormatDisplay().format(mDate);
    onChanges(DateUtil().getDatetimeFormatServer().format(mDate));
  } else {
    datetimeValue = DateUtil().getDatetimeFormatServer().format(mDate);
    controller.text = DateUtil().getDatetimeFormatDisplay().format(mDate);
    onChanges(DateUtil().getDatetimeFormatServer().format(mDate));
  }


  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        padding: EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Icon(
                  Icons.today,
                  color: Colors.grey,
                  size: 18,
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                  ),
                  padding: EdgeInsets.all(1),
                  margin: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 18,
                  ),
                )

              ],
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
                          datetimeValue = '';
                          controller.text = '';
                          onChanges('');
                        }),
                        Container(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_drop_down),
                        ).onTap(() async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          final newDate = await showDatePicker(
                            context: context,
                            initialDate: mDate,
                            firstDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                            lastDate: DateTime.now().add(Duration(days: 900)),
                          );

                          if (newDate != null) {

                            final newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: mDate.hour, minute: mDate.minute)
                            );

                            if (newTime != null) {
                              DateTime newDateTime = DateTime(newDate.year,newDate.month,newDate.day,newTime.hour,newTime.minute);
                              datetimeValue = DateUtil().getDatetimeFormatServer().format(newDateTime);
                              controller.text = DateUtil().getDatetimeFormatDisplay().format(newDateTime);
                              onChanges(datetimeValue!);
                            }

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

                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: mDate,
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                    lastDate: DateTime.now().add(Duration(days: 900)),
                  );

                  if (newDate != null) {

                    final newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: mDate.hour, minute: mDate.minute)
                    );

                    if (newTime != null) {
                      DateTime newDateTime = DateTime(newDate.year,newDate.month,newDate.day,newTime.hour,newTime.minute);
                      datetimeValue = DateUtil().getDatetimeFormatServer().format(newDateTime);
                      controller.text = DateUtil().getDatetimeFormatServer().format(newDateTime);
                      onChanges(datetimeValue!);
                    }

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