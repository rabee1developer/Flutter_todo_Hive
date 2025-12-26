import 'package:flutter_sqflite/models/category.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class CategoryController extends GetxController{
  late Box<Category> categoryBox;
@override
  void onInit(){
    super.onInit();
    categoryBox = Hive.box<Category>('categories');
  }

  List<Category> get categories =>categoryBox.values.toList();

  void addCategory(Category category){
    categoryBox.put(category.id, category);
    update();
    Get.snackbar('Success', 'Category added',snackPosition: SnackPosition.BOTTOM);
  }

  void updateCategory(Category category){
    categoryBox.put(category.id, category);
    update();
    Get.snackbar('Success', 'Category updated',snackPosition: SnackPosition.BOTTOM);

  }

  void deleteCategory(String id){
    categoryBox.delete(id);
    update();
    Get.snackbar('Success', 'Category deleted',snackPosition: SnackPosition.BOTTOM);
  }
  Category? getCategory(String id) =>categoryBox.get(id);
}