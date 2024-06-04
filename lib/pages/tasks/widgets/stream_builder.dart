import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/pages/tasks/widgets/task_container.dart';
import 'package:task_planner/providers/active_button_provider.dart';

class StatefulStreamBuilder extends ConsumerWidget {
  const StatefulStreamBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeButton = ref.watch(activeButtonProvider);

    return Flexible(
      child: StreamBuilder(
        stream: collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No task found'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          List<QueryDocumentSnapshot> listOfDocuments = [];

          if (activeButton == ActiveButton.today) {
            listOfDocuments = snapshot.data!.docs.where((element) {
              DateTime date = element['date'].toDate();
              DateTime now = DateTime.now();

              return date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
            }).toList();
          } else if (activeButton == ActiveButton.upcoming) {
            listOfDocuments = snapshot.data!.docs
                .where((element) => element['status'] == false)
                .toList();
          } else if (activeButton == ActiveButton.completed) {
            listOfDocuments = snapshot.data!.docs
                .where((element) => element['status'] == true)
                .toList();
          } else if (activeButton == ActiveButton.canceled) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('canceled_tasks')
                  .snapshots(),
              builder: (context, canceledSnapshot) {
                if (canceledSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!canceledSnapshot.hasData ||
                    canceledSnapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No canceled tasks found'),
                  );
                }
                if (canceledSnapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                listOfDocuments = canceledSnapshot.data!.docs;
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: listOfDocuments.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> taskData =
                        listOfDocuments[index].data() as Map<String, dynamic>;
                    return Slidable(
                      closeOnScroll: true,
                      key: ValueKey(listOfDocuments[index]),
                      endActionPane: ActionPane(
                        extentRatio: 0.7,
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              final DocumentReference docRef = await firestore
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
                                  .doc(listOfDocuments[index].id)
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
                      child: TaskContainer(
                        task: listOfDocuments[index].data()
                            as Map<String, dynamic>,
                      ),
                    );
                  },
                );
              },
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: listOfDocuments.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> taskData =
                  listOfDocuments[index].data() as Map<String, dynamic>;
              return Slidable(
                closeOnScroll: true,
                key: ValueKey(listOfDocuments[index]),
                endActionPane: ActionPane(
                  extentRatio: 0.7,
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final DocumentReference docRef =
                            await firestore.collection('canceled_tasks').add({
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
                      backgroundColor: const Color.fromARGB(255, 255, 83, 83),
                      foregroundColor: Colors.white,
                      icon: Icons.cancel,
                      label: 'Cancel',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await firestore
                            .collection('tasks')
                            .doc(listOfDocuments[index].id)
                            .delete();
                      },
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: TaskContainer(
                  task: listOfDocuments[index].data() as Map<String, dynamic>,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
