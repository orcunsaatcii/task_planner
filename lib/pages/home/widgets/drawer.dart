import 'package:flutter/material.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/pages/calendar/page/calendar_page.dart';
import 'package:task_planner/pages/tasks/page/tasks_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).padding.top * 2),
              color: barColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Image.asset(
                  'assets/images/task.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 40,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Home',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                sizedBoxHeight(10),
                ListTile(
                  leading: const Icon(
                    Icons.task,
                    size: 40,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasksPage(),
                      ),
                    );
                  },
                ),
                sizedBoxHeight(10),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                    size: 40,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'Calendar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
