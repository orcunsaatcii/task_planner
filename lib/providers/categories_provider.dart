import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Categories {
  finance,
  entertainment,
  work,
  personal,
  health,
}

class CategoriesSelectNotifier extends StateNotifier<Categories> {
  CategoriesSelectNotifier() : super(Categories.finance);

  void selectCategory(Categories category) {
    state = category;
  }
}

final categorySelectProvider =
    StateNotifierProvider<CategoriesSelectNotifier, Categories>(
        (ref) => CategoriesSelectNotifier());
