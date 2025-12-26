import 'package:flutter_sqflite/controllers/category_controller.dart';
import 'package:flutter_sqflite/controllers/task_controller.dart';
import 'package:flutter_sqflite/helpera/routes.dart';
import 'package:flutter_sqflite/screens/category_list_screen.dart';
import 'package:flutter_sqflite/screens/settings_screen.dart';
import 'package:flutter_sqflite/screens/task_list_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.TASKS, page: ()=> TaskListScreen(),binding: BindingsBuilder((){
      Get.lazyPut(()=> TaskController());
      Get.lazyPut(()=> CategoryController());
    })),
    GetPage(name: AppRoutes.CATEGORIES, page: ()=> CategoryListScreen(),binding: BindingsBuilder((){
      Get.lazyPut(()=> CategoryController());
      Get.lazyPut(()=>TaskController());
    })),
    GetPage(name: AppRoutes.SETTINGS, page: ()=> SettingsScreen()),
  ];
}