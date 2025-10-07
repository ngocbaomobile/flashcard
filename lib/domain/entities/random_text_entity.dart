class RandomTextEntity {
  final List<String> items;
  final String selectedItem;
  final bool isShuffling;

  const RandomTextEntity({
    required this.items,
    required this.selectedItem,
    required this.isShuffling,
  });

  RandomTextEntity copyWith({
    List<String>? items,
    String? selectedItem,
    bool? isShuffling,
  }) {
    return RandomTextEntity(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      isShuffling: isShuffling ?? this.isShuffling,
    );
  }
}
