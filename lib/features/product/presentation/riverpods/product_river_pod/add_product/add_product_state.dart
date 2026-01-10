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
