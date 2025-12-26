import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'add_category_dialog.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? task;
  const AddTaskDialog({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedCategoryId;

  final _dateController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    // تعبئة الحقول إذا كانت المهمة موجودة (تعديل)
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedCategoryId = widget.task!.categoryId;
      _selectedDateTime = widget.task!.taskTimeEnd;

      _dateController.text =
      "${_selectedDateTime!.year}-"
          "${_selectedDateTime!.month.toString().padLeft(2,'0')}-"
          "${_selectedDateTime!.day.toString().padLeft(2,'0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final taskController = Get.find<TaskController>();
    final isEdit = widget.task != null;

    return AlertDialog(
      title: Text(isEdit ? 'edit_task'.tr : 'add_task'.tr),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// العنوان
            TextFormField(
              controller: _titleController,
              autofocus: !isEdit,
              decoration: InputDecoration(
                labelText: 'title'.tr,
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            /// الوصف
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'description'.tr,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            /// اختيار الفئة
            GetBuilder<CategoryController>(
              builder: (_) {
                final items = <DropdownMenuItem<String?>>[
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('no_category'.tr),
                  ),
                  ...categoryController.categories.map(
                        (cat) => DropdownMenuItem<String?>(
                      value: cat.id,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(cat.colorValue),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(cat.name),
                        ],
                      ),
                    ),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'add_new_category_option',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'add_category'.tr,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ];

                return DropdownButtonFormField<String?>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'category'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  items: items,
                  onChanged: (value) async {
                    if (value == 'add_new_category_option') {
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (!context.mounted) return;
                      await Get.dialog(
                        AddCategoryDialog(
                          onCategoryAdded: (newId) {
                            setState(() {
                              _selectedCategoryId = newId;
                            });
                          },
                        ),
                      );
                    } else {
                      setState(() => _selectedCategoryId = value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'date'.tr,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDateTime ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    _selectedDateTime = pickedDate;
                    _dateController.text =
                    "${pickedDate.year}-"
                        "${pickedDate.month.toString().padLeft(2,'0')}-"
                        "${pickedDate.day.toString().padLeft(2,'0')}";
                  });
                }
              },
            ),

            /// اختيار التاريخ
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {

            if (_formKey.currentState!.validate()) {
              final newTask = Task(
                id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                categoryId: _selectedCategoryId,
                isCompleted: widget.task?.isCompleted ?? false,
                createdAt: widget.task?.createdAt ?? DateTime.now(),
                taskTimeEnd: _selectedDateTime,
              );

              final taskController = Get.find<TaskController>();
              if (widget.task != null) {
                taskController.updateTask(newTask);
              } else {
                taskController.addTask(newTask);
              }

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Text('save'.tr),
        ),
      ],
    );
  }
}
