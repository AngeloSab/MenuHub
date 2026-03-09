import '../domain/client_package/client_session.dart';

class ClientSessionFirestoreMapper {
  static Map<String, dynamic> toFirestore(ClientSession clientSession) => {
    'hotelId': clientSession.hotelId,
    'roomNumber': clientSession.roomNumber,
    'reservationName': clientSession.name,
    'peopleCount': clientSession.peopleCount,
  };

  static ClientSession fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    return ClientSession(
      id: (data['id'] as String?) ?? docId,
      hotelId: data['hotelId'] as String,
      roomNumber: data['roomNumber'] as String,
      name: data['reservationName'] as String,
      peopleCount: data['peopleCount'] as int,
    );
  }
}