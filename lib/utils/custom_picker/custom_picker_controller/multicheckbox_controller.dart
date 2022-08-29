import 'dart:convert';

import 'package:flutter/material.dart';

class MultipleController {

  //=============================    VARIABLES   ==============================
  late List<String> mainList;
  List<String> selectedVal = List.empty(growable: true);
  List<String> displayList = List.empty(growable: true);
  TextEditingController searchController = TextEditingController();

  bool hasInit = false, allowEmpty = true;

  //=============================    METHODS   ================================

  init(dynamic selected){
    displayList = List.empty(growable: true);
    displayList.addAll(mainList);

    if(selected != null){

      if(selected is String && selected.isEmpty){
        selectedVal = List.empty(growable: true);
        return;
      }

      if(selected is String){
        selected = jsonDecode(selected);
      }

      List selectedList = selected;
      selectedVal = selectedList.map((e){
        return e.toString();
      }).toList();
    }

    //perform setstate
  }

  onItemClick(String item){
    if(selectedVal.contains(item)){
      selectedVal.remove(item);
    }else{
      selectedVal.add(item);
    }

  }

  onCheckAllClick(){
    if(selectedVal.length == mainList.length){
      selectedVal = List.empty(growable: true);
    }else{
      selectedVal = List.empty(growable: true);
      selectedVal.addAll(mainList);
    }

  }

  search(String key){
    displayList = mainList
        .where((element) => element.toLowerCase().contains(key.toLowerCase()))
        .toList();

  }

}