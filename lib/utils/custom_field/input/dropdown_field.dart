import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/custom_picker/custom_picker_controller/dropdown_controller.dart';
import 'package:fyp_lms/utils/custom_picker/dropdown_int_picker.dart';
import 'package:fyp_lms/utils/custom_picker/dropdown_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

Widget dropdownField(BuildContext context, List<String> selection, List optionList, TextEditingController controller, VoidCallback onChanges, String label) {

  return Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_drop_down_circle,
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
        color: Colors.white,
        padding: const EdgeInsets.only(left: 14, bottom: 7, right: 14),
        child: Stack(
          alignment: Alignment.center,
          children: [
            TextField(
                autofocus: false,
                readOnly: true,
                controller: controller,
                onChanged: (newValue) {
                  onChanges();
                },
                style: GoogleFonts.poppins().copyWith(fontSize: 14, color: Colors.black),
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 12),
                    suffixIcon: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        controller.text.isEmpty ? const SizedBox(width: 12) :
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.cancel, size: 20,),
                        ).onTap(() {
                          controller.text = '';
                          onChanges();
                        }),
                        Container(
                          padding: const EdgeInsets.only(right: 12),
                          child: const Icon(Icons.arrow_drop_down),
                        ).onTap(() {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          // DropdownController dropdownController = DropdownController(selection);
                          // dropdownController.dispose();

                          showDialog(
                              context: context,
                              builder: (context) => DropdownIntPicker(selection, 'Select ' + label),
                              barrierDismissible: true)
                              .then((newValue) {

                            if (newValue != null && newValue is int) {
                              controller.text = selection[newValue];
                              onChanges();
                            }
                          });
                        })
                      ],
                    )
                )
            ),
            Row(
              children: [
                SizedBox(
                  width: controller.text.isNotEmpty ? MediaQuery.of(context).size.width - 98 : MediaQuery.of(context).size.width - 28,
                  height: 42,
                ).onTap(() {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }

                  showDialog(
                      context: context,
                      builder: (context) => DropdownIntPicker(selection, 'Select ' + label),
                      barrierDismissible: true)
                      .then((newValue) {

                    if (newValue != null && newValue is int) {
                      controller.text = selection[newValue];
                      onChanges();
                    }
                  });
                }),
              ],
            )
          ],
        ),
      )
    ],
  );
}
