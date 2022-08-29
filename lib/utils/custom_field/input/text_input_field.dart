import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';


Widget textInputField(TextEditingController controller, VoidCallback onChanges, String label, {IconData? fieldIcon}){

  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
        child: Row(
          children: [
            Icon(
              fieldIcon ?? Icons.feed,
              color: Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 10),
            Flexible(
              //CHECK IF REQUIRED
              child: RichText(
                text: TextSpan(
                  text: label,
                  style: GoogleFonts.poppins().copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey),
                  children: [
                    TextSpan(
                        text: '*',
                        style: GoogleFonts.poppins(
                          textStyle: GoogleFonts.poppins().copyWith(
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
        padding: const EdgeInsets.only(left: 14, bottom: 7, right: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: TextField(
            controller: controller,
            onChanged: (newValue){
              onChanges();
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
                suffixIcon: controller.text.isEmpty ? null :
                IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.cancel),
                  onPressed: (){
                    controller.text = '';
                    onChanges();
                  },
                )
            ),
          ),
        ),
      ),
    ],
  );
}