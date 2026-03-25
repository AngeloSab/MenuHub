import '../../../../domain/menu_package/saved_dish.dart';

class SavedDishModel {
  final bool isLoading;
  final List<SavedDish> dishes;
  final String? errorMessage;

  const SavedDishModel({
    required this.isLoading,
    required this.dishes,
    this.errorMessage,
  });

  factory SavedDishModel.initial() {
    return const SavedDishModel(
      isLoading: true,
      dishes: [],
      errorMessage: null,
    );
  }

  SavedDishModel copyWith({
    bool? isLoading,
    List<SavedDish>? dishes,
    String? errorMessage,
  }) {
    return SavedDishModel(
      isLoading: isLoading ?? this.isLoading,
      dishes: dishes ?? this.dishes,
      errorMessage: errorMessage,
    );
  }
}