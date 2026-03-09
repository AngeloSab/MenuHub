import '../hotel_package/hotel.dart';

abstract class HotelRepository {
  Future<void> save(Hotel hotel);

  Future<Hotel?> getById(String hotelId);

  Future<Hotel?> getByJoinCode(String hotelJoinCode);

  Future<List<Hotel>> getAll();

  Stream<List<Hotel>> watchAll();
}