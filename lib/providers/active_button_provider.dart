import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActiveButton {
  today,
  upcoming,
  completed,
  canceled,
}

class ActiveButtonNotifier extends StateNotifier<ActiveButton> {
  ActiveButtonNotifier() : super(ActiveButton.today);

  void setActiveButton(ActiveButton activeButton) async {
    state = activeButton;
  }
}

final activeButtonProvider =
    StateNotifierProvider<ActiveButtonNotifier, ActiveButton>(
        (ref) => ActiveButtonNotifier());
