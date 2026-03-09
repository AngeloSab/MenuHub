import '../hotel_package/staff_user.dart';

abstract class StaffUserRepository {
  Future<void> save(StaffUser staffUser);

  Future<StaffUser?> getById(String staffUserId);

  Future<List<StaffUser>> getByHotel(String hotelId);

  Stream<List<StaffUser>> watchByHotel(String hotelId);

  Future<StaffUser?> getByEmail(String email);
}