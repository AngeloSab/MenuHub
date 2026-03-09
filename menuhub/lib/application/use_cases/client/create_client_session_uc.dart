import '../../../domain/client_package/client_session.dart';
import '../../../domain/repository/abstract_client_session_repository.dart';

class CreateClientSessionUC {
  final ClientSessionRepository clientSessionRepository;

  CreateClientSessionUC(this.clientSessionRepository);

  Future<ClientSession> execute({
    required String id,
    required String hotelId,
    required String roomNumber,
    required String reservationName,
    required int peopleCount,
  }) async {
    final clientSession = ClientSession(
      id: id,
      hotelId: hotelId,
      roomNumber: roomNumber,
      name: reservationName,
      peopleCount: peopleCount,
    );

    await clientSessionRepository.save(clientSession);

    return clientSession;
  }
}