import '../../../domain/repository/abstract_menu_repository.dart';

class OpenMenuUC {
  final MenuRepository menuRepository;

  OpenMenuUC(this.menuRepository);

  Future<void> execute({
    required String hotelId,
    required String menuId,
  }) {
    return menuRepository.openMenu(
      hotelId: hotelId,
      menuId: menuId,
    );
  }
}