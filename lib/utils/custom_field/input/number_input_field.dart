import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget numberInputField(TextEditingController controller, VoidCallback onChanges, String label, {IconData? fieldIcon}) {

  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
        child: Row(
          children: [
            Icon(
              fieldIcon ?? Icons.pin,
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
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 14, bottom: 7, right: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: Colors.black87)),
            minLines: 1,
            maxLines: 1,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                contentPadding:
                EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 12),
                suffixIcon: controller.text.isEmpty ? null
                    : IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    controller.text = '';
                    onChanges();
                  },
                )),
          ),
        ),
      ),
      //SizedBox(height: 7)
    ],
  );
}