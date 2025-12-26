import 'package:flutter/material.dart';
import 'package:flutter_sqflite/controllers/category_controller.dart';
import 'package:flutter_sqflite/controllers/task_controller.dart';
import 'package:flutter_sqflite/helpera/routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/task_task_dialog.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('tasks'.tr),
        actions: [
         IconButton(
             icon:const Icon(Icons.settings),
             onPressed: ()=>Get.toNamed(AppRoutes.SETTINGS)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GetBuilder<TaskController>(
              builder: (controller) => GetBuilder<CategoryController>(
                builder: (_) => DropdownButtonFormField<String?>(
                  value: controller.selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'category'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text('all'.tr)),
                    ...categoryController.categories.map(
                          (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
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
                  ],
                  onChanged: (value) => controller.setFilter(value),
                ),
              ),
            ),
          ),

          GetBuilder<TaskController>(
            builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    'all'.tr,
                    taskController.filteredTasks.length,
                    Colors.blue,
                  ),
                  _buildStat(
                    'completed'.tr,
                    taskController.completedTasks.length,
                    Colors.green[400],
                  ),
                  _buildStat(
                    'pending'.tr,
                    taskController.pendingTasks.length,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GetBuilder<TaskController>(
              builder: (_) {
                final tasks = taskController.filteredTasks;
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_tasks'.tr,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final category = categoryController.getCategory(
                      task.categoryId ?? '',
                    );


                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) =>
                              taskController.toggleComplete(task.id),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (task.description.isNotEmpty)
                              Text(task.description, maxLines: 2),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (category != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        category.colorValue,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(category.colorValue),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],

                                Text(
                                  DateFormat.yMMMd().format(task.createdAt),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Text(' '),
                                Container(
                                  child: Padding(padding: EdgeInsets.all(3),

                                    child:
                                    Text(
                                      DateFormat('yy-MM-dd').format(task.taskTimeEnd!),
                                      style: const TextStyle(fontSize: 12,color: Colors.black),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDA6C6C),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<int>(
                          onSelected: (value) {
                            if (value == 1) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                    () {
                                  Get.dialog(AddTaskDialog(task: task));
                                },
                              );
                            } else if (value == 2) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                    () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text('delete'.tr),
                                      content: Text('delete_confirm'.tr),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text('cancel'.tr),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            taskController.deleteTask(task.id);
                                             Get.back();
                                            Get.snackbar(
                                              'Success',
                                              'Task deleted',
                                              snackPosition:
                                              SnackPosition.BOTTOM,
                                            );
                                          },
                                          child: Text(
                                            'delete'.tr,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem<int>(
                              value: 1,
                              child: Text('edit'.tr),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Text('delete'.tr),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.dialog(const AddTaskDialog()),
        child: const Icon(Icons.add),
        tooltip: 'add_task'.tr,
      ),
    );
  }
}

Widget _buildStat(String label, int count, Color? color) {
  return Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 12)),
      const SizedBox(height: 4),
      Text(
        count.toString(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}