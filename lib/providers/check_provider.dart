import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsCheckNotifier extends StateNotifier<bool> {
  IsCheckNotifier() : super(false);

  void checkIt() {
    state = true;
  }

  void unCheckIt() {
    state = false;
  }
}

final isCheckProvider =
    StateNotifierProvider.family<IsCheckNotifier, bool, String>(
        (ref, key) => IsCheckNotifier());
