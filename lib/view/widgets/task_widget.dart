import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'package:task_manager/model/task_model.dart';

import '../../core/app_colors.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.index,
  });

  final TaskModel task;
  final int index;

  @override
  Widget build(BuildContext context) {
    final taskCtrl = Get.find<TaskController>();
    return Dismissible(
      key: Key('${task.id}-${task.category}'),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final dismissedTask = task;
          await taskCtrl.deleteData(index).then(
                (value) => Get.snackbar('Deleted', 'Your task is Deleted',
                    mainButton: TextButton(
                        onPressed: () {
                          taskCtrl.addTask(dismissedTask);
                        },
                        child: const Text('UNDO')),
                    duration: const Duration(seconds: 4)),
              );
        } else if (direction == DismissDirection.endToStart) {
          if (task.status) {
            log('Task is already completed');
            return;
          }
          final taskData = TaskModel(
            id: DateTime.now().toString(),
            title: task.title,
            description: task.description,
            category: task.category,
            status: true,
          );
          await taskCtrl.deleteData(index).then(
                (value) => taskCtrl.addTask(taskData),
              );
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      child: Card.outlined(
        color: AppColors.backgroundColor,
        elevation: 3,
        child: Tooltip(
          message: 'Swipe left to complete task',
          child: ListTile(
            title: Text(task.title,style: const TextStyle(
              fontWeight: FontWeight.bold
            ),),
            subtitle: Text(task.description),
            trailing: Icon(
                task.status
                    ? Icons.check_circle_outline_sharp
                    : Icons.radio_button_unchecked,
                color: task.status ? Colors.green : Colors.grey),
          ),
        ),
      ),
    );
  }
}
