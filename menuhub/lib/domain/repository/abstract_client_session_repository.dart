import '../client_package/client_session.dart';

abstract class ClientSessionRepository {
  Future<void> save(ClientSession guestSession);

  Future<ClientSession?> getById({
    required String hotelId,
    required String clientSessionId,
  });

  Future<List<ClientSession>> getByHotel(String hotelId);

  Stream<List<ClientSession>> watchByHotel(String hotelId);
}