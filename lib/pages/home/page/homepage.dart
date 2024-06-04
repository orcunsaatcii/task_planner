import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/pages/add/page/add_task_page.dart';
import 'package:task_planner/pages/home/widgets/drawer.dart';
import 'package:task_planner/pages/home/widgets/high_task_item.dart';
import 'package:task_planner/pages/home/widgets/task_item.dart';
import 'package:task_planner/pages/home/widgets/task_status.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _addNewTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddTaskPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: barColor,
        actions: [
          IconButton(
            onPressed: _addNewTask,
            icon: const Icon(
              Icons.add,
              size: 35,
              color: iconColor,
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      width: double.infinity,
                      height: 210,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task Status',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: subtitleColor,
                                  ),
                            ),
                            sizedBoxHeight(10),
                            const Divider(),
                            sizedBoxHeight(10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TaskStatus(
                                  icon: inProgressIcon,
                                  statusText: 'In progress',
                                ),
                                TaskStatus(
                                  icon: completedIcon,
                                  statusText: 'Completed',
                                ),
                                TaskStatus(
                                  icon: canceledIcon,
                                  statusText: 'Canceled',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(15),
              Row(
                children: [
                  Text(
                    'High Priority',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: subtitleColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                stream: collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 60),
                        child: Text('No task found'),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  List<QueryDocumentSnapshot> listOftasks = snapshot.data!.docs
                      .where((e) =>
                          e['priority'] == 'HIGH' && e['status'] == false)
                      .toList();
                  if (listOftasks.isNotEmpty) {
                    return SizedBox(
                      height: screenHeight * 0.2,
                      child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: listOftasks.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> taskData = listOftasks[index]
                                .data() as Map<String, dynamic>;
                            return Slidable(
                              closeOnScroll: true,
                              direction: Axis.vertical,
                              key: ValueKey(listOftasks[index]),
                              endActionPane: ActionPane(
                                extentRatio: 0.7,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      final DocumentReference docRef =
                                          await firestore
                                              .collection('canceled_tasks')
                                              .add({
                                        'title': taskData['title'],
                                        'status': false,
                                        'category': taskData['category'],
                                        'priority': taskData['priority'],
                                        'date': taskData['date'],
                                      });
                                      await docRef.update({'id': docRef.id});
                                      await firestore
                                          .collection('tasks')
                                          .doc(taskData['id'])
                                          .delete();
                                    },
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 83, 83),
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel,
                                    label: 'Cancel',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await firestore
                                          .collection('tasks')
                                          .doc(listOftasks[index].id)
                                          .delete();
                                    },
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 0, 0),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: HighTaskItem(
                                key: ValueKey(listOftasks[index]),
                                task: listOftasks[index].data()
                                    as Map<String, dynamic>,
                              ),
                            );
                          }),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text('No task yet'),
                      ),
                    );
                  }
                },
              ),
              sizedBoxHeight(15),
              Text(
                'Tasks',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              sizedBoxHeight(5),
              StreamBuilder(
                stream: collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 60),
                        child: Text('No task found'),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  List<QueryDocumentSnapshot> listOftasks = snapshot.data!.docs
                      .where((element) => element['status'] == false)
                      .toList();
                  return SizedBox(
                    height: screenHeight * 0.5,
                    child: ListView.separated(
                      itemCount: listOftasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> taskData =
                            listOftasks[index].data() as Map<String, dynamic>;
                        return Slidable(
                          closeOnScroll: true,
                          key: ValueKey(listOftasks[index]),
                          endActionPane: ActionPane(
                            extentRatio: 0.7,
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  final DocumentReference docRef =
                                      await firestore
                                          .collection('canceled_tasks')
                                          .add({
                                    'title': taskData['title'],
                                    'status': false,
                                    'category': taskData['category'],
                                    'priority': taskData['priority'],
                                    'date': taskData['date'],
                                  });
                                  await docRef.update({'id': docRef.id});
                                  await firestore
                                      .collection('tasks')
                                      .doc(taskData['id'])
                                      .delete();
                                },
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 83, 83),
                                foregroundColor: Colors.white,
                                icon: Icons.cancel,
                                label: 'Cancel',
                              ),
                              SlidableAction(
                                onPressed: (context) async {
                                  await firestore
                                      .collection('tasks')
                                      .doc(listOftasks[index].id)
                                      .delete();
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: TaskItem(
                            task: taskData,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
