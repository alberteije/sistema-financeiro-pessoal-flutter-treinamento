import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';

class ThemeController extends GetxController {
  final _isDarkMode = true.obs;
  bool get isDarkMode => _isDarkMode.value;
  set isDarkMode(bool value) => _isDarkMode.value = value;

  Future<ThemeMode> getTheme () async {
    if (Constants.usingLocalDatabase) {    
      final settings = await Session.database.customSelect(Constants.sqlGetSettings).getSingleOrNull();
      if (settings != null && settings.data["APP_THEME"] == 'dark') {
        isDarkMode = true;
        return ThemeMode.dark;
      } else {
        isDarkMode = false;
        return ThemeMode.light;
      }
    } else {
      // TODO: persist settings at remote database if you wish
      isDarkMode = false;
      return ThemeMode.light;
    }
  } 

  void changeThemeMode(ThemeMode themeMode) {
    isDarkMode = themeMode == ThemeMode.dark;
    Get.changeThemeMode(themeMode);
    Session.database.customUpdate(
      "UPDATE HIDDEN_SETTINGS SET APP_THEME = '${isDarkMode ? 'dark' : 'light'}'"
    );
  } 
}
