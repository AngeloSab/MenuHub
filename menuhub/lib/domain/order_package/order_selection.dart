class OrderSelection {
  final String courseId;
  final String dishId;
  final String? variations;
  final int quantity;

  const OrderSelection({
    required this.courseId,
    required this.dishId,
    this.variations,
    required this.quantity,
  }) : assert(quantity > 0, 'La quantity deve essere maggiore di 0');
}