import 'package:flutter_riverpod/flutter_riverpod.dart';

final addProductProvider =
    StateNotifierProvider<AddProductNotifier, AddProductState>(
      (ref) => AddProductNotifier(),
    );

class AddProductState {
  final bool isLoading;
  final String? imageUrl;

  AddProductState({this.isLoading = false, this.imageUrl});

  AddProductState copyWith({bool? isLoading, String? imageUrl}) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
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
}
