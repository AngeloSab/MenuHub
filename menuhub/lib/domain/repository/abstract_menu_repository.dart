import '../menu_package/menu.dart';

abstract class MenuRepository {
  Future<void> save(Menu menu);

  Future<Menu?> getById({
    required String hotelId,
    required String menuId,
  });

  Future<List<Menu>> getByHotel(String hotelId);

  Stream<List<Menu>> watchByHotel(String hotelId);

  Future<List<Menu>> getOpenMenus(String hotelId);

  Stream<List<Menu>> watchOpenMenus(String hotelId);

  Future<void> openMenu({
    required String hotelId,
    required String menuId,
  });

  Future<void> closeMenu({
    required String hotelId,
    required String menuId,
  });
}