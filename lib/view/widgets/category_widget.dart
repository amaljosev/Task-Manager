import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller/task_controller.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskCtrl = Get.find<TaskController>();
    return Obx(() => SliverToBoxAdapter(
        child: Row(
      children: List.generate(
        taskCtrl.categories.length,
        (index) => InkWell(
          onTap: () => taskCtrl.selectedCategoryIndex.value = index,
          child: Card(
            color: index == taskCtrl.selectedCategoryIndex.value
                ? Colors.blue
                : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  taskCtrl.categories[index],
                  style: TextStyle(
                      color: index == taskCtrl.selectedCategoryIndex.value
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    )),);
  }
}
