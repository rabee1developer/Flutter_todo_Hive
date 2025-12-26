import 'package:flutter/material.dart';
import 'package:flutter_sqflite/controllers/locale_controller.dart';
import 'package:flutter_sqflite/controllers/theme_controller.dart';
import 'package:flutter_sqflite/helpera/app_pages.dart';
import 'package:flutter_sqflite/helpera/routes.dart';
import 'package:flutter_sqflite/helpera/themes.dart';
import 'package:flutter_sqflite/helpera/translations.dart';
import 'package:flutter_sqflite/models/category.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/task.dart'; // يفضل استخدام هذا الاستيراد الشامل
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // تسجيل Adapters بشكل آمن
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(TaskAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CategoryAdapter());

  // فتح الصناديق
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Category>('categories');
  await Hive.openBox('setting');

  Get.put(ThemeController());

  // يمكن وضع Controllers هنا أيضاً لتجنب مشاكل الوصول المبكر
  Get.put(LocaleController());

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());
    Get.put(LocaleController());
    
    return Obx(()=> GetMaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: Get.find<ThemeController>().themeMode,
      translations: AppTranslations(),
      locale: Get.find<LocaleController>().locale.value,
      fallbackLocale: const Locale('en','US'),
      initialRoute: AppRoutes.TASKS,

      // تصحيح الهيكل:
      // قمنا بإزالة الـ Scaffold والـ AppBar من هنا لأن HomePage تحتوي عليهم بالفعل

      getPages: AppPages.pages,
    )
    );
  }
}

