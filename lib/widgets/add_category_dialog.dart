import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';

import '../helpera/themes.dart';
import '../models/category.dart';

class AddCategoryDialog extends StatelessWidget {
  final Function(String) onCategoryAdded;
  AddCategoryDialog({super.key, required this.onCategoryAdded});

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add_category'.tr),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'name'.tr,
            border: const OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final controller = Get.find<CategoryController>();
              final newCategory = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text.trim(),
                colorValue:
                categoryColors[DateTime.now().second %
                    categoryColors.length]
                    .value,
              );

              controller.addCategory(newCategory);
              onCategoryAdded(newCategory.id);
              Navigator.of(context).pop();
            }
          },

          child: Text('save'.tr),
        ),
      ],
    );
  }
}