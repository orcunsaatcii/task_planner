import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/providers/canceled_tasks_provider.dart';

class TaskStatus extends ConsumerStatefulWidget {
  const TaskStatus({super.key, required this.icon, required this.statusText});

  final Icon icon;
  final String statusText;

  @override
  ConsumerState<TaskStatus> createState() => _TaskStatusState();
}

class _TaskStatusState extends ConsumerState<TaskStatus> {
  @override
  Widget build(BuildContext context) {
    final canceledTasks = ref.watch(canceledTasksProvider);
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something get wrong'),
          );
        }

        List<QueryDocumentSnapshot> documentsList = snapshot.data!.docs;
        var completedTasks =
            documentsList.where((element) => element['status'] == true).length;
        var inProgressTasks =
            documentsList.where((element) => element['status'] == false).length;

        return Column(
          children: [
            Row(
              children: [
                widget.icon,
                sizedBoxHeight(5),
                Text(
                  widget.statusText == 'In progress'
                      ? inProgressTasks.toString()
                      : widget.statusText == 'Completed'
                          ? completedTasks.toString()
                          : canceledTasks.toString(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Text(
              widget.statusText,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        );
      },
    );
  }
}
