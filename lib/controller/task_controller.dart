import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/model/task_model.dart';

class TaskController extends GetxController {
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> categories = ['Work', 'Personal', 'Other'];
  RxString selectedCategory = 'Work'.obs;
  RxInt selectedCategoryIndex = 0.obs;
    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();


  RxList<TaskModel> workTasks = <TaskModel>[].obs;
  RxList<TaskModel> personalTasks = <TaskModel>[].obs;
  RxList<TaskModel> otherTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllDatas();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Future<bool> getAllDatas() async {
    try {
      final taskDB = await Hive.openBox<TaskModel>('task_db');
      taskList.clear();
      taskList.addAll(taskDB.values);
      filterTasksByCategory();
      log('refreshed');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTask(TaskModel value) async {
    bool response = false;
    try {
      final taskDB = await Hive.openBox<TaskModel>('task_db');
      taskDB.put(value.id, value);
      response = await getAllDatas();
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteData(int id) async {
    try {
      final taskDB = await Hive.openBox<TaskModel>('task_db');
      await taskDB.deleteAt(id);
      await getAllDatas();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(int id, TaskModel value) async {
    try {
      final habitsDB = await Hive.openBox<TaskModel>('task_db');
      habitsDB.putAt(id, value);
      await getAllDatas();
      return true;
    } catch (e) {
      return false;
    }
  }

  void filterTasksByCategory() {
    log(taskList.length.toString());
    workTasks.clear();
    personalTasks.clear();
    otherTasks.clear();

    workTasks
        .addAll(taskList.where((task) => task.category == 'Work').toList());
    personalTasks
        .addAll(taskList.where((task) => task.category == 'Personal').toList());
    otherTasks
        .addAll(taskList.where((task) => task.category == 'Other').toList());
  }
}
