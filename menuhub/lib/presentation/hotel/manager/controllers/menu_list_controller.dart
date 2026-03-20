import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../../../application/use_cases/staff/archive_menu_uc.dart';
import '../../../../application/use_cases/staff/close_menu_uc.dart';
import '../../../../application/use_cases/staff/delete_menu_uc.dart';
import '../../../../application/use_cases/staff/get_menu_orders_count_uc.dart';
import '../../../../application/use_cases/staff/open_menu_uc.dart';
import '../../../../application/use_cases/staff/watch_menus_by_hotel_uc.dart';
import '../../../../domain/menu_package/menu.dart';
import '../models/menu_list_model.dart';

class MenuListController extends ChangeNotifier {
  final WatchMenusByHotelUC watchMenusByHotelUC;
  final OpenMenuUC openMenuUC;
  final CloseMenuUC closeMenuUC;
  final DeleteMenuUC deleteMenuUC;
  final ArchiveMenuUC archiveMenuUC;
  final GetMenuOrdersCountUC getMenuOrdersCountUC;

  MenuListModel _model = MenuListModel.initial();
  StreamSubscription? _menusSubscription;

  MenuListController({
    required this.watchMenusByHotelUC,
    required this.openMenuUC,
    required this.closeMenuUC,
    required this.deleteMenuUC,
    required this.archiveMenuUC,
    required this.getMenuOrdersCountUC,
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
          (menus) async {
        try {
          final ordersCountByMenu = await _loadOrdersCountMap(
            hotelId: hotelId,
            menus: menus,
          );

          _model = _model.copyWith(
            isLoading: false,
            menus: menus,
            ordersCountByMenu: ordersCountByMenu,
            clearError: true,
          );
          notifyListeners();
        } catch (e) {
          _model = _model.copyWith(
            isLoading: false,
            menus: menus,
            errorMessage: e.toString(),
          );
          notifyListeners();
        }
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

  Future<Map<String, int>> _loadOrdersCountMap({
    required String hotelId,
    required List<Menu> menus,
  }) async {
    final entries = await Future.wait(
      menus.map((menu) async {
        final count = await getMenuOrdersCountUC.execute(
          hotelId: hotelId,
          menuId: menu.id,
        );
        return MapEntry(menu.id, count);
      }),
    );

    return Map<String, int>.fromEntries(entries);
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

  Future<bool> deleteMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      await deleteMenuUC.execute(
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

  Future<bool> archiveMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      await archiveMenuUC.execute(
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

  int ordersCountForMenu(String menuId) {
    return _model.ordersCountByMenu[menuId] ?? 0;
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