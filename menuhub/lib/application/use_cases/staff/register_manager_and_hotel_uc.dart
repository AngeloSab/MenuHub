import '../../../domain/hotel_package/hotel.dart';
import '../../../domain/repository/abstract_hotel_repository.dart';
import '../../../domain/repository/abstract_staff_user_repository.dart';
import '../../../domain/hotel_package/staff_role.dart';
import '../../../domain/hotel_package/staff_user.dart';

class RegisterManagerAndHotelUC {
  final HotelRepository hotelRepository;
  final StaffUserRepository staffUserRepository;

  RegisterManagerAndHotelUC({
    required this.hotelRepository,
    required this.staffUserRepository,
  });

  Future<void> execute({
    required String hotelId,
    required String hotelName,
    required String hotelJoinCode,
    required String managerId,
    required String managerName,
    required String managerEmail,
  }) async {
    final existingHotel = await hotelRepository.getByJoinCode(hotelJoinCode);

    if (existingHotel != null) {
      throw Exception('Esiste già un hotel con questo join code.');
    }

    final existingStaffUser = await staffUserRepository.getByEmail(managerEmail);

    if (existingStaffUser != null) {
      throw Exception('Esiste già uno staff user con questa email.');
    }

    final hotel = Hotel(
      hotelId: hotelId,
      name: hotelName,
      hotelJoinCode: hotelJoinCode,
    );

    final manager = StaffUser(
      id: managerId,
      hotelId: hotelId,
      name: managerName,
      email: managerEmail,
      role: StaffRole.manager,
    );

    await hotelRepository.save(hotel);
    await staffUserRepository.save(manager);
  }
}