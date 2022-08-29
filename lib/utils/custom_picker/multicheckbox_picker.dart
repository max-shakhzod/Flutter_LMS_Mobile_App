import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../dialog.dart';
import 'custom_picker_controller/multicheckbox_controller.dart';



class MultiplePicker extends StatefulWidget{

  const MultiplePicker(this.value,this.options,this.label,this.allowEmpty, {Key? key}) : super(key: key);

  final dynamic value;
  final List<String> options;
  final String label;
  final bool? allowEmpty;

  @override
  State<MultiplePicker> createState() => _MultiplePickerState();
}

class _MultiplePickerState extends State<MultiplePicker> {
  final MultipleController controller = MultipleController();


  @override
  void initState() {
    super.initState();
    if(!controller.hasInit){
      controller.hasInit = true;
      controller.mainList = widget.options;
      controller.allowEmpty = widget.allowEmpty!;
      controller.init(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Dialog(
        elevation: 24,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 14,bottom: 14),
                child: Text('Select ' + widget.label,
                    style: GoogleFonts.poppins().copyWith(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    )),
              ).onTap((){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },splashColor: Colors.transparent
              ),
              //SEARCH BAR
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(left: 12),
                height: 46,
                width: (MediaQuery.of(context).size.width - 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      offset: const Offset(0.0, 1.0), //(x,y)
                      blurRadius: 0.5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 22,),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        style: GoogleFonts.poppins(textStyle: GoogleFonts.poppins().copyWith(fontSize: 14, color: Colors.black)),
                        keyboardType: TextInputType.visiblePassword,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Search Here',
                            suffixIcon: controller.searchController.text.length == 0
                                ? null
                                : IconButton(icon: const Icon(Icons.clear,color: Colors.grey,),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.search('');
                                setState(() {});
                              },
                            )
                        ),
                        onChanged: (value){
                          controller.search(value);
                          setState(() {});
                        },
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: controller.displayList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context,index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 26,right: 14,top: 16,bottom: 16),
                                child: Text(controller.displayList[index],
                                    style: GoogleFonts.poppins().copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                            ),
                            Checkbox(
                                value: controller.selectedVal.contains(controller.displayList[index]),
                                onChanged: (newValue){
                                  controller.onItemClick(controller.displayList[index]);
                                },
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))
                            ),
                            const SizedBox(width: 10)
                          ],
                        ),
                        Divider(
                            indent: 26,
                            endIndent: 26,
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[50])
                      ],
                    ).onTap((){
                      controller.onItemClick(controller.displayList[index]);
                      setState(() {});
                    });
                  }
                )
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 11,bottom: 11,left: 18,right: 18),
                      child: Text(controller.selectedVal.length == controller.mainList.length ? 'Unselect All' : 'Select All', style: GoogleFonts.poppins().copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w600
                      )),
                    ).onTap((){

                      controller.onCheckAllClick();
                      setState(() {});
                    }),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(top: 11,bottom: 11,left: 10,right: 10),
                    child: Text('Cancel', style: GoogleFonts.poppins().copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w600
                    )),
                  ).onTap((){
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.only(top: 11,bottom: 11,left: 18,right: 18),
                    child: const Text('Done', style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold
                    )),
                  ).onTap((){
                    if(widget.allowEmpty!){
                      if(controller.selectedVal.isEmpty){
                        showInfoDialog(context, null, 'Please select at least 1 ${widget.label}');
                        return;
                      }
                    }

                    Navigator.of(context, rootNavigator: true).pop(controller.selectedVal);
                  }),
                ],
              )
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    controller.searchController.dispose();
    super.dispose();
  }
}