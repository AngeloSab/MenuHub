import 'package:menuhub/domain/client_package/client_session.dart';
import 'package:menuhub/domain/menu_package/menu.dart';

class ClientEntryResolution {
  final String? hotelId;
  final Menu? menu;
  final ClientSession? clientSession;
  final String? errorMessage;
  final bool hasNoOpenMenus;

  const ClientEntryResolution({
    required this.hotelId,
    required this.menu,
    required this.clientSession,
    required this.errorMessage,
    required this.hasNoOpenMenus,
  });

  factory ClientEntryResolution.invalidQr(String message) {
    return ClientEntryResolution(
      hotelId: null,
      menu: null,
      clientSession: null,
      errorMessage: message,
      hasNoOpenMenus: false,
    );
  }

  factory ClientEntryResolution.noOpenMenus({
    required String hotelId,
  }) {
    return ClientEntryResolution(
      hotelId: hotelId,
      menu: null,
      clientSession: null,
      errorMessage: null,
      hasNoOpenMenus: true,
    );
  }

  factory ClientEntryResolution.readyForForm({
    required String hotelId,
    required Menu menu,
  }) {
    return ClientEntryResolution(
      hotelId: hotelId,
      menu: menu,
      clientSession: null,
      errorMessage: null,
      hasNoOpenMenus: false,
    );
  }

  factory ClientEntryResolution.readyForMenu({
    required String hotelId,
    required Menu menu,
    required ClientSession clientSession,
  }) {
    return ClientEntryResolution(
      hotelId: hotelId,
      menu: menu,
      clientSession: clientSession,
      errorMessage: null,
      hasNoOpenMenus: false,
    );
  }

  bool get hasError => errorMessage != null;
  bool get shouldOpenForm => menu != null && clientSession == null && !hasError;
  bool get shouldOpenMenu => menu != null && clientSession != null && !hasError;
}