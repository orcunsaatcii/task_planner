import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/providers/active_button_provider.dart';

class TaskContainer extends ConsumerStatefulWidget {
  const TaskContainer({super.key, required this.task});

  final Map<String, dynamic> task;

  @override
  ConsumerState<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends ConsumerState<TaskContainer> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final activeButton = ref.watch(activeButtonProvider);
    final DateTime dateData = widget.task['date'].toDate();
    return AnimatedContainer(
      key: ValueKey(widget.task['id']),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      alignment: (isChecked) ? Alignment.center : Alignment.topCenter,
      width: (isChecked) ? 0 : 500,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (widget.task['priority'] == 'HIGH')
            ? highTaskContainerColor
            : (widget.task['priority'] == 'MEDIUM')
                ? mediumTaskContainerColor
                : lowTaskContainerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isChecked ? 0 : 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.task['title'],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    sizedBoxWidth(10),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: (widget.task['priority'] == 'HIGH')
                            ? Colors.red
                            : (widget.task['priority'] == 'MEDIUM')
                                ? Colors.yellow
                                : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          widget.task['priority'],
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(10),
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    sizedBoxWidth(5),
                    Text(
                      '${dateData.month}/${dateData.day}/${dateData.year}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
            if (!(activeButton == ActiveButton.completed ||
                activeButton == ActiveButton.canceled))
              Transform.scale(
                scale: 1.4,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                    Future.delayed(
                      const Duration(milliseconds: 700),
                      () {
                        collectionReference
                            .doc(widget.task['id'])
                            .update({'status': value});
                      },
                    );
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Text('Task Completed'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                collectionReference
                                    .doc(widget.task['id'])
                                    .update({'status': false});
                              },
                              child: const Text('Undo'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
