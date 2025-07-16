// product_river_pod.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final addProductProvider =
StateNotifierProvider<AddProductNotifier, AddProductState>(
      (ref) => AddProductNotifier(),
);

class AddProductState {
  final bool isLoading;
  final String? imageUrl;
  final String? category;

  AddProductState({
    this.isLoading = false,
    this.imageUrl,
    this.category,
  });

  AddProductState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? category,
  }) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}

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
