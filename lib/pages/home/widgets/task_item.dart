import 'package:flutter/material.dart';
import 'package:task_planner/constants/constants.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task});

  final Map<String, dynamic> task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      alignment: (isChecked) ? Alignment.center : Alignment.topCenter,
      width: (isChecked) ? 0 : 500,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isChecked ? 0 : 1,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  widget.task['title'],
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  checkColor: iconColor,
                  activeColor: backgroundColor,
                  side: const BorderSide(
                    color: iconColor,
                  ),
                  value: isChecked,
                  onChanged: (newBool) {
                    setState(() {
                      isChecked = newBool!;
                    });
                    Future.delayed(
                      const Duration(milliseconds: 700),
                      () {
                        collectionReference
                            .doc(widget.task['id'])
                            .update({'status': newBool});
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
      ),
    );
  }
}
