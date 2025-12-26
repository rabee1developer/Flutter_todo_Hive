import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LocaleController extends GetxController{
  final locale = const Locale('en','US').obs;
  late Box settingsBox;
  @override
  void onInit(){
    super.onInit();
    settingsBox = Hive.box('setting');
    final savedLang = settingsBox.get('language',defaultValue: 'en');
  }

  void changeToEnglish(){
    locale.value = const Locale('en','US');
    settingsBox.put('language', 'en');
    Get.updateLocale(locale.value);
    
  }
  void changeToArabic(){
    locale.value = const Locale('ar','SA');
    settingsBox.put('language', 'ar');
    Get.updateLocale(locale.value);
  }

  bool get isArabic => locale.value.languageCode =='ar';
}