import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/constants/constants.dart';

class CanceledTasksNotifier extends StateNotifier<int> {
  CanceledTasksNotifier() : super(0) {
    _fetchCanceledTasks();
  }

  void _fetchCanceledTasks() {
    firestore.collection('canceled_tasks').snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          state = snapshot.docs.length;
        } else {
          state = 0;
        }
      },
    );
  }
}

final canceledTasksProvider = StateNotifierProvider<CanceledTasksNotifier, int>(
  (ref) => CanceledTasksNotifier(),
);
