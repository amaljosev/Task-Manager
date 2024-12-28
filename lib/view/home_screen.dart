import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/view/widgets/category_widget.dart';
import 'package:task_manager/view/widgets/empty_widget.dart';
import 'package:task_manager/view/widgets/task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final taskCtrl = Get.put(TaskController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomScrollView(
            slivers: [
              const CategoryWidget(),
              taskCtrl.selectedCategoryIndex.value == 0 &&
                      taskCtrl.workTasks.isEmpty
                  ? EmptyWidget(
                      size: size,
                      title: 'No Work Tasks Found',
                    )
                  : taskCtrl.selectedCategoryIndex.value == 1 &&
                          taskCtrl.personalTasks.isEmpty
                      ? EmptyWidget(
                          size: size,
                          title: 'No Personal Tasks Found',
                        )
                      : taskCtrl.selectedCategoryIndex.value == 2 &&
                              taskCtrl.otherTasks.isEmpty
                          ? EmptyWidget(
                              size: size,
                              title: 'No Other Tasks Found',
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  late TaskModel task;
                                  task = taskCtrl.selectedCategoryIndex.value ==
                                          0
                                      ? taskCtrl.workTasks[index]
                                      : taskCtrl.selectedCategoryIndex.value ==
                                              1
                                          ? taskCtrl.personalTasks[index]
                                          : taskCtrl.otherTasks[index];

                                  return AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          MediaQuery.of(context).size.width *
                                              (1.0 - _animation.value),
                                          0,
                                        ),
                                        child: Opacity(
                                          opacity: _animation.value,
                                          child: TaskWidget(
                                            task: task,
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: taskCtrl
                                            .selectedCategoryIndex.value ==
                                        0
                                    ? taskCtrl.workTasks.length
                                    : taskCtrl.selectedCategoryIndex.value == 1
                                        ? taskCtrl.personalTasks.length
                                        : taskCtrl.otherTasks.length,
                              ),
                            ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => Get.toNamed('/add_task'),
        tooltip: 'Add Task',
        child:  Icon(Icons.add,color: AppColors.backgroundColor,),
      ),
    );
  }
}
