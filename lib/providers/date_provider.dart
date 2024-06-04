import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateNotifier extends StateNotifier<DateTime> {
  DateNotifier() : super(DateTime.now());

  bool isDateSelected = false;

  void selectDate(DateTime date) {
    state = date;
    isDateSelected = true;
  }

  void toggleIsDateSelected() {
    isDateSelected = false;
  }
}

final dateProvider =
    StateNotifierProvider<DateNotifier, DateTime>((ref) => DateNotifier());
