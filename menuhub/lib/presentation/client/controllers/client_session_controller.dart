import 'package:flutter/material.dart';
import 'package:menuhub/application/use_cases/client/create_client_session_uc.dart';
import 'package:menuhub/domain/client_package/client_session.dart';
import 'package:menuhub/local/client_session_local_repository.dart';

class ClientSessionController extends ChangeNotifier {
  final String hotelId;
  final CreateClientSessionUC createClientSessionUC;
  final ClientSessionLocalRepository localRepository;

  bool _isSubmitting = false;

  ClientSessionController({
    required this.hotelId,
    required this.createClientSessionUC,
    required this.localRepository,
  });

  bool get isSubmitting => _isSubmitting;

  String? validateRoomNumber(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Inserisci il numero della camera';
    }
    return null;
  }

  String? validateReservationName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Inserisci il nome della prenotazione';
    }
    return null;
  }

  String? validatePeopleCount(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Inserisci il numero di persone';
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Inserisci un numero valido';
    }

    return null;
  }

  String _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<ClientSession> submit({
    required String roomNumber,
    required String reservationName,
    required String peopleCountText,
  }) async {
    if (_isSubmitting) {
      throw StateError('Creazione sessione già in corso.');
    }

    final peopleCount = int.parse(peopleCountText.trim());

    _isSubmitting = true;
    notifyListeners();

    try {
      final session = await createClientSessionUC.execute(
        id: _generateSessionId(),
        hotelId: hotelId,
        roomNumber: roomNumber.trim(),
        reservationName: reservationName.trim(),
        peopleCount: peopleCount,
      );

      await localRepository.save(session);

      return session;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}