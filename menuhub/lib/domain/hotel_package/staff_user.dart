import 'package:menuhub/domain/hotel_package/staff_role.dart';

class StaffUser {
  final String id;
  final String hotelId;
  final String name;
  final String email;
  final StaffRole role;

  const StaffUser({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.email,
    required this.role,
  });
}

