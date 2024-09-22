import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {

  var _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  toggleTheme(bool isDarkMode){
    _themeMode.value = isDarkMode? ThemeMode.dark : ThemeMode.light;
    update();
  }
}