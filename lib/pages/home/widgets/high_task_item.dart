import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/constants/constants.dart';

class HighTaskItem extends ConsumerStatefulWidget {
  const HighTaskItem({super.key, required this.task});

  final Map<String, dynamic> task;

  @override
  ConsumerState<HighTaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<HighTaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final categoryTextColor = categoryTextColors[widget.task['category']];
    final categoryColor = categoryTextColor!.withOpacity(0.5);
    final screenWidth = MediaQuery.of(context).size.width;
    final DateTime dateData = widget.task['date'].toDate();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      alignment: (isChecked) ? Alignment.center : Alignment.topCenter,
      width: (isChecked) ? 0 : screenWidth * 0.6,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isChecked ? 0 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7.0,
                        vertical: 5.0,
                      ),
                      child: Text(
                        widget.task['category'],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: categoryTextColor,
                            ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      key: ValueKey(widget.task),
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
              const Spacer(),
              Text(
                widget.task['title'],
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              sizedBoxHeight(5),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: iconColor,
                  ),
                  sizedBoxWidth(5),
                  Text(
                    '${dateData.month}/${dateData.day}/${dateData.year}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: subtitleColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
