import '../../../domain/menu_package/saved_dish.dart';
import '../../../domain/repository/abstract_saved_dish_repository.dart';

class WatchSavedDishesUC {
  final SavedDishRepository repository;

  WatchSavedDishesUC(this.repository);

  Stream<List<SavedDish>> execute(String hotelId) {
    return repository.watchByHotel(hotelId);
  }
}