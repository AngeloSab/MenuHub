import '../../../domain/menu_package/menu.dart';
import '../../../domain/repository/abstract_menu_repository.dart';

class GetMenuByIdUC {
  final MenuRepository menuRepository;

  GetMenuByIdUC(this.menuRepository);

  Future<Menu?> execute({
    required String hotelId,
    required String menuId,
  }) {
    return menuRepository.getById(
      hotelId: hotelId,
      menuId: menuId,
    );
  }
}