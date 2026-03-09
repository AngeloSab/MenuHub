import '../domain/hotel_package/staff_role.dart';
import '../domain/hotel_package/staff_user.dart';

class StaffUserFirestoreMapper {
  static Map<String, dynamic> toFirestore(StaffUser staffUser) => {
    'hotelId': staffUser.hotelId,
    'name': staffUser.name,
    'email': staffUser.email,
    'role': _roleToString(staffUser.role),
  };

  static StaffUser fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    return StaffUser(
      id: (data['id'] as String?) ?? docId,
      hotelId: data['hotelId'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      role: _roleFromString(data['role'] as String),
    );
  }

  static String _roleToString(StaffRole role) {
    switch (role) {
      case StaffRole.manager:
        return 'manager';
      case StaffRole.staff:
        return 'staff';
    }
  }

  static StaffRole _roleFromString(String value) {
    switch (value) {
      case 'manager':
        return StaffRole.manager;
      case 'staff':
        return StaffRole.staff;
      default:
        throw Exception('StaffRole non valido: $value');
    }
  }
}