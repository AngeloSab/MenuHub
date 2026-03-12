import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../application/use_cases/staff/close_menu_uc.dart';
import '../../../../application/use_cases/staff/open_menu_uc.dart';
import '../../../../application/use_cases/staff/watch_menus_by_hotel_uc.dart';
import '../models/menu_list_model.dart';

class MenuListController extends ChangeNotifier {
  final WatchMenusByHotelUC watchMenusByHotelUC;
  final OpenMenuUC openMenuUC;
  final CloseMenuUC closeMenuUC;

  MenuListModel _model = MenuListModel.initial();
  StreamSubscription? _menusSubscription;

  MenuListController({
    required this.watchMenusByHotelUC,
    required this.openMenuUC,
    required this.closeMenuUC,
  });

  MenuListModel get model => _model;

  void startWatching(String hotelId) {
    _menusSubscription?.cancel();

    _model = _model.copyWith(
      isLoading: true,
      clearError: true,
    );
    notifyListeners();

    _menusSubscription = watchMenusByHotelUC.execute(hotelId).listen(
          (menus) {
        _model = _model.copyWith(
          isLoading: false,
          menus: menus,
          clearError: true,
        );
        notifyListeners();
      },
      onError: (error) {
        _model = _model.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
        notifyListeners();
      },
    );
  }

  Future<bool> openMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      await openMenuUC.execute(
        hotelId: hotelId,
        menuId: menuId,
      );
      return true;
    } catch (e) {
      _model = _model.copyWith(
        errorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> closeMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      await closeMenuUC.execute(
        hotelId: hotelId,
        menuId: menuId,
      );
      return true;
    } catch (e) {
      _model = _model.copyWith(
        errorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _model = _model.copyWith(clearError: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _menusSubscription?.cancel();
    super.dispose();
  }
}