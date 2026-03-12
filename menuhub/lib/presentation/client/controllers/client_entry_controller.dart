import 'package:flutter/material.dart';
import 'package:menuhub/application/use_cases/client/get_open_menus_uc.dart';
import 'package:menuhub/domain/client_package/client_session.dart';
import 'package:menuhub/domain/menu_package/menu.dart';
import '../models/client_entry_resolution.dart';

typedef LoadSavedClientSessionByHotelId = Future<ClientSession?> Function(
    String hotelId,
    );

class ClientEntryController extends ChangeNotifier {
  final GetOpenMenusUC getOpenMenusUC;
  final LoadSavedClientSessionByHotelId loadSavedClientSessionByHotelId;

  bool _isLoading = false;
  String? _errorMessage;

  ClientEntryController({
    required this.getOpenMenusUC,
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

  Future<ClientEntryResolution> resolveEntryFlow() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final hotelId = readHotelIdFromUrl();

      if (hotelId == null) {
        return ClientEntryResolution.invalidQr(
          'QR code non valido: hotelId mancante.',
        );
      }

      final List<Menu> openMenus = await getOpenMenusUC.execute(hotelId);

      if (openMenus.isEmpty) {
        return ClientEntryResolution.noOpenMenus(hotelId: hotelId);
      }

      final Menu selectedMenu = openMenus.first;

      final ClientSession? savedSession =
      await loadSavedClientSessionByHotelId(hotelId);

      if (savedSession != null) {
        return ClientEntryResolution.readyForMenu(
          hotelId: hotelId,
          menu: selectedMenu,
          clientSession: savedSession,
        );
      }

      return ClientEntryResolution.readyForForm(
        hotelId: hotelId,
        menu: selectedMenu,
      );
    } catch (e) {
      _errorMessage = 'Errore durante l’apertura del menu.';
      return ClientEntryResolution.invalidQr(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}