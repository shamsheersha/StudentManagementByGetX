import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFieldController extends GetxController{
  final TextEditingController textEditingController = TextEditingController();

  var text = ''.obs;

  @override
  void onInit() {
    super.onInit();
    textEditingController.addListener(updateText);
  }

  updateText(){
    if(textEditingController.text != text.value){
      text.value = textEditingController.text;
    }
  }

  @override
  void onClose() {
    textEditingController.removeListener(updateText);
    textEditingController.dispose();
    super.onClose();
  }
}