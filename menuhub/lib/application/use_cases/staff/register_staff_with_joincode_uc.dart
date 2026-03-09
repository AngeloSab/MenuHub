import '../../../domain/hotel_package/staff_role.dart';
import '../../../domain/hotel_package/staff_user.dart';
import '../../../domain/repository/abstract_hotel_repository.dart';
import '../../../domain/repository/abstract_staff_user_repository.dart';

class RegisterStaffWithJoinCodeUC {
  final HotelRepository hotelRepository;
  final StaffUserRepository staffUserRepository;

  RegisterStaffWithJoinCodeUC({
    required this.hotelRepository,
    required this.staffUserRepository,
  });

  Future<StaffUser> execute({
    required String staffUserId,
    required String name,
    required String email,
    required String hotelJoinCode,
  }) async {
    final hotel = await hotelRepository.getByJoinCode(hotelJoinCode);

    if (hotel == null) {
      throw Exception('Nessun hotel trovato con questo join code.');
    }

    final existingStaffUser = await staffUserRepository.getByEmail(email);

    if (existingStaffUser != null) {
      throw Exception('Esiste già uno staff user con questa email.');
    }

    final staffUser = StaffUser(
      id: staffUserId,
      hotelId: hotel.hotelId,
      name: name,
      email: email,
      role: StaffRole.staff,
    );

    await staffUserRepository.save(staffUser);

    return staffUser;
  }
}