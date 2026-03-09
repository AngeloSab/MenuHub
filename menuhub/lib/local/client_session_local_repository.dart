import 'dart:convert';
import 'package:menuhub/domain/client_package/client_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientSessionLocalRepository {
  static const String _storageKeyPrefix = 'menuhub_client_session';

  String _storageKeyForHotel(String hotelId) {
    return '${_storageKeyPrefix}_$hotelId';
  }

  Future<void> save(ClientSession session) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode({
      'id': session.id,
      'hotelId': session.hotelId,
      'roomNumber': session.roomNumber,
      'name': session.name,
      'peopleCount': session.peopleCount,
    });

    await prefs.setString(_storageKeyForHotel(session.hotelId), jsonString);
  }

  Future<ClientSession?> loadByHotelId(String hotelId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKeyForHotel(hotelId));

    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    final Map<String, dynamic> map = jsonDecode(jsonString);

    return ClientSession(
      id: map['id'] as String,
      hotelId: map['hotelId'] as String,
      roomNumber: map['roomNumber'] as String,
      name: map['name'] as String,
      peopleCount: map['peopleCount'] as int,
    );
  }

  Future<void> clearByHotelId(String hotelId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKeyForHotel(hotelId));
  }
}