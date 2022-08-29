import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/src/extensions/string_extensions.dart';

Widget numberTwoInputField(
    BuildContext context,
    TextEditingController textControllerMin,
    TextEditingController textControllerMax,
    VoidCallback onChanges, String label,
    {IconData? fieldIcon, String? inputLabel1, String? inputLabel2}) {

  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
        child: Row(
          children: [
            Icon(
              fieldIcon ?? Icons.feed,
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
        padding: EdgeInsets.only(left: 14, bottom: 7, right: 14),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Focus(
                  onFocusChange: (hasFocus){
                    onChanges();
                  },
                  child: TextField(
                    controller: textControllerMin,
                    onChanged: (newValue) {
                      textControllerMin.text = newValue;
                      onChanges();
                    },
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 14, color: Colors.black87)),
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding:
                      EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 12),
                      suffixIcon: textControllerMin.text.isEmpty ? null
                          : IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          textControllerMin.clear();
                          onChanges();
                        },
                      ),
                      hintText: inputLabel1 ?? 'Year',
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: VerticalDivider(width: 1, color: Colors.grey[600],),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Focus(
                  onFocusChange: (hasFocus){
                    onChanges();
                  },
                  child: TextField(
                    controller: textControllerMax,
                    onChanged: (newValue) {
                      textControllerMax.text = newValue;
                      onChanges();
                    },
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 14, color: Colors.black87)),
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding:
                      EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 12),
                      suffixIcon: textControllerMax.text.isEmpty ? null
                          : IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          textControllerMax.clear();
                          onChanges();
                        },
                      ),
                      hintText: inputLabel2 ?? 'Semester',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
