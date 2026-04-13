import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final themeMode = ThemeMode.light.obs;
  final locale = const Locale('en').obs;

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleLocale() {
    locale.value = locale.value.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
  }
}
