import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Priorities {
  high,
  medium,
  low,
}

Map<Priorities, Color> priorityColors = {
  Priorities.high: Colors.red,
  Priorities.medium: Colors.yellow,
  Priorities.low: Colors.green
};

class PrioritySelectNotifier extends StateNotifier<Priorities> {
  PrioritySelectNotifier() : super(Priorities.low);

  void selectPriority(Priorities priority) {
    state = priority;
  }
}

final prioritySelectProvider =
    StateNotifierProvider<PrioritySelectNotifier, Priorities>(
        (ref) => PrioritySelectNotifier());
