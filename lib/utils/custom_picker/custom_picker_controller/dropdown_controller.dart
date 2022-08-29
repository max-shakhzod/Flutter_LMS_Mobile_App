import 'package:flutter/material.dart';

class DropdownController {

  //=============================    VARIABLES   ==============================
  late List<String> mainList;
  List<String> displayList = List.empty();
  TextEditingController searchController = TextEditingController();

  bool hasInit = false;

  //=============================    METHODS   ================================
  DropdownController(this.mainList);

  init(){
    displayList = List.empty(growable: true);
    displayList.addAll(mainList);
  }

  search(String key){
    displayList = mainList
        .where((element) => element.toLowerCase().contains(key.toLowerCase()))
        .toList();
  }

  dispose() {
    mainList.clear();
    displayList.clear();
    hasInit = false;
    searchController.clear();
  }

}