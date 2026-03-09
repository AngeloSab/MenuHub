import '../domain/hotel_package/hotel.dart';

class HotelFirestoreMapper {
  static Map<String, dynamic> toFirestore(Hotel hotel) => {
    'name': hotel.name,
    'hotelJoinCode': hotel.hotelJoinCode,
  };

  static Hotel fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    return Hotel(
      hotelId: (data['id'] as String?) ?? docId,
      name: data['name'] as String,
      hotelJoinCode: data['hotelJoinCode'] as String,
    );
  }
}