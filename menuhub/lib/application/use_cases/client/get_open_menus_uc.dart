import '../../../domain/menu_package/menu.dart';
import '../../../domain/repository/abstract_menu_repository.dart';

class GetOpenMenusUC {
  final MenuRepository menuRepository;

  GetOpenMenusUC(this.menuRepository);

  Future<List<Menu>> execute(String hotelId) {
    return menuRepository.getOpenMenus(hotelId);
  }
}