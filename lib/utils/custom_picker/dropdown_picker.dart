import 'package:flutter/material.dart';
import 'package:fyp_lms/utils/custom_picker/custom_picker_controller/dropdown_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';


class DropdownPicker extends StatefulWidget{

  const DropdownPicker(this.options,this.label, {Key? key, this.hideSearchBar = true}) : super(key: key);
  final List<String> options;
  final String label;
  final bool hideSearchBar;

  @override
  State<DropdownPicker> createState() => _DropdownPickerState();
}

class _DropdownPickerState extends State<DropdownPicker> {
  DropdownController? controller;

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    if(controller == null){
      controller = DropdownController(widget.options);
      controller!.hasInit = true;
      controller!.mainList = widget.options;
      controller!.init();
    }

    searchController = TextEditingController();
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
              !widget.hideSearchBar ? Container(
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
                    const Icon(Icons.search, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.poppins().copyWith(fontSize: 14, color: Colors.black),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Search Here',
                            suffixIcon: searchController.text.isEmpty ? null
                                : IconButton(icon: const Icon(Icons.clear,color: Colors.grey,),
                              onPressed: () {
                                searchController.clear();
                              },
                            )
                        ),
                        onChanged: (value){
                          controller!.search(value);
                          setState(() {});
                        },
                      )
                    ),
                  ],
                ),
              ) : const SizedBox(),
              !widget.hideSearchBar ? const SizedBox(height: 16) : const SizedBox(),
              Flexible(
                child: ListView.builder(
                  itemCount: controller!.displayList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context,index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 26,right: 26,top: 16,bottom: 16),
                          child: Text(controller!.displayList[index],
                              style: GoogleFonts.poppins().copyWith(
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

  @override
  void dispose() {
    controller = null;
    super.dispose();
  }
}