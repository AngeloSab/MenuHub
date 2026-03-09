import 'package:flutter/material.dart';
import 'package:menuhub/domain/client_package/client_session.dart';

typedef LoadSavedClientSessionByHotelId = Future<ClientSession?> Function(
  String hotelId,
);

class ClientEntryController extends ChangeNotifier {
  final LoadSavedClientSessionByHotelId loadSavedClientSessionByHotelId;

  bool _isLoading = false;
  String? _errorMessage;

  ClientEntryController({
    required this.loadSavedClientSessionByHotelId,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? readHotelIdFromUrl() {
    final hotelId = Uri.base.queryParameters['hotelId']?.trim();

    if (hotelId == null || hotelId.isEmpty) {
      _errorMessage = 'QR code non valido: hotelId mancante.';
      notifyListeners();
      return null;
    }

    _errorMessage = null;
    return hotelId;
  }

  Future<ClientSession?> resolveSavedClientSession(String hotelId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await loadSavedClientSessionByHotelId(hotelId);
    } catch (e) {
      _errorMessage = 'Errore durante il caricamento della sessione locale.';
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}