import '../../../domain/repository/abstract_saved_dish_repository.dart';

class DeleteSavedDishUC {
  final SavedDishRepository repository;

  DeleteSavedDishUC(this.repository);

  Future<void> execute({
    required String hotelId,
    required String dishId,
  }) async {
    await repository.delete(
      hotelId: hotelId,
      dishId: dishId,
    );
  }
}