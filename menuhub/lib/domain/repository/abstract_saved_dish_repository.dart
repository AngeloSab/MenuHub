import '../menu_package/saved_dish.dart';

abstract class SavedDishRepository {
  Future<void> save(SavedDish dish);

  Future<List<SavedDish>> getByHotel(String hotelId);

  Stream<List<SavedDish>> watchByHotel(String hotelId);

  Future<void> delete({
    required String hotelId,
    required String dishId,
  });
}