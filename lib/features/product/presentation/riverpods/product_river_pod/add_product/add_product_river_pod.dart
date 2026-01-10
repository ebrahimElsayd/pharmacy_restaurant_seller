import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_product_state.dart';

final addProductProvider =
    StateNotifierProvider<AddProductNotifier, AddProductState>(
      (ref) => AddProductNotifier(),
    );

class AddProductNotifier extends StateNotifier<AddProductState> {
  AddProductNotifier() : super(AddProductState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setImageUrl(String url) {
    state = state.copyWith(imageUrl: url);
  }

  void setCategory(String? newCategory) {
    state = state.copyWith(category: newCategory);
  }
}
