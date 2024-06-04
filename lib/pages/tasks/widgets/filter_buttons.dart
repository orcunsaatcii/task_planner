import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/providers/active_button_provider.dart';

class FilterButtons extends ConsumerStatefulWidget {
  const FilterButtons({super.key});

  @override
  ConsumerState<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends ConsumerState<FilterButtons> {
  @override
  Widget build(BuildContext context) {
    final activeButton = ref.watch(activeButtonProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              ref
                  .read(activeButtonProvider.notifier)
                  .setActiveButton(ActiveButton.today);
            },
            style: (activeButton == ActiveButton.today)
                ? TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    side: const BorderSide(),
                  )
                : null,
            child: Text(
              'Today',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(activeButtonProvider.notifier)
                  .setActiveButton(ActiveButton.upcoming);
            },
            style: (activeButton == ActiveButton.upcoming)
                ? TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    side: const BorderSide(),
                  )
                : null,
            child: Text(
              'Upcoming',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(activeButtonProvider.notifier)
                  .setActiveButton(ActiveButton.completed);
            },
            style: (activeButton == ActiveButton.completed)
                ? TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    side: const BorderSide(),
                  )
                : null,
            child: Text(
              'Completed Tasks',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(activeButtonProvider.notifier)
                  .setActiveButton(ActiveButton.canceled);
            },
            style: (activeButton == ActiveButton.canceled)
                ? TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    side: const BorderSide(),
                  )
                : null,
            child: Text(
              'Canceled Tasks',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
