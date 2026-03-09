class ClientMenuModel {
  final String dishId;
  final int quantity;
  final String variation;
  final bool isVariationVisible;

  const ClientMenuModel({
    required this.dishId,
    required this.quantity,
    required this.variation,
    required this.isVariationVisible,
  });

  factory ClientMenuModel.initial(String dishId) {
    return ClientMenuModel(
      dishId: dishId,
      quantity: 0,
      variation: '',
      isVariationVisible: false,
    );
  }

  ClientMenuModel copyWith({
    String? dishId,
    int? quantity,
    String? variation,
    bool? isVariationVisible,
  }) {
    return ClientMenuModel(
      dishId: dishId ?? this.dishId,
      quantity: quantity ?? this.quantity,
      variation: variation ?? this.variation,
      isVariationVisible: isVariationVisible ?? this.isVariationVisible,
    );
  }
}