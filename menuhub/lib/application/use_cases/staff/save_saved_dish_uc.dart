import '../../../domain/menu_package/saved_dish.dart';
import '../../../domain/repository/abstract_saved_dish_repository.dart';

class SaveSavedDishUC {
  final SavedDishRepository repository;

  SaveSavedDishUC(this.repository);

  Future<void> execute(SavedDish dish) async {
    if (dish.name.trim().isEmpty) {
      throw Exception('Il nome del piatto non può essere vuoto');
    }

    await repository.save(dish);
  }
}