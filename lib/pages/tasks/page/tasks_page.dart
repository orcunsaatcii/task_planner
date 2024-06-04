import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/pages/tasks/widgets/filter_buttons.dart';
import 'package:task_planner/pages/tasks/widgets/stream_builder.dart';
import 'package:task_planner/providers/active_button_provider.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  @override
  void initState() {
    ref.read(activeButtonProvider.notifier).setActiveButton(ActiveButton.today);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeButton = ref.watch(activeButtonProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${activeButton.name.replaceFirst(activeButton.name[0], activeButton.name[0].toUpperCase())} Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            const FilterButtons(),
            sizedBoxHeight(15),
            const StatefulStreamBuilder(),
          ],
        ),
      ),
    );
  }
}
