import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/view/widgets/input_field.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskCtrl = Get.find<TaskController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputField(
            hint: 'Task Title',
            controller: taskCtrl.titleController,
          ),
          const SizedBox(height: 16.0),
          InputField(
            hint: 'Description',
            maxLines: 3,
            controller: taskCtrl.descriptionController,
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: taskCtrl.selectedCategory.value,
            items: taskCtrl.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              taskCtrl.selectedCategory.value = value!;
            },
            decoration: InputDecoration(
              hintStyle:
                  const TextStyle(color: AppColors.hintTextColor, fontSize: 14),
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () async {
              await onSubmit(taskCtrl);
            },
            child: const Text(
              'Save Task',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit(TaskController taskCtrl) async {
    if (taskCtrl.titleController.text.isNotEmpty) {
      if (taskCtrl.descriptionController.text.isNotEmpty) {
        final taskData = TaskModel(
            id: DateTime.now().toString(),
            title: taskCtrl.titleController.text.trim(),
            description: taskCtrl.descriptionController.text.trim(),
            category: taskCtrl.selectedCategory.value,
            status: false);
        final result = await taskCtrl
            .addTask(taskData)
            .then((value) => taskCtrl.getAllDatas());
        if (result) {
          taskCtrl.titleController.text = '';
          taskCtrl.descriptionController.text = '';
          Get.back();
        } else {
          Get.snackbar('Failed', 'Please try again');
        }
      } else {
        Get.snackbar(
            'Description is missing', 'Please Enter a task Description');
      }
    } else {
      Get.snackbar('Title is missing', 'Please Enter a task title');
    }
  }
}
