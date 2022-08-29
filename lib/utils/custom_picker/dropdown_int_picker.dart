import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'custom_picker_controller/dropdown_controller.dart';


class DropdownIntPicker extends StatefulWidget{

  const DropdownIntPicker(this.options,this.label, {Key? key}) : super(key: key);
  final List<String> options;
  final String label;

  @override
  State<DropdownIntPicker> createState() => _DropdownIntPickerState();
}

class _DropdownIntPickerState extends State<DropdownIntPicker> {
  late DropdownController controller;

  @override
  void initState() {
    super.initState();
    controller = DropdownController(widget.options);
    controller.hasInit = true;
    controller.init();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
        elevation: 24,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 48,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20, right: 20, top: 14,bottom: 14),
                child: Text('Select ' + widget.label,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    )),
              ).onTap(
                      (){
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },splashColor: Colors.transparent
              ),
              //SEARCH BAR
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.only(left: 12),
                height: 46,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 0.5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                              controller: controller.searchController,
                              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: Colors.black)),
                              keyboardType: TextInputType.visiblePassword,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: 'Search Here',
                                  suffixIcon: controller.searchController.text.isEmpty
                                      ? null
                                      : IconButton(icon: Icon(Icons.clear,color: Colors.grey,),
                                    onPressed: () {
                                      setState(() {
                                        controller.searchController.clear();
                                        controller.search('');
                                      });
                                    },
                                  )
                              ),
                              onChanged: (value){
                                setState(() {
                                  controller.search(value);
                                });
                              },
                            )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                    child: ListView.builder(
                        itemCount: controller.displayList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context,index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 26,right: 26,top: 16,bottom: 16),
                                child: Text(controller.displayList[index],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              Divider(
                                indent: 26,
                                endIndent: 26,
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[50],)
                            ],
                          ).onTap((){
                            Navigator.of(context, rootNavigator: true).pop(index);
                          });
                        }),
                  )
            ],
          ),
        )
    );
  }
}